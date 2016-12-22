defmodule Lye.WSDLParser.WSDL do
  defstruct [port_type: nil, binding: nil, service: nil, tns: nil]
end

defmodule Lye.WSDLParser.PortType do
  defstruct [name: nil, operations: []]
end

defmodule Lye.WSDLParser.Binding do
  defstruct [:name, :port_type, :transport, :style]
end

defmodule Lye.WSDLParser.Service do
  defstruct [:name, :port]
end

defmodule Lye.WSDLParser.Port do
  defstruct [:name, :binding, :address]
end

defmodule Lye.WSDLParser.Operation  do
  defstruct [:name, :input_message, :output_message]
end
