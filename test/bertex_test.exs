Code.require_file "test_helper.exs", __DIR__

defmodule BertexTest do
  use ExUnit.Case
  import Bertex

  doctest Bertex

  # Just a example Record
  defrecord FileInfo, a: nil, b: 0, c: "default"

  defp assert_term(term) do
    assert decode(encode(term)) == term
  end

  test "encode true" do
    assert binary_to_term(encode(true)) == {:bert, true}
  end

  test "encode false" do
    assert binary_to_term(encode(false)) == {:bert, false}
  end

  test "encode integer" do
    assert binary_to_term(encode(1)) == 1
  end

  test "encode float" do
    assert binary_to_term(encode(3.14)) == 3.14
  end

  test "encode binary" do
    assert binary_to_term(encode("binary string")) == "binary string"
  end

  test "encode atom" do
    assert binary_to_term(encode(:atom)) == :atom
  end

  test "encode empty list" do
    assert binary_to_term(encode([])) == {:bert, nil}
  end

  test "encode list" do
    assert binary_to_term(encode([1, 2, 3])) == [1, 2, 3]
  end

  test "encode HashDict" do
    dict = HashDict.new
      |> HashDict.put(:key, "value")
    assert binary_to_term(encode(dict)) == {:bert, :dict, key: "value"}
  end

  test "encode Record" do
    file_info = FileInfo.new(a: 1, b: 2, c: 3)
    assert binary_to_term(encode(file_info)) == {:bert, :dict, a: 1, b: 2, c: 3}
  end

  test "encode complex Record" do
    file_info = FileInfo.new(a: 1, b: [1, 2, 3], c: false)
    assert binary_to_term(encode(file_info)) == {:bert, :dict, a: 1, b: [1, 2, 3], c: {:bert, false}}
  end

  test "decode true" do
    assert decode(term_to_binary({:bert, true})) == true
  end

  test "decode false" do
    assert decode(term_to_binary({:bert, false})) == false
  end

  test "decode integer" do
    assert decode(term_to_binary(1)) == 1
  end

  test "decode float" do
    assert decode(term_to_binary(3.14)) == 3.14
  end

  test "decode binary" do
    assert decode(term_to_binary("binary string")) == "binary string"
  end

  test "decode atom" do
    assert decode(term_to_binary(:atom)) == :atom
  end

  test "decode empty list" do
    assert decode(term_to_binary({:bert, nil})) == []
  end

  test "decode list" do
    assert decode(term_to_binary([1, 2, 3])) == [1, 2, 3]
  end

  test "decode HashDict" do
    dict = HashDict.new
      |> HashDict.put(:key, "value")
    assert decode(term_to_binary({:bert, :dict, key: "value"})) == dict
  end

  test "encode/decode true" do
    assert_term(true)
  end

  test "encode/decode false" do
    assert_term(false)
  end

  test "encode/decode integer" do
    assert_term(1)
  end

  test "encode/decode float" do
    assert_term(1.1)
  end

  test "encode/decode binary" do
    assert_term("binary text")
  end

  test "encode/decode list of integers" do
    assert_term([1, 2, 3])
  end

  test "encode/decode a dict" do
    assert_term([{'a', :b}])
  end

  test "encode/decode empty list" do
    assert_term([])
  end

  test "encode/decode Elixir record" do
    file_info = FileInfo.new(a: 1, b: 2, c: 3)
    assert decode(encode(file_info)) == HashDict.new(a: 1, b: 2, c: 3)
  end

  test "encode/decode complex list" do
    assert_term([1,2,3, false, true, {"e", "f"}])
  end

  test "encode/decode a HashDict" do
    HashDict.new
      |> HashDict.put(:hello, "world")
      |> assert_term
  end

end
