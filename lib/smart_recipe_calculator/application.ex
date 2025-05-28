defmodule SmartRecipeCalculator.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SmartRecipeCalculatorWeb.Telemetry,
      SmartRecipeCalculator.Repo,
      {DNSCluster, query: Application.get_env(:smart_recipe_calculator, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SmartRecipeCalculator.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SmartRecipeCalculator.Finch},
      # Start a worker by calling: SmartRecipeCalculator.Worker.start_link(arg)
      # {SmartRecipeCalculator.Worker, arg},
      # Start to serve requests, typically the last entry
      SmartRecipeCalculatorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SmartRecipeCalculator.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SmartRecipeCalculatorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
