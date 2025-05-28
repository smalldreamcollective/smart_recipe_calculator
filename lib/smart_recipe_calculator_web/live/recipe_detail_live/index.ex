defmodule SmartRecipeCalculatorWeb.RecipeDetailLive.Index do
  use SmartRecipeCalculatorWeb, :live_view

  alias SmartRecipeCalculator.Recipes
  alias SmartRecipeCalculator.Recipes.RecipeDetail

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :recipe_details, Recipes.list_recipe_details())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Recipe detail")
    |> assign(:recipe_detail, Recipes.get_recipe_detail!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Recipe detail")
    |> assign(:recipe_detail, %RecipeDetail{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Recipe details")
    |> assign(:recipe_detail, nil)
  end

  @impl true
  def handle_info({SmartRecipeCalculatorWeb.RecipeDetailLive.FormComponent, {:saved, recipe_detail}}, socket) do
    {:noreply, stream_insert(socket, :recipe_details, recipe_detail)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    recipe_detail = Recipes.get_recipe_detail!(id)
    {:ok, _} = Recipes.delete_recipe_detail(recipe_detail)

    {:noreply, stream_delete(socket, :recipe_details, recipe_detail)}
  end
end
