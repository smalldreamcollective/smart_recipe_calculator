defmodule SmartRecipeCalculator.Instructions do
  import Ecto.Query, warn: false
  alias SmartRecipeCalculator.Repo

  alias SmartRecipeCalculator.Instructions.Instruction

  def list_instructions do
    Repo.all(Instruction)
  end

  def get_instruction!(id), do: Repo.get!(Instruction, id)

  def create_instruction(attrs \\ %{}) do
    %Instruction{}
    |> Instruction.changeset(attrs)
    |> Repo.insert()
  end

  def update_instruction(%Instruction{} = instruction, attrs) do
    instruction
    |> Instruction.changeset(attrs)
    |> Repo.update()
  end

  def delete_instruction(%Instruction{} = instruction) do
    Repo.delete(instruction)
  end

  def change_instruction(%Instruction{} = instruction, attrs \\ %{}) do
    Instruction.changeset(instruction, attrs)
  end
end
