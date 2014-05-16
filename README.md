[![Build Status](https://travis-ci.org/edgurgel/bertex.png?branch=master)](https://travis-ci.org/edgurgel/bertex)
# Bertex

Elixir BERT encoder/decoder. See http://bert-rpc.org for full spec.

The following types can be automatically encoded and decoded.


    integer   <-> BERT integer
    float     <-> BERT float
    atom      <-> BERT atom
    tuple     <-> BERT tuple
    list      <-> BERT list or BERT bytelist
    binary    <-> BERT binary
    []        <-> BERT nil (complex)
    bool      <-> BERT boolean (complex)
    Map       <-> BERT dict (complex)
    HashDict   -> BERT dict (complex)
    Record     -> BERT dict (complex)

To encode Elixir terms to BERT binaries, use:

    Bertex.encode(term) -> binary

To decode BERT binaries to Elixir terms, use:

    Bertex.decode(binary) -> term

To [safely](http://www.erlang.org/doc/man/erlang.html#binary_to_term-2) decode BERT binaries to Elixir terms, use:

    Bertex.safe_decode(binary) -> term

Examples

```iex
iex> Bertex.encode([42, :banana, {:xy, 5, 10}, "robot", true, false])
<<131,108,0,0,0,6,97,42,100,0,6,98,97,110,97,110,97,104,3,100,0,2,120,121,97,5,97,10,109,0,0,0,5,114,111,98,111,116,104,2,100,0,4,98,101,114,116,100,0,4,116,114,117,101,104,2,100,0,4,98,101,114,116,100,0,5,102,97,108,115,101,106>>

iex> Bertex.decode(<<131,108,0,0,0,6,97,42,100,0,6,98,97,110,97,110,97,104,3,100,0,2,120,121,97,5,97,10,109,0,0,0,5,114,111,98,111,116,104,2,100,0,4,98,101,114,116,100,0,4,116,114,117,101,104,2,100,0,4,98,101,114,116,100,0,5,102,97,108,115,101,106>>)
[42, :banana, {:xy, 5, 10}, "robot", true, false]

iex> dict = HashDict.new |> HashDict.put(:hello, "world") |> Bertex.encode
<<131,104,3,100,0,4,98,101,114,116,100,0,4,100,105,99,116,108,0,0,0,1,104,2,100,0,5,104,101,108,108,111,109,0,0,0,5,119,111,114,108,100,106>>

iex> %{hello: "world"} |> Bertex.encode
<<131, 104, 3, 100, 0, 4, 98, 101, 114, 116, 100, 0, 4, 100, 105, 99, 116, 108, 0, 0, 0, 1, 104, 2, 100, 0, 5, 104, 101, 108, 108, 111, 109, 0, 0, 0, 5, 119, 111, 114, 108, 100, 106>>

iex> defrecord FileInfo, a: 1, b: 0, c: "default"
iex> Bertex.decode(Bertex.encode(FileInfo.new))
%{a: 1, b: 0, c: "default"}
```
