defmodule SmartRecipeCalculator.Ingredients.Ingredient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ingredients" do
    field :name, :string
    field :unit, :string
    field :calories, :integer
    field :protein, :decimal
    field :fat, :decimal
    field :carbs, :decimal

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(ingredient, attrs) do
    ingredient
    |> cast(attrs, [:name, :unit, :calories, :protein, :fat, :carbs])
    |> validate_required([:name, :unit, :calories, :protein, :fat, :carbs])
  end
end
