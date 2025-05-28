defmodule SmartRecipeCalculatorWeb.IngredientDetailLive.Show do
  use SmartRecipeCalculatorWeb, :live_view

  alias SmartRecipeCalculator.Ingredients

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:ingredient_detail, Ingredients.get_ingredient_detail!(id))}
  end

  defp page_title(:show), do: "Show Ingredient detail"
  defp page_title(:edit), do: "Edit Ingredient detail"
end
