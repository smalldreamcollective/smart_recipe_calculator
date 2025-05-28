defmodule SmartRecipeCalculatorWeb.IngredientDetailLive.Index do
  use SmartRecipeCalculatorWeb, :live_view

  alias SmartRecipeCalculator.Ingredients
  alias SmartRecipeCalculator.Ingredients.IngredientDetail

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :ingredient_details, Ingredients.list_ingredient_details())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Ingredient detail")
    |> assign(:ingredient_detail, Ingredients.get_ingredient_detail!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Ingredient detail")
    |> assign(:ingredient_detail, %IngredientDetail{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Ingredient details")
    |> assign(:ingredient_detail, nil)
  end

  @impl true
  def handle_info({SmartRecipeCalculatorWeb.IngredientDetailLive.FormComponent, {:saved, ingredient_detail}}, socket) do
    {:noreply, stream_insert(socket, :ingredient_details, ingredient_detail)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    ingredient_detail = Ingredients.get_ingredient_detail!(id)
    {:ok, _} = Ingredients.delete_ingredient_detail(ingredient_detail)

    {:noreply, stream_delete(socket, :ingredient_details, ingredient_detail)}
  end
end
