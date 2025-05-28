defmodule SmartRecipeCalculatorWeb.RecipeDetailLive.Show do
  use SmartRecipeCalculatorWeb, :live_view

  alias SmartRecipeCalculator.Recipes

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:recipe_detail, Recipes.get_recipe_detail!(id))}
  end

  defp page_title(:show), do: "Show Recipe detail"
  defp page_title(:edit), do: "Edit Recipe detail"
end
