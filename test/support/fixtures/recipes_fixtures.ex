defmodule SmartRecipeCalculator.RecipesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SmartRecipeCalculator.Recipes` context.
  """

  @doc """
  Generate a recipe.
  """
  def recipe_fixture(attrs \\ %{}) do
    {:ok, recipe} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name"
      })
      |> SmartRecipeCalculator.Recipes.create_recipe()

    recipe
  end

  @doc """
  Generate a recipe_detail.
  """
  def recipe_detail_fixture(attrs \\ %{}) do
    {:ok, recipe_detail} =
      attrs
      |> Enum.into(%{

      })
      |> SmartRecipeCalculator.Recipes.create_recipe_detail()

    recipe_detail
  end
end
