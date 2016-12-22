defmodule Lye.ClientGeneratorTest do
  use ExUnit.Case, async: true

  import Lye.ClientGenerator

  setup_all do
    article_wsdl = File.read!(Path.join(@fixture_path, "article_service.xml"))
    measurement_wsdl = File.read!(Path.join(@fixture_path, "measurement_service.xml"))
    {:ok, %{article: article_wsdl,
      blz: blz_wsdl,
      measurement: measurement_wsdl
    }}
  end

  test "generates client for wsdl with one operation", context do
  end

  test "generates client for wsdl with many operations", context do
  end

end
