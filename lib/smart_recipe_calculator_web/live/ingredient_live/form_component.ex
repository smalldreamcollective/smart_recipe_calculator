defmodule SmartRecipeCalculatorWeb.IngredientLive.FormComponent do
  use SmartRecipeCalculatorWeb, :live_component

  alias SmartRecipeCalculator.Ingredients

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage ingredient records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="ingredient-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:unit]} type="text" label="Unit" />
        <.input field={@form[:calories]} type="number" label="Calories" />
        <.input field={@form[:protein]} type="number" label="Protein" step="any" />
        <.input field={@form[:fat]} type="number" label="Fat" step="any" />
        <.input field={@form[:carbs]} type="number" label="Carbs" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Ingredient</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{ingredient: ingredient} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Ingredients.change_ingredient(ingredient))
     end)}
  end

  @impl true
  def handle_event("validate", %{"ingredient" => ingredient_params}, socket) do
    changeset = Ingredients.change_ingredient(socket.assigns.ingredient, ingredient_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"ingredient" => ingredient_params}, socket) do
    save_ingredient(socket, socket.assigns.action, ingredient_params)
  end

  defp save_ingredient(socket, :edit, ingredient_params) do
    case Ingredients.update_ingredient(socket.assigns.ingredient, ingredient_params) do
      {:ok, ingredient} ->
        notify_parent({:saved, ingredient})

        {:noreply,
         socket
         |> put_flash(:info, "Ingredient updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_ingredient(socket, :new, ingredient_params) do
    case Ingredients.create_ingredient(ingredient_params) do
      {:ok, ingredient} ->
        notify_parent({:saved, ingredient})

        {:noreply,
         socket
         |> put_flash(:info, "Ingredient created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
