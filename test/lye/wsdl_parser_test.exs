defmodule Lye.WSDLParserTest do
  use ExUnit.Case, async: true

  import Lye.WSDLParser

  alias Lye.WSDLParser.{Binding, Operation, Port}

  @fixture_path "test/fixtures/wsdl"

  setup_all do
    article_wsdl = File.read!(Path.join(@fixture_path, "article_service.xml"))
    blz_wsdl = File.read!(Path.join(@fixture_path, "blz_service.xml"))
    nosoap_wsdl = File.read!(Path.join(@fixture_path, "no_soap11.xml"))
    measurement_wsdl = File.read!(Path.join(@fixture_path, "measurement_service.xml"))
    too_many_ports = File.read!(Path.join(@fixture_path, "multiple_soap11_ports.xml"))
    multiple_services = File.read!(Path.join(@fixture_path, "multiple_services.xml"))
    bible_wsdl = File.read!(Path.join(@fixture_path, "bible.xml"))
    {:ok, %{article: article_wsdl,
      blz: blz_wsdl,
      measurement: measurement_wsdl,
      nosoap: nosoap_wsdl,
      too_many_ports: too_many_ports,
      multiple_services: multiple_services,
      bible: bible_wsdl
    }}
  end

  test "parses file with single SOAP 1.1 binding", context do
    {:ok, wsdl} = parse(context[:measurement])
    expected_port = %Port{
      name: "MeasurementService",
      binding: "MeasurementService",
      address: "http://jpmaergk.p50.weaved.com/soap/measurement_service"
    }
    expected_binding = %Binding{
      name: "MeasurementService",
      port_type: "MeasurementService",
      style: "document",
      transport: "http://schemas.xmlsoap.org/soap/http"
    }
    assert wsdl.service.port === expected_port
    assert wsdl.binding === expected_binding
  end

  test "parses file with multiple bindings (one of which is SOAP 1.1)", context do
    {:ok, wsdl} = parse(context[:blz])
    expected_port = %Port{
      name: "BLZServiceSOAP11port_http",
      binding: "BLZServiceSOAP11Binding",
      address: "http://www.thomas-bayer.com:80/axis2/services/BLZService",
    }
    expected_binding = %Binding{
      name: "BLZServiceSOAP11Binding",
      port_type: "BLZServicePortType",
      style: "document",
      transport: "http://schemas.xmlsoap.org/soap/http"
    }
    assert wsdl.service.port === expected_port
    assert wsdl.binding === expected_binding
  end

  test "parses WSDL with single operation", context do
    {:ok, wsdl} = parse(context[:measurement])
    expected = [%Operation{name: "get_measurements",
      input_message: "get_measurements",
      output_message: "get_measurementsResponse",
      }]
    assert wsdl.port_type.operations === expected
  end

  test "parses WSDL with multiple operations", context do
    {:ok, wsdl} = parse(context[:article])
    expected = MapSet.new([
      %Operation{name: "create",
      input_message: "createRequest",
      output_message: "createResponse"
      },
      %Operation{name: "get",
      input_message: "getRequest",
      output_message: "getResponse",
      },
      %Operation{name: "delete",
      input_message: "deleteRequest",
      output_message: "deleteResponse",
      },
    ])
    assert MapSet.new(wsdl.port_type.operations) === expected
  end

  test "return error if no eligable port was found", context do
    assert parse(context[:nosoap]) == {:error, "No eligable port found"}
  end

  test "returns error if multiple SOAP 1.1 ports were found", context do
    assert parse(context[:too_many_ports]) == {:error, "More than one SOAP 1.1 port was found"}
  end

  test "returns error if multiple services were found", context do
    assert parse(context[:multiple_services]) == {:error, "More than one service was found"}
  end

  test "returns error if unsupported binding style was found", context do
    assert parse(context[:bible]) == {:error, "Binding style not supported: rpc"}
  end
end
