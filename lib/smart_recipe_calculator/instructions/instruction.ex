defmodule SmartRecipeCalculator.Instructions.Instruction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "instructions" do
    field :text, :string
    timestamps()
  end

  def changeset(instruction, attrs) do
    instruction
    |> cast(attrs, [:text])
    |> validate_required([:text])
  end
end
