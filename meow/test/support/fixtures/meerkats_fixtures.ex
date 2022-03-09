defmodule Meow.MeerkatsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Meow.Meerkats` context.
  """

  @doc """
  Generate a meerkat.
  """
  def meerkat_fixture(attrs \\ %{}) do
    {:ok, meerkat} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Meow.Meerkats.create_meerkat()

    meerkat
  end
end
