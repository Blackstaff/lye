defmodule Lye.ClientGenerator.EnvelopeTest do
  use ExUnit.Case, async: true

  import SweetXml
  import Lye.ClientGenerator.Envelope

  test "generates envelope for operation" do
    operation = "get_measurements"
    parameters = %{
      "measurement_type": "humidity",
      "from_datetime": "2016-11-01T00:00:00",
      "to_datetime": "2016-11-30T00:00:00"
    }
    doc = envelope(parameters, operation, "tns")
    |> parse(namespace_conformant: true)
    |> xpath(~x"//x:Envelope/x:Body/tns:#{operation}")

    result = %{
      "measurement_type": xpath(doc, ~x"./tns:measurement_type/text()"s),
      "from_datetime": xpath(doc, ~x"./tns:from_datetime/text()"s),
      "to_datetime": xpath(doc, ~x"./tns:to_datetime/text()"s)
    }
    assert result == parameters
  end
end
