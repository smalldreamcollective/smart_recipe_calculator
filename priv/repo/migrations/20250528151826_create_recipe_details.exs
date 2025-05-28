defmodule SmartRecipeCalculator.Repo.Migrations.CreateRecipeDetails do
  use Ecto.Migration

  def change do
    create table(:recipe_details) do
      add :recipe_id, references(:recipes, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:recipe_details, [:recipe_id])
  end
end
