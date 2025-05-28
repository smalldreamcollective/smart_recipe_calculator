defmodule SmartRecipeCalculator.RecipesTest do
  use SmartRecipeCalculator.DataCase

  alias SmartRecipeCalculator.Recipes

  describe "recipes" do
    alias SmartRecipeCalculator.Recipes.Recipe

    import SmartRecipeCalculator.RecipesFixtures

    @invalid_attrs %{name: nil, description: nil}

    test "list_recipes/0 returns all recipes" do
      recipe = recipe_fixture()
      assert Recipes.list_recipes() == [recipe]
    end

    test "get_recipe!/1 returns the recipe with given id" do
      recipe = recipe_fixture()
      assert Recipes.get_recipe!(recipe.id) == recipe
    end

    test "create_recipe/1 with valid data creates a recipe" do
      valid_attrs = %{name: "some name", description: "some description"}

      assert {:ok, %Recipe{} = recipe} = Recipes.create_recipe(valid_attrs)
      assert recipe.name == "some name"
      assert recipe.description == "some description"
    end

    test "create_recipe/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe(@invalid_attrs)
    end

    test "update_recipe/2 with valid data updates the recipe" do
      recipe = recipe_fixture()
      update_attrs = %{name: "some updated name", description: "some updated description"}

      assert {:ok, %Recipe{} = recipe} = Recipes.update_recipe(recipe, update_attrs)
      assert recipe.name == "some updated name"
      assert recipe.description == "some updated description"
    end

    test "update_recipe/2 with invalid data returns error changeset" do
      recipe = recipe_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe(recipe, @invalid_attrs)
      assert recipe == Recipes.get_recipe!(recipe.id)
    end

    test "delete_recipe/1 deletes the recipe" do
      recipe = recipe_fixture()
      assert {:ok, %Recipe{}} = Recipes.delete_recipe(recipe)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe!(recipe.id) end
    end

    test "change_recipe/1 returns a recipe changeset" do
      recipe = recipe_fixture()
      assert %Ecto.Changeset{} = Recipes.change_recipe(recipe)
    end
  end

  describe "recipe_details" do
    alias SmartRecipeCalculator.Recipes.RecipeDetail

    import SmartRecipeCalculator.RecipesFixtures

    @invalid_attrs %{}

    test "list_recipe_details/0 returns all recipe_details" do
      recipe_detail = recipe_detail_fixture()
      assert Recipes.list_recipe_details() == [recipe_detail]
    end

    test "get_recipe_detail!/1 returns the recipe_detail with given id" do
      recipe_detail = recipe_detail_fixture()
      assert Recipes.get_recipe_detail!(recipe_detail.id) == recipe_detail
    end

    test "create_recipe_detail/1 with valid data creates a recipe_detail" do
      valid_attrs = %{}

      assert {:ok, %RecipeDetail{} = recipe_detail} = Recipes.create_recipe_detail(valid_attrs)
    end

    test "create_recipe_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Recipes.create_recipe_detail(@invalid_attrs)
    end

    test "update_recipe_detail/2 with valid data updates the recipe_detail" do
      recipe_detail = recipe_detail_fixture()
      update_attrs = %{}

      assert {:ok, %RecipeDetail{} = recipe_detail} = Recipes.update_recipe_detail(recipe_detail, update_attrs)
    end

    test "update_recipe_detail/2 with invalid data returns error changeset" do
      recipe_detail = recipe_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = Recipes.update_recipe_detail(recipe_detail, @invalid_attrs)
      assert recipe_detail == Recipes.get_recipe_detail!(recipe_detail.id)
    end

    test "delete_recipe_detail/1 deletes the recipe_detail" do
      recipe_detail = recipe_detail_fixture()
      assert {:ok, %RecipeDetail{}} = Recipes.delete_recipe_detail(recipe_detail)
      assert_raise Ecto.NoResultsError, fn -> Recipes.get_recipe_detail!(recipe_detail.id) end
    end

    test "change_recipe_detail/1 returns a recipe_detail changeset" do
      recipe_detail = recipe_detail_fixture()
      assert %Ecto.Changeset{} = Recipes.change_recipe_detail(recipe_detail)
    end
  end
end
