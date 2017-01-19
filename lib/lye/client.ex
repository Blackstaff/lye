defmodule Lye.Client do
  @moduledoc false

  alias Lye.Client.Envelope
  alias Lye.Client.Response

  defstruct [operations: %{}, url: nil, tns: nil]

  def call(client, operation_name, parameters) do
    operation = client.operations[operation_name]
    body = parameters
    |> Envelope.envelope(operation.name, client.tns)
    headers = [{"Content-Type", "text/xml; charset=utf-8"}, {"SOAPAction", operation.action}]
    client.url
    |> HTTPoison.post(body, headers)
    |> parse_response()
  end

  defp parse_response({:error, msg}), do: {:error, msg}
  defp parse_response({:ok, %{body: response, status_code: status}})
    when div(status, 100) == 2, do: {:ok, response |> Response.parse()}
  defp parse_response({:ok, %{body: response}}),
    do: {:error, response}
end
