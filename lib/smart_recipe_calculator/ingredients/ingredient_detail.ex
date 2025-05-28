defmodule SmartRecipeCalculator.Ingredients.IngredientDetail do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ingredient_details" do

    field :ingredient_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ingredient_detail, attrs) do
    ingredient_detail
    |> cast(attrs, [])
    |> validate_required([])
  end
end
