defmodule Issues.TableFormatter do

  import Enum, only: [ each: 2, map: 2, map_join: 3, max: 1 ]

  @doc """
  """
  def print_table_for_columns(rows, headers) do
    with data_by_columns = split_into_columns(rows, headers),
         column_widths   = widths_of(data_by_columns),
         format          = format_for(column_widths)
    do
      puts_one_line_in_columns(headers, format)
      IO.puts(separator(column_widths))
      puts_in_columns(data_by_columns, format)
    end
  end

  @doc """
  """
  def split_into_columns(rows, headers) do
    for header <- headers do
      for row <- rows, do: printable(row[header])
    end
  end

  @doc """
  """
  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  @doc """
  """
  def widths_of(columns) do
    for column <- columns, do: column |> map(&String.length/1) |> max
  end

  @doc """
  """
  def format_for(columns_widths) do
    map_join(columns_widths, " | ", fn width -> "~-#{width}s" end) <> "~n"
  end

  @doc """
  """
  def separator(column_widths) do
    map_join(column_widths, "-+-", fn width -> List.duplicate("-", width) end)
  end

  @doc """
  """
  def puts_in_columns(data_by_columns, format) do
    data_by_columns
    |> List.zip
    |> map(&Tuple.to_list/1)
    |> each(&puts_one_line_in_columns(&1, format))
  end

  @doc """
  """
  def puts_one_line_in_columns(fields, format) do
    :io.format(format, fields)
  end
end