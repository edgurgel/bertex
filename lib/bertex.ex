defmodule Bertex do
  @moduledoc """
  This is a work TOTALLY based on @mojombo and @eproxus work:
  More at: https://github.com/eproxus/bert.erl and http://github.com/mojombo/bert.erl
  """
  defprotocol Bert do
    @only [Atom, Record, List, Tuple, Any]
    def encode(term)
    def decode(term)
  end

  defimpl Bert, for: Atom do
    def encode(false), do: {:bert, false}
    def encode(true), do: {:bert, true}
    def encode(atom), do: atom

    def decode(atom), do: atom
  end

  defimpl Bert, for: List do
    def encode([]), do: {:bert, nil}
    def encode(list) do
      Enum.map(list, Bert.encode(&1))
    end

    def decode(list) do
      Enum.map(list, Bert.decode(&1))
    end
  end

  # Inspired by talentdeficit/jsex solution
  defimpl Bert, for: Tuple do
    def encode(tuple) when is_record(tuple) do
      if function_exported?(elem(tuple, 0), :__record__, 1) do
        key_values = Enum.map(tuple.__record__(:fields),
          fn({ key, _ }) ->
            index = tuple.__index__(key)
            value = elem(tuple, index)
            { key, value }
          end)
        { :bert, :dict, key_values }
      else
        # Tuple is not actually a record
        encode_tuple(tuple)
      end
    end
    def encode(tuple) do
      encode_tuple(tuple)
    end

    defp encode_tuple(tuple) do
      tuple_to_list(tuple)
      |> Enum.map(Bert.encode(&1))
      |> list_to_tuple
    end

    def decode({:bert, nil}), do: []

    def decode({:bert, true}), do: true

    def decode({:bert, false}), do: false

    def decode({:bert, :dict, dict}), do: HashDict.new(dict)

    def decode(tuple) do
      tuple_to_list(tuple)
        |> Enum.map(Bert.decode(&1))
        |> list_to_tuple
    end
  end

  defimpl Bert, for: HashDict do
    def encode(dict), do: {:bert, :dict, HashDict.to_list(dict)}
    # This should never happen.
    def decode(dict), do: HashDict.new(dict)
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
    Bert.encode(term)
      |> term_to_binary
  end

  @doc """
  iex> Bertex.decode(<<131,108,0,0,0,6,97,42,100,0,6,98,97,110,97,110,97,104,3,100,0,2,120,121,97,5,97,10,109,0,0,0,5,114,111,98,111,116,104,2,100,0,4,98,101,114,116,100,0,4,116,114,117,101,104,2,100,0,4,98,101,114,116,100,0,5,102,97,108,115,101,106>>)
  [42, :banana, {:xy, 5, 10}, "robot", true, false]

  """
  @spec decode(binary) :: term
  def decode(bin) do
    binary_to_term(bin)
      |> Bert.decode
  end

end
