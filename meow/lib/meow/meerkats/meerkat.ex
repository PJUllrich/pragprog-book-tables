defmodule Meow.Meerkats.Meerkat do
  use Ecto.Schema
  import Ecto.Changeset

  schema "meerkats" do
    field(:age, :integer)
    field(:gender, :string)
    field(:name, :string)
    field(:weight, :integer)
    field(:height, :integer)

    timestamps()
  end

  @doc false
  def changeset(meerkat, attrs) do
    meerkat
    |> cast(attrs, [:name, :gender, :age, :weight, :height])
    |> validate_required([:name, :gender, :age, :weight, :height])
  end
end
