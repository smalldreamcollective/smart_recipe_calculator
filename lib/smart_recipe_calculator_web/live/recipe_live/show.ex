defmodule SmartRecipeCalculatorWeb.RecipeLive.Show do
  use SmartRecipeCalculatorWeb, :live_view

  alias SmartRecipeCalculator.Recipes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _uri, socket) do
    recipe = Recipes.get_recipe_with_associations!(id)
    live_action = socket.assigns.live_action

    {:noreply,
     socket
     |> assign(:page_title, page_title(live_action))
     |> assign(:live_action, live_action)
     |> assign(:recipe, recipe)
     |> stream(:ingredients, recipe.recipe_ingredients)
     |> stream(:instructions, Recipes.list_recipe_instructions(recipe.id))}
  end

  @impl true
  def handle_event("delete_ingredient", %{"id" => id}, socket) do
    ingredient = Recipes.get_recipe_ingredient!(id)

    {:ok, _} =
      Recipes.remove_ingredient_from_recipe(socket.assigns.recipe.id, ingredient.ingredient_id)

    {:noreply, stream_delete(socket, :ingredients, ingredient)}
  end

  def handle_info(
        {SmartRecipeCalculatorWeb.RecipeLive.IngredientFormComponent, {:saved, ingredient}},
        socket
      ) do
    {:noreply, stream_insert(socket, :ingredients, ingredient, at: -1)}
  end

  def handle_info(
        {SmartRecipeCalculatorWeb.RecipeLive.FormComponent, {:saved, recipe}},
        socket
      ) do
    {:noreply,
     socket
     |> assign(:recipe, recipe)
     |> stream(:instructions, Recipes.list_recipe_instructions(recipe.id), reset: true)}
  end

  defp page_title(:show), do: "Show Recipe"
  defp page_title(:edit), do: "Edit Recipe"
  defp page_title(:new_ingredient), do: "Add Ingredient"
end
