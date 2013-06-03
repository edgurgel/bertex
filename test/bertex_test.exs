Code.require_file "test_helper.exs", __DIR__

defmodule BertexTest do
  use ExUnit.Case

  doctest Bertex

  defp assert_term(term) do
    import Bertex
    assert decode(encode(term)) == term
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
    defrecord FileInfo, a: nil, b: 0, c: "default"
    file_info = FileInfo.new(a: 1, b: 2, c: 3)
    assert_term(file_info)
  end

  test "encode/decode complex list" do
    assert_term([1,2,3, false, true, {"e", "f"}])
  end

  test "encode/decode a HashDict" do
    dict = HashDict.new
      |> HashDict.put(:hello, "world")
    assert_term(dict)
  end

end
