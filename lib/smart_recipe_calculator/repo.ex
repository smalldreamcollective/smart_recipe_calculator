defmodule SmartRecipeCalculator.Repo do
  use Ecto.Repo,
    otp_app: :smart_recipe_calculator,
    adapter: Ecto.Adapters.Postgres
end
