defmodule SmartRecipeCalculatorWeb.IngredientDetailLive.FormComponent do
  use SmartRecipeCalculatorWeb, :live_component

  alias SmartRecipeCalculator.Ingredients

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage ingredient_detail records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="ingredient_detail-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Ingredient detail</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{ingredient_detail: ingredient_detail} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Ingredients.change_ingredient_detail(ingredient_detail))
     end)}
  end

  @impl true
  def handle_event("validate", %{"ingredient_detail" => ingredient_detail_params}, socket) do
    changeset = Ingredients.change_ingredient_detail(socket.assigns.ingredient_detail, ingredient_detail_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"ingredient_detail" => ingredient_detail_params}, socket) do
    save_ingredient_detail(socket, socket.assigns.action, ingredient_detail_params)
  end

  defp save_ingredient_detail(socket, :edit, ingredient_detail_params) do
    case Ingredients.update_ingredient_detail(socket.assigns.ingredient_detail, ingredient_detail_params) do
      {:ok, ingredient_detail} ->
        notify_parent({:saved, ingredient_detail})

        {:noreply,
         socket
         |> put_flash(:info, "Ingredient detail updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_ingredient_detail(socket, :new, ingredient_detail_params) do
    case Ingredients.create_ingredient_detail(ingredient_detail_params) do
      {:ok, ingredient_detail} ->
        notify_parent({:saved, ingredient_detail})

        {:noreply,
         socket
         |> put_flash(:info, "Ingredient detail created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
