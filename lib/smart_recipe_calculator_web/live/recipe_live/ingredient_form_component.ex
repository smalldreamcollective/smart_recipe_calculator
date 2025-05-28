defmodule SmartRecipeCalculatorWeb.RecipeLive.IngredientFormComponent do
  use SmartRecipeCalculatorWeb, :live_component

  alias SmartRecipeCalculator.Recipes
  alias SmartRecipeCalculator.Ingredients

  @impl true
  def update(%{recipe: _recipe} = assigns, socket) do
    changeset = Recipes.RecipeIngredient.changeset(%Recipes.RecipeIngredient{}, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))
     |> assign(:ingredients, list_ingredients())}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        Add Ingredient
        <:subtitle>Add an ingredient to this recipe.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="recipe_ingredient-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:ingredient_id]}
          type="select"
          label="Ingredient"
          options={Enum.map(@ingredients, &{&1.name, &1.id})}
        />
        <.input field={@form[:quantity]} type="number" label="Quantity" step="0.01" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Ingredient</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"recipe_ingredient" => recipe_ingredient_params}, socket) do
    changeset =
      %Recipes.RecipeIngredient{}
      |> Recipes.RecipeIngredient.changeset(recipe_ingredient_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"recipe_ingredient" => recipe_ingredient_params}, socket) do
    save_recipe_ingredient(socket, socket.assigns.action, recipe_ingredient_params)
  end

  defp save_recipe_ingredient(socket, :new_ingredient, recipe_ingredient_params) do
    case Recipes.add_ingredient_to_recipe(
           socket.assigns.recipe.id,
           recipe_ingredient_params["ingredient_id"],
           recipe_ingredient_params["quantity"]
         ) do
      {:ok, recipe_ingredient} ->
        notify_parent({:saved, recipe_ingredient})

        {:noreply,
         socket
         |> put_flash(:info, "Ingredient added successfully")
         |> push_patch(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp list_ingredients do
    Ingredients.list_ingredients()
  end
end
