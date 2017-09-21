defmodule Bertex do
  @moduledoc """
  This is a work TOTALLY based on @mojombo and @eproxus work:
  More at: https://github.com/eproxus/bert.erl and http://github.com/mojombo/bert.erl
  """
  import :erlang, only: [binary_to_term: 1,
                         binary_to_term: 2,
                         term_to_binary: 1]

  defprotocol Bert do
    @fallback_to_any true
    def encode(term)
    def decode(term)
  end

  defimpl Bert, for: Atom do
    def encode(false), do: {:bert, false}
    def encode(true), do: {:bert, true}
    def encode(nil), do: {:bert, nil}

    def encode(atom), do: atom

    def decode(atom), do: atom
  end

  defimpl Bert, for: List do
    def encode(list) do
      Enum.map(list, &Bert.encode(&1))
    end

    def decode(list) do
      Enum.map(list, &Bert.decode(&1))
    end
  end

  # Inspired by talentdeficit/jsex solution
  defimpl Bert, for: Tuple do
    def encode(tuple) do
      Tuple.to_list(tuple)
        |> Enum.map(&Bert.encode(&1))
        |> List.to_tuple
    end

    def decode({:bert, nil}), do: nil

    def decode({:bert, true}), do: true

    def decode({:bert, false}), do: false

    def decode({:bert, :dict, dict}), do: Enum.into(Bert.decode(dict), %{})

    def decode({:bert, :time, mega, sec, micro}) do
      unix = mega * 1000000000000 + sec * 1000000 + micro

      DateTime.from_unix!(unix, :microseconds)
    end

    def decode(tuple) do
      Tuple.to_list(tuple)
        |> Enum.map(&Bert.decode(&1))
        |> List.to_tuple
    end
  end

  defimpl Bert, for: Date do
    def encode(term) do
      {:ok, zero} = Time.new(0, 0, 0)
      {:ok, naive} = NaiveDateTime.new(term, zero)

      naive
      |> DateTime.from_naive!("Etc/UTC")
      |> Bert.encode
    end

    def decode(term), do: term
  end

  defimpl Bert, for: NaiveDateTime do
    def encode(term) do
      term
      |> DateTime.from_naive!("Etc/UTC")
      |> Bert.encode
    end

    def decode(term), do: term
  end

  defimpl Bert, for: DateTime do
    def encode(term) do
      micro = DateTime.to_unix(term, :microseconds)
      mega = micro |> div(1000000000000)
      sec = micro |> rem(1000000000000) |> div(1000000)
      micro = micro |> rem(1000000)

      {:bert, :time, mega, sec, micro}
    end

    def decode(term), do: term
  end

  defimpl Bert, for: Any do
    def encode(term), do: term
    def decode(term), do: term
  end

  @doc """
  iex> Bertex.encode([42, :banana, {:xy, 5, 10}, "robot", true, false])
  <<131,108,0,0,0,6,97,42,100,0,6,98,97,110,97,110,97,104,3,100,0,2,120,121,97,5,97,10,109,0,0,0,5,114,111,98,111,116,104,2,100,0,4,98,101,114,116,100,0,4,116,114,117,101,104,2,100,0,4,98,101,114,116,100,0,5,102,97,108,115,101,106>>
  """
  @spec encode(term) :: binary
  def encode(term) do
    Bert.encode(term) |> term_to_binary
  end

  @doc """
  iex> Bertex.decode(<<131,108,0,0,0,6,97,42,100,0,6,98,97,110,97,110,97,104,3,100,0,2,120,121,97,5,97,10,109,0,0,0,5,114,111,98,111,116,104,2,100,0,4,98,101,114,116,100,0,4,116,114,117,101,104,2,100,0,4,98,101,114,116,100,0,5,102,97,108,115,101,106>>)
  [42, :banana, {:xy, 5, 10}, "robot", true, false]

  """
  @spec decode(binary) :: term
  def decode(bin) do
    binary_to_term(bin) |> Bert.decode
  end

  @spec safe_decode(binary) :: term
  def safe_decode(bin) do
    binary_to_term(bin, [:safe]) |> Bert.decode
  end
end
