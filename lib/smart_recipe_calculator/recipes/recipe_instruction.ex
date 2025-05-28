defmodule SmartRecipeCalculator.Recipes.RecipeInstruction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipe_instructions" do
    belongs_to :recipe, SmartRecipeCalculator.Recipes.Recipe
    belongs_to :instruction, SmartRecipeCalculator.Instructions.Instruction
    field :step_number, :integer
    timestamps()
  end

  def changeset(recipe_instruction, attrs) do
    recipe_instruction
    |> cast(attrs, [:recipe_id, :instruction_id, :step_number])
    |> validate_required([:recipe_id, :instruction_id, :step_number])
  end
end
