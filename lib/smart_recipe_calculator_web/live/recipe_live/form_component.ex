defmodule SmartRecipeCalculatorWeb.RecipeLive.FormComponent do
  use SmartRecipeCalculatorWeb, :live_component

  alias SmartRecipeCalculator.Recipes
  alias SmartRecipeCalculator.Auth
  alias SmartRecipeCalculator.Ingredients
  import Ecto.Query, only: [from: 2]

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage recipe records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="recipe-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:prep_time]} type="number" label="Prep Time (minutes)" />
        <.input field={@form[:cook_time]} type="number" label="Cook Time (minutes)" />
        <.input field={@form[:servings]} type="number" label="Servings" />
        <.input
          field={@form[:difficulty]}
          type="select"
          label="Difficulty"
          options={["Easy", "Medium", "Hard"]}
        />
        <.input field={@form[:user_id]} type="select" label="User" options={@users} />

        <div class="mt-8">
          <h3 class="text-md font-semibold mb-2">Ingredients</h3>
          <%= for {entry, idx} <- Enum.with_index(@ingredient_entries) do %>
            <div class="flex items-center gap-2 mb-2" id={"ingredient-row-#{idx}"}>
              <select
                name="ingredient_entries[#{idx}][ingredient_id]"
                class="border rounded px-2 py-1"
              >
                <option value="">Select Ingredient</option>
                <%= for ingredient <- @all_ingredients do %>
                  <option
                    value={ingredient.id}
                    selected={to_string(ingredient.id) == to_string(entry.ingredient_id)}
                  >
                    {ingredient.name}
                  </option>
                <% end %>
              </select>
              <input
                name="ingredient_entries[#{idx}][quantity]"
                type="number"
                step="0.01"
                placeholder="Quantity"
                value={entry.quantity}
                class="border rounded px-2 py-1 w-24"
              />
              <input
                name="ingredient_entries[#{idx}][unit]"
                type="text"
                placeholder="Unit"
                value={entry.unit}
                class="border rounded px-2 py-1 w-20"
              />
              <button
                type="button"
                phx-click="remove_ingredient"
                phx-value-idx={idx}
                phx-target={@myself}
                class="ml-2 text-red-600"
              >
                Remove
              </button>
            </div>
          <% end %>
          <button
            type="button"
            phx-click="add_ingredient"
            phx-target={@myself}
            class="mt-2 px-3 py-1 bg-blue-500 text-white rounded"
          >
            Add Ingredient
          </button>
        </div>

        <div class="mt-8">
          <h3 class="text-md font-semibold mb-2">Instructions (Steps)</h3>
          <%= for {entry, idx} <- Enum.with_index(@instruction_entries) do %>
            <div class="flex items-center gap-2 mb-2" id={"instruction-row-#{idx}"}>
              <input
                name="instruction_entries[#{idx}][text]"
                type="text"
                placeholder="Step description"
                value={entry.text}
                class="border rounded px-2 py-1 flex-1"
              />
              <input
                name="instruction_entries[#{idx}][step_number]"
                type="number"
                min="1"
                value={entry.step_number}
                class="border rounded px-2 py-1 w-16"
              />
              <button
                type="button"
                phx-click="remove_instruction"
                phx-value-idx={idx}
                phx-target={@myself}
                class="ml-2 text-red-600"
              >
                Remove
              </button>
            </div>
          <% end %>
          <button
            type="button"
            phx-click="add_instruction"
            phx-target={@myself}
            class="mt-2 px-3 py-1 bg-blue-500 text-white rounded"
          >
            Add Step
          </button>
        </div>

        <div class="mt-8">
          <button
            form="recipe-form"
            type="submit"
            class="px-4 py-2 bg-black text-white rounded"
            phx-disable-with="Saving..."
          >
            Save Recipe
          </button>
        </div>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{recipe: recipe} = assigns, socket) do
    recipe =
      cond do
        Map.get(recipe, :id) == nil ->
          # New recipe, ensure associations are empty lists
          %{recipe | recipe_ingredients: []}

        Ecto.assoc_loaded?(recipe.recipe_ingredients) ->
          recipe

        true ->
          SmartRecipeCalculator.Repo.preload(recipe, recipe_ingredients: [:ingredient])
      end

    changeset = Recipes.change_recipe(recipe)
    users = list_users()
    all_ingredients = Ingredients.list_ingredients()

    ingredient_entries =
      case recipe.recipe_ingredients do
        nil ->
          []

        entries ->
          Enum.map(entries, fn ri ->
            %{ingredient_id: ri.ingredient_id, quantity: ri.quantity, unit: ri.ingredient.unit}
          end)
      end

    instruction_entries =
      case recipe do
        %{id: nil} ->
          []

        _ ->
          case Recipes.list_recipe_instructions(recipe.id) do
            [] ->
              []

            steps ->
              Enum.map(steps, fn ri ->
                %{
                  text: ri.instruction.text,
                  step_number: ri.step_number,
                  instruction_id: ri.instruction_id
                }
              end)
          end
      end

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)
     |> assign(:users, users)
     |> assign(:all_ingredients, all_ingredients)
     |> assign(:ingredient_entries, ingredient_entries)
     |> assign(:instruction_entries, instruction_entries)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("add_ingredient", _params, socket) do
    entries =
      socket.assigns.ingredient_entries ++ [%{ingredient_id: nil, quantity: nil, unit: ""}]

    {:noreply, assign(socket, :ingredient_entries, entries)}
  end

  def handle_event("add_instruction", _params, socket) do
    entries =
      (socket.assigns[:instruction_entries] || []) ++
        [%{text: "", step_number: length(socket.assigns[:instruction_entries] || []) + 1}]

    {:noreply, assign(socket, :instruction_entries, entries)}
  end

  def handle_event("remove_ingredient", %{"idx" => idx}, socket) do
    idx = String.to_integer(idx)
    entries = List.delete_at(socket.assigns.ingredient_entries, idx)
    {:noreply, assign(socket, :ingredient_entries, entries)}
  end

  def handle_event("remove_instruction", %{"idx" => idx}, socket) do
    idx = String.to_integer(idx)
    entries = socket.assigns[:instruction_entries] || []
    entries = List.delete_at(entries, idx)
    {:noreply, assign(socket, :instruction_entries, entries)}
  end

  @impl true
  def handle_event(
        "validate",
        %{
          "recipe" => recipe_params,
          "ingredient_entries" => ingredient_entries_params,
          "instruction_entries" => instruction_entries_params
        },
        socket
      ) do
    changeset =
      socket.assigns.recipe
      |> Recipes.change_recipe(recipe_params)
      |> Map.put(:action, :validate)

    entries = parse_ingredient_entries(ingredient_entries_params)
    instruction_entries = parse_instruction_entries(instruction_entries_params)

    {:noreply,
     socket
     |> assign(:form, to_form(changeset))
     |> assign(:ingredient_entries, entries)
     |> assign(:instruction_entries, instruction_entries)}
  end

  def handle_event("validate", %{"recipe" => recipe_params}, socket) do
    changeset =
      socket.assigns.recipe
      |> Recipes.change_recipe(recipe_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event(
        "save",
        %{
          "recipe" => recipe_params,
          "ingredient_entries" => ingredient_entries_params,
          "instruction_entries" => instruction_entries_params
        },
        socket
      ) do
    entries = parse_ingredient_entries(ingredient_entries_params)
    instruction_entries = parse_instruction_entries(instruction_entries_params)
    save_recipe(socket, socket.assigns.action, recipe_params, entries, instruction_entries)
  end

  def handle_event("save", %{"recipe" => recipe_params}, socket) do
    save_recipe(
      socket,
      socket.assigns.action,
      recipe_params,
      socket.assigns.ingredient_entries,
      socket.assigns.instruction_entries
    )
  end

  @impl true
  def handle_event(
        "save_step",
        %{"idx" => idx, "text" => text, "step_number" => step_number} = params,
        socket
      ) do
    require Logger
    Logger.info("[save_step] Params: #{inspect(params)}")
    idx = String.to_integer(idx)
    entries = socket.assigns[:instruction_entries] || []
    entry = Enum.at(entries, idx)
    recipe = socket.assigns.recipe

    cond do
      text && String.trim(text) != "" && recipe && recipe.id ->
        result =
          if entry[:instruction_id] do
            SmartRecipeCalculator.Instructions.update_instruction(
              SmartRecipeCalculator.Instructions.get_instruction!(entry[:instruction_id]),
              %{text: text}
            )
          else
            SmartRecipeCalculator.Instructions.create_instruction(%{text: text})
          end

        Logger.info("[save_step] Instruction result: #{inspect(result)}")

        case result do
          {:ok, instruction} ->
            assoc_result =
              SmartRecipeCalculator.Recipes.add_instruction_to_recipe(
                recipe.id,
                instruction.id,
                step_number
              )

            Logger.info("[save_step] Association result: #{inspect(assoc_result)}")

            new_entry =
              entry
              |> Map.put(:instruction_id, instruction.id)
              |> Map.put(:text, text)
              |> Map.put(:step_number, step_number)

            new_entries = List.replace_at(entries, idx, new_entry)

            {:noreply,
             socket
             |> assign(:instruction_entries, new_entries)
             |> put_flash(:info, "Step saved and associated!")}

          error ->
            Logger.error("[save_step] Instruction error: #{inspect(error)}")
            {:noreply, put_flash(socket, :error, "Failed to save instruction: #{inspect(error)}")}
        end

      text && String.trim(text) != "" ->
        result =
          if entry[:instruction_id] do
            SmartRecipeCalculator.Instructions.update_instruction(
              SmartRecipeCalculator.Instructions.get_instruction!(entry[:instruction_id]),
              %{text: text}
            )
          else
            SmartRecipeCalculator.Instructions.create_instruction(%{text: text})
          end

        Logger.info("[save_step] Instruction result (new): #{inspect(result)}")

        case result do
          {:ok, instruction} ->
            new_entry =
              entry
              |> Map.put(:instruction_id, instruction.id)
              |> Map.put(:text, text)
              |> Map.put(:step_number, step_number)

            new_entries = List.replace_at(entries, idx, new_entry)

            {:noreply,
             socket
             |> assign(:instruction_entries, new_entries)
             |> put_flash(:info, "Step saved! (will associate after recipe is created)")}

          error ->
            Logger.error("[save_step] Instruction error (new): #{inspect(error)}")
            {:noreply, put_flash(socket, :error, "Failed to save instruction: #{inspect(error)}")}
        end

      true ->
        {:noreply, put_flash(socket, :error, "Step text cannot be blank.")}
    end
  end

  defp save_recipe(socket, :edit, recipe_params, ingredient_entries, instruction_entries) do
    IO.inspect(instruction_entries, label: "[save_recipe] instruction_entries before DB ops")

    case Recipes.update_recipe(socket.assigns.recipe, recipe_params) do
      {:ok, recipe} ->
        # Remove all, then re-add
        Recipes.remove_ingredient_from_recipe(recipe.id, nil)

        Enum.each(ingredient_entries, fn entry ->
          if entry.ingredient_id && entry.quantity do
            Recipes.add_ingredient_to_recipe(recipe.id, entry.ingredient_id, entry.quantity)
          end
        end)

        # Remove all recipe_instructions for this recipe before re-adding
        SmartRecipeCalculator.Repo.delete_all(
          from ri in SmartRecipeCalculator.Recipes.RecipeInstruction,
            where: ri.recipe_id == ^recipe.id
        )

        Enum.each(instruction_entries, fn entry ->
          IO.inspect(entry, label: "Processing instruction entry (edit)")

          cond do
            entry[:instruction_id] ->
              IO.inspect({:reuse, entry[:instruction_id], entry[:step_number]},
                label: "Reusing instruction (edit)"
              )

              Recipes.add_instruction_to_recipe(
                recipe.id,
                entry.instruction_id,
                entry.step_number
              )

            entry[:text] && String.trim(entry[:text]) != "" ->
              {:ok, instruction} =
                SmartRecipeCalculator.Instructions.create_instruction(%{text: entry.text})

              IO.inspect({:new, instruction.id, entry[:step_number]},
                label: "Creating new instruction (edit)"
              )

              Recipes.add_instruction_to_recipe(recipe.id, instruction.id, entry.step_number)

            true ->
              :noop
          end
        end)

        notify_parent({:saved, recipe})

        {:noreply,
         socket
         |> put_flash(:info, "Recipe updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_recipe(socket, :new, recipe_params, ingredient_entries, instruction_entries) do
    IO.inspect(instruction_entries, label: "Instruction entries to save (new)")

    case Recipes.create_recipe(recipe_params) do
      {:ok, recipe} ->
        Enum.each(ingredient_entries, fn entry ->
          if entry.ingredient_id && entry.quantity do
            Recipes.add_ingredient_to_recipe(recipe.id, entry.ingredient_id, entry.quantity)
          end
        end)

        Enum.each(instruction_entries, fn entry ->
          IO.inspect(entry, label: "Processing instruction entry (new)")

          cond do
            entry[:instruction_id] ->
              IO.inspect({:reuse, entry[:instruction_id], entry[:step_number]},
                label: "Reusing instruction (new)"
              )

              Recipes.add_instruction_to_recipe(
                recipe.id,
                entry.instruction_id,
                entry.step_number
              )

            entry[:text] && String.trim(entry[:text]) != "" ->
              {:ok, instruction} =
                SmartRecipeCalculator.Instructions.create_instruction(%{text: entry.text})

              IO.inspect({:new, instruction.id, entry[:step_number]},
                label: "Creating new instruction (new)"
              )

              Recipes.add_instruction_to_recipe(recipe.id, instruction.id, entry.step_number)

            true ->
              :noop
          end
        end)

        notify_parent({:saved, recipe})

        {:noreply,
         socket
         |> put_flash(:info, "Recipe created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp parse_ingredient_entries(params) when is_map(params) do
    params
    |> Enum.map(fn {_idx, entry} ->
      %{
        ingredient_id: entry["ingredient_id"],
        quantity: entry["quantity"],
        unit: entry["unit"]
      }
    end)
  end

  defp parse_ingredient_entries(_), do: []

  defp parse_instruction_entries(params) when is_map(params) do
    params
    |> Enum.sort_by(fn {idx, _} -> String.to_integer(idx) end)
    |> Enum.map(fn {_idx, entry} ->
      %{
        text: entry["text"],
        step_number: entry["step_number"] |> to_string() |> String.to_integer()
      }
    end)
  end

  defp parse_instruction_entries(_), do: []

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp list_users do
    Auth.list_users()
    |> Enum.map(&{&1.email, &1.id})
  end
end
