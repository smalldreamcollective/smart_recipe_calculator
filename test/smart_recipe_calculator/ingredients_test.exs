defmodule SmartRecipeCalculator.IngredientsTest do
  use SmartRecipeCalculator.DataCase

  alias SmartRecipeCalculator.Ingredients

  describe "ingredients" do
    alias SmartRecipeCalculator.Ingredients.Ingredient

    import SmartRecipeCalculator.IngredientsFixtures

    @invalid_attrs %{name: nil, unit: nil, calories: nil, protein: nil, fat: nil, carbs: nil}

    test "list_ingredients/0 returns all ingredients" do
      ingredient = ingredient_fixture()
      assert Ingredients.list_ingredients() == [ingredient]
    end

    test "get_ingredient!/1 returns the ingredient with given id" do
      ingredient = ingredient_fixture()
      assert Ingredients.get_ingredient!(ingredient.id) == ingredient
    end

    test "create_ingredient/1 with valid data creates a ingredient" do
      valid_attrs = %{name: "some name", unit: "some unit", calories: 42, protein: "120.5", fat: "120.5", carbs: "120.5"}

      assert {:ok, %Ingredient{} = ingredient} = Ingredients.create_ingredient(valid_attrs)
      assert ingredient.name == "some name"
      assert ingredient.unit == "some unit"
      assert ingredient.calories == 42
      assert ingredient.protein == Decimal.new("120.5")
      assert ingredient.fat == Decimal.new("120.5")
      assert ingredient.carbs == Decimal.new("120.5")
    end

    test "create_ingredient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ingredients.create_ingredient(@invalid_attrs)
    end

    test "update_ingredient/2 with valid data updates the ingredient" do
      ingredient = ingredient_fixture()
      update_attrs = %{name: "some updated name", unit: "some updated unit", calories: 43, protein: "456.7", fat: "456.7", carbs: "456.7"}

      assert {:ok, %Ingredient{} = ingredient} = Ingredients.update_ingredient(ingredient, update_attrs)
      assert ingredient.name == "some updated name"
      assert ingredient.unit == "some updated unit"
      assert ingredient.calories == 43
      assert ingredient.protein == Decimal.new("456.7")
      assert ingredient.fat == Decimal.new("456.7")
      assert ingredient.carbs == Decimal.new("456.7")
    end

    test "update_ingredient/2 with invalid data returns error changeset" do
      ingredient = ingredient_fixture()
      assert {:error, %Ecto.Changeset{}} = Ingredients.update_ingredient(ingredient, @invalid_attrs)
      assert ingredient == Ingredients.get_ingredient!(ingredient.id)
    end

    test "delete_ingredient/1 deletes the ingredient" do
      ingredient = ingredient_fixture()
      assert {:ok, %Ingredient{}} = Ingredients.delete_ingredient(ingredient)
      assert_raise Ecto.NoResultsError, fn -> Ingredients.get_ingredient!(ingredient.id) end
    end

    test "change_ingredient/1 returns a ingredient changeset" do
      ingredient = ingredient_fixture()
      assert %Ecto.Changeset{} = Ingredients.change_ingredient(ingredient)
    end
  end

  describe "ingredient_details" do
    alias SmartRecipeCalculator.Ingredients.IngredientDetail

    import SmartRecipeCalculator.IngredientsFixtures

    @invalid_attrs %{}

    test "list_ingredient_details/0 returns all ingredient_details" do
      ingredient_detail = ingredient_detail_fixture()
      assert Ingredients.list_ingredient_details() == [ingredient_detail]
    end

    test "get_ingredient_detail!/1 returns the ingredient_detail with given id" do
      ingredient_detail = ingredient_detail_fixture()
      assert Ingredients.get_ingredient_detail!(ingredient_detail.id) == ingredient_detail
    end

    test "create_ingredient_detail/1 with valid data creates a ingredient_detail" do
      valid_attrs = %{}

      assert {:ok, %IngredientDetail{} = ingredient_detail} = Ingredients.create_ingredient_detail(valid_attrs)
    end

    test "create_ingredient_detail/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Ingredients.create_ingredient_detail(@invalid_attrs)
    end

    test "update_ingredient_detail/2 with valid data updates the ingredient_detail" do
      ingredient_detail = ingredient_detail_fixture()
      update_attrs = %{}

      assert {:ok, %IngredientDetail{} = ingredient_detail} = Ingredients.update_ingredient_detail(ingredient_detail, update_attrs)
    end

    test "update_ingredient_detail/2 with invalid data returns error changeset" do
      ingredient_detail = ingredient_detail_fixture()
      assert {:error, %Ecto.Changeset{}} = Ingredients.update_ingredient_detail(ingredient_detail, @invalid_attrs)
      assert ingredient_detail == Ingredients.get_ingredient_detail!(ingredient_detail.id)
    end

    test "delete_ingredient_detail/1 deletes the ingredient_detail" do
      ingredient_detail = ingredient_detail_fixture()
      assert {:ok, %IngredientDetail{}} = Ingredients.delete_ingredient_detail(ingredient_detail)
      assert_raise Ecto.NoResultsError, fn -> Ingredients.get_ingredient_detail!(ingredient_detail.id) end
    end

    test "change_ingredient_detail/1 returns a ingredient_detail changeset" do
      ingredient_detail = ingredient_detail_fixture()
      assert %Ecto.Changeset{} = Ingredients.change_ingredient_detail(ingredient_detail)
    end
  end
end
