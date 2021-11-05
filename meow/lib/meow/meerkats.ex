defmodule Meow.Meerkats do
  @moduledoc """
  The Meerkats context.
  """

  import Ecto.Query, warn: false
  alias Meow.Repo

  alias Meow.Meerkats.Meerkat

  @doc """
  Returns the list of meerkats.

  ## Examples

      iex> list_meerkats()
      [%Meerkat{}, ...]

  """
  def list_meerkats do
    Repo.all(Meerkat)
  end

  @doc """
  Gets a single meerkat.

  Raises `Ecto.NoResultsError` if the Meerkat does not exist.

  ## Examples

      iex> get_meerkat!(123)
      %Meerkat{}

      iex> get_meerkat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_meerkat!(id), do: Repo.get!(Meerkat, id)

  @doc """
  Creates a meerkat.

  ## Examples

      iex> create_meerkat(%{field: value})
      {:ok, %Meerkat{}}

      iex> create_meerkat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_meerkat(attrs \\ %{}) do
    %Meerkat{}
    |> Meerkat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a meerkat.

  ## Examples

      iex> update_meerkat(meerkat, %{field: new_value})
      {:ok, %Meerkat{}}

      iex> update_meerkat(meerkat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_meerkat(%Meerkat{} = meerkat, attrs) do
    meerkat
    |> Meerkat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a meerkat.

  ## Examples

      iex> delete_meerkat(meerkat)
      {:ok, %Meerkat{}}

      iex> delete_meerkat(meerkat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_meerkat(%Meerkat{} = meerkat) do
    Repo.delete(meerkat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking meerkat changes.

  ## Examples

      iex> change_meerkat(meerkat)
      %Ecto.Changeset{data: %Meerkat{}}

  """
  def change_meerkat(%Meerkat{} = meerkat, attrs \\ %{}) do
    Meerkat.changeset(meerkat, attrs)
  end
end
