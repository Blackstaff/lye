defmodule Lye.Client do
  @moduledoc false

  alias Lye.Client.Envelope

  defstruct [operations: %{}, url: nil, tns: nil]

  def call(client, operation_name, parameters) do
    operation = client.operations[operation_name]
    body = parameters
    |> Envelope.envelope(operation.name, client.tns)
    headers = [{"Content-Type", "text/xml; charset=utf-8"}, {"SOAPAction", operation.action}]
    HTTPoison.post(client.url, body, headers)
  end
end
