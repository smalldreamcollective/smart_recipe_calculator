defmodule SmartRecipeCalculator.Recipes.RecipeDetail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipe_details" do

    field :recipe_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe_detail, attrs) do
    recipe_detail
    |> cast(attrs, [])
    |> validate_required([])
  end
end
