defmodule Meow.Repo.Migrations.CreateMeerkats do
  use Ecto.Migration

  def change do
    create table(:meerkats) do
      add(:name, :string)
      add(:gender, :string)
      add(:weight, :integer)

      timestamps()
    end

    create index(:meerkats, :name)
    create index(:meerkats, :weight)
    create index(:meerkats, :gender)
  end
end
