defmodule Lye.ClientGenerator.Envelope do
  import XmlBuilder

  @soap11_env "http://schemas.xmlsoap.org/soap/envelope/"

  def envelope(parameters, operation_name, tns) do
    {
      :"x:Envelope",
      %{:"xmlns:x" => @soap11_env, :"xmlns:tns" => tns},
      [
        element(:"x:Header"),
        element(:"x:Body",
          [element(:"tns:#{operation_name}", prepare_parameters(parameters))]
        )
      ]
    }
    |> generate
  end

  defp prepare_parameters(parameters) do
    parameters
    |> Enum.map(fn({k, v}) ->
      element({:"tns:#{k}",  v})
    end)
  end
end
