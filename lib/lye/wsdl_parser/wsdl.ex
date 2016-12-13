defmodule Lye.WSDLParser.WSDL do
  defstruct [name: "", port_type: %Lye.WSDLParser.PortType{}, bindings: [], service: %Lye.WSDLParser.Service{}]
end

defmodule Lye.WSDLParser.PortType do
  defstruct [name: "", operations: []]
end

defmodule Lye.WSDLParser.Binding do
  defstruct [name: "", operations: [], protocol: nil, port_type: %Lye.WSDLParser.PortType{},
    transport: nil, style: nil, encoding: nil, verb: nil]
end

defmodule Lye.WSDLParser.Service do
  defstruct [name: "", ports: []]
end

defmodule Lye.WSDLParser.Port do
  defstruct [name: "", protocol: nil, binding: "", url: ""]
end

defmodule Lye.WSDLParser.Operation  do
  defstruct [name: "", input: nil, output: nil]
end
