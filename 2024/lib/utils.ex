defmodule Utils do
  def dump_to_file(anything, label \\ "", opts \\ []) do
    File.write(
      "./dump.log",
      label <> "\n" <> dump_to_string(anything) <> "\n",
      [:append] ++ opts
    )

    anything
  end

  def dump_to_string(anything) when is_binary(anything), do: anything

  def dump_to_string(anything, opts \\ []) do
    inspect(
      anything,
      [limit: :infinity, printable_limit: :infinity, pretty: true, charlists: :as_lists] ++ opts
    )
  end
end
