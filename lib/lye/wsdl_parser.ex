defmodule Lye.WSDLParser do
  import SweetXml

  alias Lye.WSDLParser.{WSDL, Service, Port, Binding, PortType, Operation}

  def parse(description) do
    description
    |> SweetXml.parse()
    |> parse_service
    |> parse_binding(description)
    |> parse_port_type(description)
  end

  defp add_to_wsdl(_, {:error, msg}, _), do: {:error, msg}
  defp add_to_wsdl(wsdl, {:ok, prop}, prop_name) do
    {:ok, wsdl |> struct(Map.new([{prop_name, prop}]))}
  end

  defp parse_service(raw_desc) do
    check = fn
      ([service_name | []]) -> {:ok, service_name}
      (services) when length(services) > 1 -> {:error, "More than one service was found"}
    end

    service = raw_desc
    |> xpath(~x"//wsdl:service/@name"ls)
    |> check.()
    |> parse_port(raw_desc)

    %WSDL{}
    |> add_to_wsdl(service, :service)
  end

  defp parse_port({:error, msg}, _), do: {:error, msg}
  defp parse_port({:ok, service_name}, raw_desc) do
    to_port = fn
      ([port | []]) -> {:ok, struct(Port, port)}
      ([]) -> {:error, "No eligable port found"}
      (ports) when length(ports) > 1 -> {:error, "More than one SOAP 1.1 port was found"}
    end

    raw_desc
    |> xpath(
      ~x"//wsdl:service[@name='#{service_name}']/wsdl:port"l,
      name: ~x"./@name"s,
      binding: ~x"./@binding"s |> transform_by(&remove_namespace/1),
      address: ~x"./soap:address/@location"s
    )
    |> Enum.filter(&( &1[:address] != "" ))
    |> to_port.()
    |> to_service(service_name)
  end

  defp to_service({:error, msg}, _), do: {:error, msg}
  defp to_service({:ok, port}, name), do: {:ok, %Service{name: name, port: port}}

  defp parse_binding({:error, msg}, _), do: {:error, msg}
  defp parse_binding({:ok, wsdl}, raw_desc) do
    check = fn
      (binding = %Binding{style: "document"}) -> {:ok, binding}
      (binding = %Binding{style: style}) -> {:error, "Binding style not supported: #{style}"}
    end

    binding_name = wsdl.service.port.binding

    xpath_desc = raw_desc
    |> xpath(~x"//wsdl:binding[@name='#{binding_name}']")

    binding = %Binding{
      name: binding_name,
      port_type: xpath(xpath_desc, ~x"./@type"s |> transform_by(&remove_namespace/1)),
      style: xpath(xpath_desc, ~x"./soap:binding/@style"s),
      transport: xpath(xpath_desc, ~x"./soap:binding/@transport"s)
    }
    |> check.()

    wsdl
    |> add_to_wsdl(binding, :binding)
  end

  defp parse_port_type({:error, msg}, _), do: {:error, msg}
  defp parse_port_type({:ok, wsdl}, raw_desc) do
    port_type_name = wsdl.binding.port_type
    operations = raw_desc
    |> xpath(~x"//wsdl:portType[@name='#{port_type_name}']")
    |> parse_operations

    port_type = {:ok, %PortType{name: port_type_name, operations: operations}}
    wsdl
    |> add_to_wsdl(port_type, :port_type)
  end

  defp parse_operations(desc) do
    desc
    |> xpath(
      ~x"./wsdl:operation"l,
      name: ~x"./@name"s,
      input_message: ~x"./wsdl:input/@message"s |> transform_by(&remove_namespace/1),
      output_message: ~x"./wsdl:output/@message"s |> transform_by(&remove_namespace/1)
    )
    |> Enum.map(&( struct(Operation, &1) ))
  end

  defp remove_namespace(string), do: string |> String.replace(~r/\w*:/, "")
end
