defmodule Lye.ClientGeneratorTest do
  use ExUnit.Case, async: true

  import Lye.ClientGenerator

  alias Lye.Client
  alias Lye.Client.Operation, as: ClientOperation
  alias Lye.WSDLParser.{WSDL, Operation, PortType, Service, Port}

  @fixture_path "test/fixtures/wsdl"

  test "generates client for wsdl with one operation" do
    operations = [%Operation{name: "operation", action: "action"}]
    port_type = %PortType{name: "name", operations: operations}
    service = %Service{port: %Port{address: "http://www.example.com"}}
    wsdl = %WSDL{port_type: port_type, service: service, tns: "tns"}
    client = generate(wsdl)
    expected = %Client{
      operations: %{"operation" => %ClientOperation{name: "operation", action: "action"}},
      tns: "tns",
      url: "http://www.example.com"
    }
    assert client == expected
  end

  test "generates client for wsdl with many operations" do
    operations = [%Operation{name: "operation1", action: "action1"},
      %Operation{name: "operation2", action: "action2"}]
    port_type = %PortType{name: "name", operations: operations}
    service = %Service{port: %Port{address: "http://www.example.com"}}
    wsdl = %WSDL{port_type: port_type, service: service, tns: "tns"}
    client = generate(wsdl)
    expected = %Client{
      operations: %{
        "operation1" => %ClientOperation{name: "operation1", action: "action1"},
        "operation2" => %ClientOperation{name: "operation2", action: "action2"}
      },
      tns: "tns",
      url: "http://www.example.com"
    }
    assert client == expected
  end

end
