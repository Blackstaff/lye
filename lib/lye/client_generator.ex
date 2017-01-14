defmodule Lye.ClientGenerator do
  @moduledoc false
  
  alias Lye.Client

  def generate(wsdl) do
    operations = wsdl.port_type.operations
    |> Stream.map(&( wsdl |> generate_operation(&1) ))
    |> Enum.reduce(%{}, fn(op, acc) -> Enum.into([op], acc) end)
    %Client{operations: operations, tns: wsdl.tns, url: wsdl.service.port.address}
  end

  defp generate_operation(_wsdl, operation) do
    {operation.name, operation.name}
  end
end
