defmodule SmartRecipeCalculator.AuthFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `SmartRecipeCalculator.Auth` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        password_hash: "some password_hash"
      })
      |> SmartRecipeCalculator.Auth.create_user()

    user
  end

  @doc """
  Generate a session.
  """
  def session_fixture(attrs \\ %{}) do
    {:ok, session} =
      attrs
      |> Enum.into(%{

      })
      |> SmartRecipeCalculator.Auth.create_session()

    session
  end
end
