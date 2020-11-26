defmodule Ecto.ULID do
  @moduledoc """
  An Ecto type for ULID strings.
  """

  @behaviour Ecto.Type

  @doc """
  The underlying schema type.
  """
  def type, do: :uuid

  @doc """
  Casts a string to ULID.
  """
  def cast(<<_::bytes-size(26)>> = value) do
    if valid?(value) do
      {:ok, value}
    else
      :error
    end
  end

  def cast(_), do: :error

  @doc """
  Same as `cast/1` but raises `Ecto.CastError` on invalid arguments.
  """
  def cast!(value) do
    case cast(value) do
      {:ok, ulid} -> ulid
      :error -> raise Ecto.CastError, type: __MODULE__, value: value
    end
  end

  @doc """
  Converts a Crockford Base32 encoded ULID into a binary.
  """
  def dump(<<_::bytes-size(26)>> = encoded), do: decode(encoded)
  def dump(_), do: :error

  @doc """
  Converts a binary ULID into a Crockford Base32 encoded string.
  """
  def load(<<_::unsigned-size(128)>> = bytes), do: encode(bytes)
  def load(_), do: :error

  @doc false
  def autogenerate, do: generate()

  @doc """
  Generates a Crockford Base32 encoded ULID.

  If a value is provided for `timestamp`, the generated ULID will be for the provided timestamp.
  Otherwise, a ULID will be generated for the current time.

  Arguments:

  * `timestamp`: A Unix timestamp with millisecond precision.
  """
  def generate(timestamp \\ System.system_time(:millisecond)) do
    {:ok, ulid} = encode(bingenerate(timestamp))
    ulid
  end

  @doc """
  Generates a binary ULID.

  If a value is provided for `timestamp`, the generated ULID will be for the provided timestamp.
  Otherwise, a ULID will be generated for the current time.

  Arguments:

  * `timestamp`: A Unix timestamp with millisecond precision.
  """
  def bingenerate(timestamp \\ System.system_time(:millisecond)) do
    <<timestamp::unsigned-size(48), :crypto.strong_rand_bytes(10)::binary>>
  end

  def encode(
        <<b1::3, b2::5, b3::5, b4::5, b5::5, b6::5, b7::5, b8::5, b9::5, b10::5, b11::5, b12::5,
          b13::5, b14::5, b15::5, b16::5, b17::5, b18::5, b19::5, b20::5, b21::5, b22::5, b23::5,
          b24::5, b25::5, b26::5>>
      ) do
    <<e(b1), e(b2), e(b3), e(b4), e(b5), e(b6), e(b7), e(b8), e(b9), e(b10), e(b11), e(b12),
      e(b13), e(b14), e(b15), e(b16), e(b17), e(b18), e(b19), e(b20), e(b21), e(b22), e(b23),
      e(b24), e(b25), e(b26)>>
  catch
    :error -> :error
  else
    encoded -> {:ok, encoded}
  end

  def encode(_), do: :error

  @compile {:inline, e: 1}

  def e(0), do: ?0
  def e(1), do: ?1
  def e(2), do: ?2
  def e(3), do: ?3
  def e(4), do: ?4
  def e(5), do: ?5
  def e(6), do: ?6
  def e(7), do: ?7
  def e(8), do: ?8
  def e(9), do: ?9
  def e(10), do: ?A
  def e(11), do: ?B
  def e(12), do: ?C
  def e(13), do: ?D
  def e(14), do: ?E
  def e(15), do: ?F
  def e(16), do: ?G
  def e(17), do: ?H
  def e(18), do: ?J
  def e(19), do: ?K
  def e(20), do: ?M
  def e(21), do: ?N
  def e(22), do: ?P
  def e(23), do: ?Q
  def e(24), do: ?R
  def e(25), do: ?S
  def e(26), do: ?T
  def e(27), do: ?V
  def e(28), do: ?W
  def e(29), do: ?X
  def e(30), do: ?Y
  def e(31), do: ?Z

  def decode(
        <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8, c9::8, c10::8, c11::8, c12::8,
          c13::8, c14::8, c15::8, c16::8, c17::8, c18::8, c19::8, c20::8, c21::8, c22::8, c23::8,
          c24::8, c25::8, c26::8>>
      ) do
    <<d(c1)::3, d(c2)::5, d(c3)::5, d(c4)::5, d(c5)::5, d(c6)::5, d(c7)::5, d(c8)::5, d(c9)::5,
      d(c10)::5, d(c11)::5, d(c12)::5, d(c13)::5, d(c14)::5, d(c15)::5, d(c16)::5, d(c17)::5,
      d(c18)::5, d(c19)::5, d(c20)::5, d(c21)::5, d(c22)::5, d(c23)::5, d(c24)::5, d(c25)::5,
      d(c26)::5>>
  catch
    :error -> :error
  else
    decoded -> {:ok, decoded}
  end

  def decode(_), do: :error

  @compile {:inline, d: 1}

  def d(?0), do: 0
  def d(?1), do: 1
  def d(?2), do: 2
  def d(?3), do: 3
  def d(?4), do: 4
  def d(?5), do: 5
  def d(?6), do: 6
  def d(?7), do: 7
  def d(?8), do: 8
  def d(?9), do: 9
  def d(?A), do: 10
  def d(?B), do: 11
  def d(?C), do: 12
  def d(?D), do: 13
  def d(?E), do: 14
  def d(?F), do: 15
  def d(?G), do: 16
  def d(?H), do: 17
  def d(?J), do: 18
  def d(?K), do: 19
  def d(?M), do: 20
  def d(?N), do: 21
  def d(?P), do: 22
  def d(?Q), do: 23
  def d(?R), do: 24
  def d(?S), do: 25
  def d(?T), do: 26
  def d(?V), do: 27
  def d(?W), do: 28
  def d(?X), do: 29
  def d(?Y), do: 30
  def d(?Z), do: 31
  def d(_), do: throw(:error)

  def valid?(
        <<c1::8, c2::8, c3::8, c4::8, c5::8, c6::8, c7::8, c8::8, c9::8, c10::8, c11::8, c12::8,
          c13::8, c14::8, c15::8, c16::8, c17::8, c18::8, c19::8, c20::8, c21::8, c22::8, c23::8,
          c24::8, c25::8, c26::8>>
      ) do
    v(c1) && v(c2) && v(c3) && v(c4) && v(c5) && v(c6) && v(c7) && v(c8) && v(c9) && v(c10) &&
      v(c11) && v(c12) && v(c13) &&
      v(c14) && v(c15) && v(c16) && v(c17) && v(c18) && v(c19) && v(c20) && v(c21) && v(c22) &&
      v(c23) && v(c24) && v(c25) && v(c26)
  end

  def valid?(_), do: false

  @compile {:inline, v: 1}

  def v(?0), do: true
  def v(?1), do: true
  def v(?2), do: true
  def v(?3), do: true
  def v(?4), do: true
  def v(?5), do: true
  def v(?6), do: true
  def v(?7), do: true
  def v(?8), do: true
  def v(?9), do: true
  def v(?A), do: true
  def v(?B), do: true
  def v(?C), do: true
  def v(?D), do: true
  def v(?E), do: true
  def v(?F), do: true
  def v(?G), do: true
  def v(?H), do: true
  def v(?J), do: true
  def v(?K), do: true
  def v(?M), do: true
  def v(?N), do: true
  def v(?P), do: true
  def v(?Q), do: true
  def v(?R), do: true
  def v(?S), do: true
  def v(?T), do: true
  def v(?V), do: true
  def v(?W), do: true
  def v(?X), do: true
  def v(?Y), do: true
  def v(?Z), do: true
  def v(_), do: false
end
