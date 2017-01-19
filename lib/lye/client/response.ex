defmodule Lye.Client.Response do
  @moduledoc false

  def parse(doc) do
    doc
    |> XmlToMap.naive_map()
    |> clean()
  end

  defp clean(parsed_doc) do
    keys = parsed_doc
    |> clean([])
    |> Enum.reverse

    parsed_doc
    |> get_in(keys)
    |> remove_namespaces()
  end

  defp clean(:halt, keys), do: keys
  defp clean(parsed_doc, keys) when map_size(parsed_doc) > 1, do: keys
  defp clean(parsed_doc, keys) do
    key = parsed_doc
    |> Map.keys()
    |> hd()
    case v = parsed_doc[key] do
      _ when is_list(v) or (map_size(v) > 1) -> clean(:halt, [key | keys])
      v -> clean(v, [key | keys])
    end
  end

  defp remove_namespaces(parsed_doc) do
    parsed_doc
    |> Iteraptor.to_flatmap()
    |> Enum.reduce(%{}, fn({k, v}, acc) ->
      new_key = k |> String.replace(~r/\{.*\}/, "")
      acc |> Map.put(new_key, v)
    end)
    |> Iteraptor.from_flatmap()
  end
end
