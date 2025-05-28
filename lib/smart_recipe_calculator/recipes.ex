defmodule SmartRecipeCalculator.Recipes do
  @moduledoc """
  The Recipes context.
  """

  import Ecto.Query, warn: false
  alias SmartRecipeCalculator.Repo

  alias SmartRecipeCalculator.Recipes.Recipe
  alias SmartRecipeCalculator.Recipes.RecipeDetail
  alias SmartRecipeCalculator.Recipes.RecipeIngredient
  alias SmartRecipeCalculator.Recipes.RecipeInstruction
  alias SmartRecipeCalculator.Instructions.Instruction

  @doc """
  Returns the list of recipes.

  ## Examples

      iex> list_recipes()
      [%Recipe{}, ...]

  """
  def list_recipes do
    Repo.all(Recipe)
  end

  @doc """
  Returns the list of recipe_details.

  ## Examples

      iex> list_recipe_details()
      [%RecipeDetail{}, ...]

  """
  def list_recipe_details do
    Repo.all(RecipeDetail)
  end

  @doc """
  Gets a single recipe.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.

  ## Examples

      iex> get_recipe!(123)
      %Recipe{}

      iex> get_recipe!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe!(id), do: Repo.get!(Recipe, id)

  @doc """
  Gets a single recipe with preloaded associations.

  Raises `Ecto.NoResultsError` if the Recipe does not exist.
  """
  def get_recipe_with_associations!(id) do
    Repo.get!(Recipe, id)
    |> Repo.preload([:recipe_ingredients, :ingredients])
  end

  @doc """
  Gets a single recipe ingredient.

  Raises `Ecto.NoResultsError` if the Recipe ingredient does not exist.
  """
  def get_recipe_ingredient!(id), do: Repo.get!(RecipeIngredient, id)

  @doc """
  Creates a recipe.

  ## Examples

      iex> create_recipe(%{field: value})
      {:ok, %Recipe{}}

      iex> create_recipe(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe(attrs \\ %{}) do
    %Recipe{}
    |> Recipe.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe.

  ## Examples

      iex> update_recipe(recipe, %{field: new_value})
      {:ok, %Recipe{}}

      iex> update_recipe(recipe, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe(%Recipe{} = recipe, attrs) do
    recipe
    |> Recipe.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipe.

  ## Examples

      iex> delete_recipe(recipe)
      {:ok, %Recipe{}}

      iex> delete_recipe(recipe)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipe(%Recipe{} = recipe) do
    Repo.delete(recipe)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe changes.

  ## Examples

      iex> change_recipe(recipe)
      %Ecto.Changeset{data: %Recipe{}}

  """
  def change_recipe(%Recipe{} = recipe, attrs \\ %{}) do
    Recipe.changeset(recipe, attrs)
  end

  # Recipe Ingredients

  @doc """
  Adds an ingredient to a recipe.
  """
  def add_ingredient_to_recipe(recipe_id, ingredient_id, quantity) do
    %RecipeIngredient{}
    |> RecipeIngredient.changeset(%{
      recipe_id: recipe_id,
      ingredient_id: ingredient_id,
      quantity: quantity
    })
    |> Repo.insert()
  end

  @doc """
  Removes an ingredient from a recipe.
  """
  def remove_ingredient_from_recipe(recipe_id, ingredient_id) do
    from(ri in RecipeIngredient,
      where: ri.recipe_id == ^recipe_id and ri.ingredient_id == ^ingredient_id
    )
    |> Repo.delete_all()
  end

  @doc """
  Gets all ingredients for a recipe.
  """
  def get_recipe_ingredients(recipe_id) do
    from(ri in RecipeIngredient,
      where: ri.recipe_id == ^recipe_id,
      preload: [:ingredient]
    )
    |> Repo.all()
  end

  # Recipe Details

  @doc """
  Adds a detail to a recipe.
  """
  def add_recipe_detail(recipe_id) do
    %RecipeDetail{}
    |> RecipeDetail.changeset(%{recipe_id: recipe_id})
    |> Repo.insert()
  end

  @doc """
  Gets all details for a recipe.
  """
  def get_recipe_details(recipe_id) do
    from(rd in RecipeDetail,
      where: rd.recipe_id == ^recipe_id
    )
    |> Repo.all()
  end

  @doc """
  Deletes a recipe detail.
  """
  def delete_recipe_detail(%RecipeDetail{} = recipe_detail) do
    Repo.delete(recipe_detail)
  end

  @doc """
  Gets a single recipe_detail.

  Raises `Ecto.NoResultsError` if the Recipe detail does not exist.

  ## Examples

      iex> get_recipe_detail!(123)
      %RecipeDetail{}

      iex> get_recipe_detail!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipe_detail!(id), do: Repo.get!(RecipeDetail, id)

  @doc """
  Creates a recipe_detail.

  ## Examples

      iex> create_recipe_detail(%{field: value})
      {:ok, %RecipeDetail{}}

      iex> create_recipe_detail(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipe_detail(attrs \\ %{}) do
    %RecipeDetail{}
    |> RecipeDetail.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipe_detail.

  ## Examples

      iex> update_recipe_detail(recipe_detail, %{field: new_value})
      {:ok, %RecipeDetail{}}

      iex> update_recipe_detail(recipe_detail, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipe_detail(%RecipeDetail{} = recipe_detail, attrs) do
    recipe_detail
    |> RecipeDetail.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipe_detail changes.

  ## Examples

      iex> change_recipe_detail(recipe_detail)
      %Ecto.Changeset{data: %RecipeDetail{}}

  """
  def change_recipe_detail(%RecipeDetail{} = recipe_detail, attrs \\ %{}) do
    RecipeDetail.changeset(recipe_detail, attrs)
  end

  # Recipe Instructions

  @doc """
  Lists all instructions for a recipe.
  """
  def list_recipe_instructions(nil), do: []

  def list_recipe_instructions(recipe_id) do
    RecipeInstruction
    |> where([ri], ri.recipe_id == ^recipe_id)
    |> order_by([ri], asc: ri.step_number)
    |> preload(:instruction)
    |> Repo.all()
  end

  @doc """
  Adds an instruction to a recipe.
  """
  def add_instruction_to_recipe(recipe_id, instruction_id, step_number) do
    %RecipeInstruction{}
    |> RecipeInstruction.changeset(%{
      recipe_id: recipe_id,
      instruction_id: instruction_id,
      step_number: step_number
    })
    |> Repo.insert()
  end

  @doc """
  Removes an instruction from a recipe.
  """
  def remove_instruction_from_recipe(recipe_id, instruction_id) do
    from(ri in RecipeInstruction,
      where: ri.recipe_id == ^recipe_id and ri.instruction_id == ^instruction_id
    )
    |> Repo.delete_all()
  end

  @doc """
  Updates the step number of an instruction in a recipe.
  """
  def update_recipe_instruction_step(recipe_id, instruction_id, new_step_number) do
    from(ri in RecipeInstruction,
      where: ri.recipe_id == ^recipe_id and ri.instruction_id == ^instruction_id
    )
    |> Repo.one()
    |> case do
      nil ->
        {:error, :not_found}

      ri ->
        RecipeInstruction.changeset(ri, %{step_number: new_step_number})
        |> Repo.update()
    end
  end
end
