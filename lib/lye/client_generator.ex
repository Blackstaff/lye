defmodule Lye.Client do
  defstruct [operations: %{}]
end

defmodule Lye.ClientGenerator do
  import Lye.WSDLParser

  def generate(wsdl) do
  end

  defp generate_operation(wsdl, operation) do
  end
end
