defmodule Meow.Repo.Migrations.CreateMeerkats do
  use Ecto.Migration

  def change do
    create table(:meerkats) do
      add(:name, :string)
      add(:gender, :string)
      add(:age, :integer)
      add(:weight, :integer)
      add(:height, :integer)

      timestamps()
    end
  end
end
