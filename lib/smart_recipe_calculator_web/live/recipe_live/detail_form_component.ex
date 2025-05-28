defmodule SmartRecipeCalculatorWeb.RecipeLive.DetailFormComponent do
  use SmartRecipeCalculatorWeb, :live_component

  alias SmartRecipeCalculator.Recipes

  @impl true
  def update(%{recipe: recipe} = assigns, socket) do
    changeset = Recipes.RecipeDetail.changeset(%Recipes.RecipeDetail{}, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"recipe_detail" => recipe_detail_params}, socket) do
    changeset =
      socket.assigns.recipe
      |> Recipes.RecipeDetail.changeset(recipe_detail_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"recipe_detail" => recipe_detail_params}, socket) do
    save_recipe_detail(socket, socket.assigns.action, recipe_detail_params)
  end

  defp save_recipe_detail(socket, :new_detail, recipe_detail_params) do
    case Recipes.add_recipe_detail(socket.assigns.recipe.id) do
      {:ok, _recipe_detail} ->
        {:noreply,
         socket
         |> put_flash(:info, "Detail added successfully")
         |> push_patch(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
