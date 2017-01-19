defmodule Lye do
  use Application

  alias Lye.WSDLParser
  alias Lye.ClientGenerator
  alias Lye.Client

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Lye.Worker.start_link(arg1, arg2, arg3)
      # worker(Lye.Worker, [arg1, arg2, arg3]),
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Lye.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def generate_client(wsdl_url) do
    {:ok, response} = HTTPoison.get(wsdl_url)
    {:ok, wsdl} = response.body
    |> WSDLParser.parse()
    wsdl
    |> ClientGenerator.generate()
  end

  defdelegate call(client, operation_name, parameters), to: Client
end
