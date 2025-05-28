defmodule SmartRecipeCalculator.Repo.Migrations.CreateIngredientDetails do
  use Ecto.Migration

  def change do
    create table(:ingredient_details) do
      add :ingredient_id, references(:ingredients, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:ingredient_details, [:ingredient_id])
  end
end
