defmodule Lye.WSDLParser.WSDL do
  @type t :: %Lye.WSDLParser.WSDL{}

  defstruct [port_type: nil, binding: nil, service: nil, tns: nil]
end

defmodule Lye.WSDLParser.PortType do
  @type t :: %Lye.WSDLParser.PortType{}

  defstruct [name: nil, operations: []]
end

defmodule Lye.WSDLParser.Binding do
  @type t :: %Lye.WSDLParser.Binding{}

  defstruct [:name, :port_type, :transport, :style]
end

defmodule Lye.WSDLParser.Service do
  @type t :: %Lye.WSDLParser.Service{}

  defstruct [:name, :port]
end

defmodule Lye.WSDLParser.Port do
  @type t :: %Lye.WSDLParser.Port{}

  defstruct [:name, :binding, :address]
end

defmodule Lye.WSDLParser.Operation  do
  @type t :: %Lye.WSDLParser.Operation{}

  defstruct [:name, :input_message, :output_message, :action]
end
