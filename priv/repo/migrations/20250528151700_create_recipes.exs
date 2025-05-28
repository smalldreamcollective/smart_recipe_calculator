defmodule SmartRecipeCalculator.Repo.Migrations.CreateRecipes do
  use Ecto.Migration

  def change do
    create table(:recipes) do
      add :name, :string, null: false
      add :description, :text
      add :instructions, :text
      add :prep_time, :integer
      add :cook_time, :integer
      add :servings, :integer
      add :difficulty, :string
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create index(:recipes, [:user_id])
  end
end
