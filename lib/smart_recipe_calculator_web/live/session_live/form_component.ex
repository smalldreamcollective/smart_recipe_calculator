defmodule SmartRecipeCalculatorWeb.SessionLive.FormComponent do
  use SmartRecipeCalculatorWeb, :live_component

  alias SmartRecipeCalculator.Auth

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage session records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="session-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Session</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{session: session} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Auth.change_session(session))
     end)}
  end

  @impl true
  def handle_event("validate", %{"session" => session_params}, socket) do
    changeset = Auth.change_session(socket.assigns.session, session_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"session" => session_params}, socket) do
    save_session(socket, socket.assigns.action, session_params)
  end

  defp save_session(socket, :edit, session_params) do
    case Auth.update_session(socket.assigns.session, session_params) do
      {:ok, session} ->
        notify_parent({:saved, session})

        {:noreply,
         socket
         |> put_flash(:info, "Session updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_session(socket, :new, session_params) do
    case Auth.create_session(session_params) do
      {:ok, session} ->
        notify_parent({:saved, session})

        {:noreply,
         socket
         |> put_flash(:info, "Session created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
