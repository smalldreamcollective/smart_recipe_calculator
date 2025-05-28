defmodule SmartRecipeCalculator.Ingredients do
  @moduledoc """
  The Ingredients context.
  """

  import Ecto.Query, warn: false
  alias SmartRecipeCalculator.Repo

  alias SmartRecipeCalculator.Ingredients.Ingredient

  @doc """
  Returns the list of ingredients.

  ## Examples

      iex> list_ingredients()
      [%Ingredient{}, ...]

  """
  def list_ingredients do
    Repo.all(Ingredient)
  end

  @doc """
  Gets a single ingredient.

  Raises `Ecto.NoResultsError` if the Ingredient does not exist.

  ## Examples

      iex> get_ingredient!(123)
      %Ingredient{}

      iex> get_ingredient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ingredient!(id), do: Repo.get!(Ingredient, id)

  @doc """
  Creates a ingredient.

  ## Examples

      iex> create_ingredient(%{field: value})
      {:ok, %Ingredient{}}

      iex> create_ingredient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ingredient(attrs \\ %{}) do
    %Ingredient{}
    |> Ingredient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ingredient.

  ## Examples

      iex> update_ingredient(ingredient, %{field: new_value})
      {:ok, %Ingredient{}}

      iex> update_ingredient(ingredient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ingredient(%Ingredient{} = ingredient, attrs) do
    ingredient
    |> Ingredient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ingredient.

  ## Examples

      iex> delete_ingredient(ingredient)
      {:ok, %Ingredient{}}

      iex> delete_ingredient(ingredient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ingredient(%Ingredient{} = ingredient) do
    Repo.delete(ingredient)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ingredient changes.

  ## Examples

      iex> change_ingredient(ingredient)
      %Ecto.Changeset{data: %Ingredient{}}

  """
  def change_ingredient(%Ingredient{} = ingredient, attrs \\ %{}) do
    Ingredient.changeset(ingredient, attrs)
  end

  alias SmartRecipeCalculator.Ingredients.IngredientDetail

  @doc """
  Returns the list of ingredient_details.

  ## Examples

      iex> list_ingredient_details()
      [%IngredientDetail{}, ...]

  """
  def list_ingredient_details do
    Repo.all(IngredientDetail)
  end

  @doc """
  Gets a single ingredient_detail.

  Raises `Ecto.NoResultsError` if the Ingredient detail does not exist.

  ## Examples

      iex> get_ingredient_detail!(123)
      %IngredientDetail{}

      iex> get_ingredient_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ingredient_detail!(id), do: Repo.get!(IngredientDetail, id)

  @doc """
  Creates a ingredient_detail.

  ## Examples

      iex> create_ingredient_detail(%{field: value})
      {:ok, %IngredientDetail{}}

      iex> create_ingredient_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ingredient_detail(attrs \\ %{}) do
    %IngredientDetail{}
    |> IngredientDetail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ingredient_detail.

  ## Examples

      iex> update_ingredient_detail(ingredient_detail, %{field: new_value})
      {:ok, %IngredientDetail{}}

      iex> update_ingredient_detail(ingredient_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ingredient_detail(%IngredientDetail{} = ingredient_detail, attrs) do
    ingredient_detail
    |> IngredientDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a ingredient_detail.

  ## Examples

      iex> delete_ingredient_detail(ingredient_detail)
      {:ok, %IngredientDetail{}}

      iex> delete_ingredient_detail(ingredient_detail)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ingredient_detail(%IngredientDetail{} = ingredient_detail) do
    Repo.delete(ingredient_detail)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ingredient_detail changes.

  ## Examples

      iex> change_ingredient_detail(ingredient_detail)
      %Ecto.Changeset{data: %IngredientDetail{}}

  """
  def change_ingredient_detail(%IngredientDetail{} = ingredient_detail, attrs \\ %{}) do
    IngredientDetail.changeset(ingredient_detail, attrs)
  end
end
