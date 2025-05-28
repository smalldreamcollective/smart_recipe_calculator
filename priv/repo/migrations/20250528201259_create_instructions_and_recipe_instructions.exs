defmodule SmartRecipeCalculator.Repo.Migrations.CreateInstructionsAndRecipeInstructions do
  use Ecto.Migration

  def change do
    create table(:instructions) do
      add :text, :text, null: false
      timestamps()
    end

    create table(:recipe_instructions) do
      add :recipe_id, references(:recipes, on_delete: :delete_all), null: false
      add :instruction_id, references(:instructions, on_delete: :delete_all), null: false
      add :step_number, :integer, null: false
      timestamps()
    end

    create index(:recipe_instructions, [:recipe_id])
    create index(:recipe_instructions, [:instruction_id])
    create unique_index(:recipe_instructions, [:recipe_id, :step_number])
  end
end
