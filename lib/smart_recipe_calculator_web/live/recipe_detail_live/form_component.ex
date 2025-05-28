defmodule SmartRecipeCalculatorWeb.RecipeDetailLive.FormComponent do
  use SmartRecipeCalculatorWeb, :live_component

  alias SmartRecipeCalculator.Recipes

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage recipe_detail records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="recipe_detail-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <:actions>
          <.button phx-disable-with="Saving...">Save Recipe detail</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{recipe_detail: recipe_detail} = assigns, socket) do
    changeset = Recipes.change_recipe_detail(recipe_detail)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"recipe_detail" => recipe_detail_params}, socket) do
    changeset =
      socket.assigns.recipe_detail
      |> Recipes.change_recipe_detail(recipe_detail_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"recipe_detail" => recipe_detail_params}, socket) do
    save_recipe_detail(socket, socket.assigns.action, recipe_detail_params)
  end

  defp save_recipe_detail(socket, :edit, recipe_detail_params) do
    case Recipes.update_recipe_detail(socket.assigns.recipe_detail, recipe_detail_params) do
      {:ok, recipe_detail} ->
        notify_parent({:saved, recipe_detail})

        {:noreply,
         socket
         |> put_flash(:info, "Recipe detail updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_recipe_detail(socket, :new, recipe_detail_params) do
    case Recipes.create_recipe_detail(recipe_detail_params) do
      {:ok, recipe_detail} ->
        notify_parent({:saved, recipe_detail})

        {:noreply,
         socket
         |> put_flash(:info, "Recipe detail created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
