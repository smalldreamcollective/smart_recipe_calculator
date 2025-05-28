defmodule SmartRecipeCalculator.Recipes.RecipeIngredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipe_ingredients" do
    field :quantity, :decimal
    belongs_to :recipe, SmartRecipeCalculator.Recipes.Recipe
    belongs_to :ingredient, SmartRecipeCalculator.Ingredients.Ingredient

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe_ingredient, attrs) do
    recipe_ingredient
    |> cast(attrs, [:quantity, :recipe_id, :ingredient_id])
    |> validate_required([:quantity, :recipe_id, :ingredient_id])
  end
end
