defmodule Meow.MeerkatsTest do
  use Meow.DataCase

  alias Meow.Meerkats

  describe "meerkats" do
    alias Meow.Meerkats.Meerkat

    import Meow.MeerkatsFixtures

    @invalid_attrs %{name: nil}

    test "list_meerkats/0 returns all meerkats" do
      meerkat = meerkat_fixture()
      assert Meerkats.list_meerkats() == [meerkat]
    end

    test "get_meerkat!/1 returns the meerkat with given id" do
      meerkat = meerkat_fixture()
      assert Meerkats.get_meerkat!(meerkat.id) == meerkat
    end

    test "create_meerkat/1 with valid data creates a meerkat" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Meerkat{} = meerkat} = Meerkats.create_meerkat(valid_attrs)
      assert meerkat.name == "some name"
    end

    test "create_meerkat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Meerkats.create_meerkat(@invalid_attrs)
    end

    test "update_meerkat/2 with valid data updates the meerkat" do
      meerkat = meerkat_fixture()

      update_attrs = %{
        name: "some updated name"
      }

      assert {:ok, %Meerkat{} = meerkat} = Meerkats.update_meerkat(meerkat, update_attrs)
      assert meerkat.name == "some updated name"
    end

    test "update_meerkat/2 with invalid data returns error changeset" do
      meerkat = meerkat_fixture()
      assert {:error, %Ecto.Changeset{}} = Meerkats.update_meerkat(meerkat, @invalid_attrs)
      assert meerkat == Meerkats.get_meerkat!(meerkat.id)
    end

    test "delete_meerkat/1 deletes the meerkat" do
      meerkat = meerkat_fixture()
      assert {:ok, %Meerkat{}} = Meerkats.delete_meerkat(meerkat)
      assert_raise Ecto.NoResultsError, fn -> Meerkats.get_meerkat!(meerkat.id) end
    end

    test "change_meerkat/1 returns a meerkat changeset" do
      meerkat = meerkat_fixture()
      assert %Ecto.Changeset{} = Meerkats.change_meerkat(meerkat)
    end
  end
end
