defmodule SmartRecipeCalculatorWeb.IngredientLive.Index do
  use SmartRecipeCalculatorWeb, :live_view

  alias SmartRecipeCalculator.Ingredients
  alias SmartRecipeCalculator.Ingredients.Ingredient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :ingredients, Ingredients.list_ingredients())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Ingredient")
    |> assign(:ingredient, Ingredients.get_ingredient!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Ingredient")
    |> assign(:ingredient, %Ingredient{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Ingredients")
    |> assign(:ingredient, nil)
  end

  @impl true
  def handle_info({SmartRecipeCalculatorWeb.IngredientLive.FormComponent, {:saved, ingredient}}, socket) do
    {:noreply, stream_insert(socket, :ingredients, ingredient)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    ingredient = Ingredients.get_ingredient!(id)
    {:ok, _} = Ingredients.delete_ingredient(ingredient)

    {:noreply, stream_delete(socket, :ingredients, ingredient)}
  end
end
