defmodule SmartRecipeCalculator.IngredientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SmartRecipeCalculator.Ingredients` context.
  """

  @doc """
  Generate a ingredient.
  """
  def ingredient_fixture(attrs \\ %{}) do
    {:ok, ingredient} =
      attrs
      |> Enum.into(%{
        calories: 42,
        carbs: "120.5",
        fat: "120.5",
        name: "some name",
        protein: "120.5",
        unit: "some unit"
      })
      |> SmartRecipeCalculator.Ingredients.create_ingredient()

    ingredient
  end

  @doc """
  Generate a ingredient_detail.
  """
  def ingredient_detail_fixture(attrs \\ %{}) do
    {:ok, ingredient_detail} =
      attrs
      |> Enum.into(%{

      })
      |> SmartRecipeCalculator.Ingredients.create_ingredient_detail()

    ingredient_detail
  end
end
