defmodule AoC.Day16_p2 do
  # Mostly copied from https://github.com/dallagi/aoc2021/blob/main/lib/aoc2021/day16.ex
  # Letting go trying to slog through it without help.
  # I learned way more reading through this solution than I learned in the
  # 6+ hours trying to figure out part 2 on my own.

  def get_input(file) do
    File.read!(Path.join(__DIR__, file))
    |> String.split("\n", trim: true)
    |> Enum.map(&Base.decode16!(&1))
  end

  def part2(input) do
    {instructions, _} =
      get_input(input)
      |> Enum.at(0)
      |> decode()

    process_instructions(instructions)
  end

  defp decode(<<_version::size(3), 4::size(3), rest::bits>>) do
    {rest, value} = read_packet_type_4(rest)
    {{:literal, value}, rest}
  end

  defp decode(<<_version::size(3), operator_type::size(3), rest::bits>>) do
    {operator_payload, rest} = decode_operator(rest)
    {{:operator, operator_type, operator_payload}, rest}
  end

  defp decode(_), do: {nil, nil}

  defp read_packet_type_4(packet, value \\ <<>>)

  defp read_packet_type_4(<<0::size(1), group::size(4), rest::bitstring>>, value) do
    final = <<value::bitstring, group::4>>
    size = bit_size(final)
    <<n::size(size)>> = final
    {rest, n}
  end

  defp read_packet_type_4(<<1::size(1), group::size(4), rest::bitstring>>, value),
    do: read_packet_type_4(rest, <<value::bitstring, group::4>>)

  defp decode_operator(<<0::size(1), length::size(15), payload::bits-size(length), rest::bits>>) do
    {decode_packets(payload), rest}
  end

  defp decode_operator(<<1::size(1), subpackets_count::size(11), rest::bits>>) do
    decode_n_packets(rest, subpackets_count)
  end

  defp decode_packets(payload, accumulator \\ []) do
    {packet_chunk, rest} = decode(payload)

    if packet_chunk != nil do
      decode_packets(rest, [packet_chunk | accumulator])
    else
      Enum.reverse(accumulator)
    end
  end

  defp decode_n_packets(payload, count, accumulator \\ []) do
    if count == 0 do
      {Enum.reverse(accumulator), payload}
    else
      {packet_chunk, rest} = decode(payload)
      decode_n_packets(rest, count - 1, [packet_chunk | accumulator])
    end
  end

  defp process_instructions({:literal, value}), do: value

  defp process_instructions({:operator, 0 = _sum, payload}) do
    Enum.map(payload, &process_instructions/1)
    |> Enum.sum()
  end

  defp process_instructions({:operator, 1 = _product, payload}) do
    Enum.map(payload, &process_instructions/1)
    |> Enum.product()
  end

  defp process_instructions({:operator, 2 = _minimum, payload}) do
    Enum.map(payload, &process_instructions/1)
    |> Enum.min()
  end

  defp process_instructions({:operator, 3 = _maximum, payload}) do
    Enum.map(payload, &process_instructions/1)
    |> Enum.max()
  end

  defp process_instructions({:operator, 5 = _maximum, payload}) do
    [value1, value2] = Enum.map(payload, &process_instructions/1)
    if value1 > value2, do: 1, else: 0
  end

  defp process_instructions({:operator, 6 = _maximum, payload}) do
    [value1, value2] = Enum.map(payload, &process_instructions/1)
    if value1 < value2, do: 1, else: 0
  end

  defp process_instructions({:operator, 7 = _equals, payload}) do
    [value1, value2] = Enum.map(payload, &process_instructions/1)
    if value1 == value2, do: 1, else: 0
  end
end
