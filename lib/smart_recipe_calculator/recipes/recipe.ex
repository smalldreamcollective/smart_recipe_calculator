defmodule SmartRecipeCalculator.Recipes.Recipe do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipes" do
    field :name, :string
    field :description, :string
    field :prep_time, :integer
    field :cook_time, :integer
    field :servings, :integer
    field :difficulty, :string
    field :user_id, :id

    has_many :recipe_ingredients, SmartRecipeCalculator.Recipes.RecipeIngredient
    has_many :ingredients, through: [:recipe_ingredients, :ingredient]

    has_many :recipe_instructions, SmartRecipeCalculator.Recipes.RecipeInstruction,
      on_delete: :delete_all

    many_to_many :instructions, SmartRecipeCalculator.Instructions.Instruction,
      join_through: SmartRecipeCalculator.Recipes.RecipeInstruction,
      join_keys: [recipe_id: :id, instruction_id: :id],
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipe, attrs) do
    recipe
    |> cast(attrs, [
      :name,
      :description,
      :prep_time,
      :cook_time,
      :servings,
      :difficulty,
      :user_id
    ])
    |> validate_required([:name, :description, :user_id])
  end
end
