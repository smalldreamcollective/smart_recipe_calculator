defmodule SmartRecipeCalculator.Auth.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "sessions" do

    field :user_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(session, attrs) do
    session
    |> cast(attrs, [])
    |> validate_required([])
  end
end
