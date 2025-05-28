defmodule SmartRecipeCalculatorWeb.SessionLive.Show do
  use SmartRecipeCalculatorWeb, :live_view

  alias SmartRecipeCalculator.Auth

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:session, Auth.get_session!(id))}
  end

  defp page_title(:show), do: "Show Session"
  defp page_title(:edit), do: "Edit Session"
end
