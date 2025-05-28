defmodule SmartRecipeCalculator.Repo.Migrations.CreateIngredients do
  use Ecto.Migration

  def change do
    create table(:ingredients) do
      add :name, :string, null: false
      add :unit, :string
      add :calories, :integer
      add :protein, :decimal
      add :fat, :decimal
      add :carbs, :decimal
      timestamps()
    end
    create unique_index(:ingredients, [:name, :unit])
  end
end
