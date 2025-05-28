defmodule SmartRecipeCalculator.Repo.Migrations.AddRecipeDetailsFields do
  use Ecto.Migration

  def change do
    alter table(:recipes) do
      add :instructions, :text
      add :prep_time, :integer
      add :cook_time, :integer
      add :servings, :integer
      add :difficulty, :string
    end
  end
end
