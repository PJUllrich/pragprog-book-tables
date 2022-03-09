defmodule MeowWeb.MeerkatLiveTest do
  use MeowWeb.ConnCase

  import Phoenix.LiveViewTest
  import Meow.MeerkatsFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_meerkat(_) do
    meerkat = meerkat_fixture()
    %{meerkat: meerkat}
  end

  describe "Index" do
    setup [:create_meerkat]

    test "lists all meerkats", %{conn: conn, meerkat: meerkat} do
      {:ok, _index_live, html} = live(conn, Routes.meerkat_index_path(conn, :index))

      assert html =~ "Listing Meerkats"
      assert html =~ meerkat.name
    end

    test "saves new meerkat", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.meerkat_index_path(conn, :index))

      assert index_live |> element("a", "New Meerkat") |> render_click() =~
               "New Meerkat"

      assert_patch(index_live, Routes.meerkat_index_path(conn, :new))

      assert index_live
             |> form("#meerkat-form", meerkat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#meerkat-form", meerkat: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.meerkat_index_path(conn, :index))

      assert html =~ "Meerkat created successfully"
      assert html =~ "some name"
    end

    test "updates meerkat in listing", %{conn: conn, meerkat: meerkat} do
      {:ok, index_live, _html} = live(conn, Routes.meerkat_index_path(conn, :index))

      assert index_live |> element("#meerkat-#{meerkat.id} a", "Edit") |> render_click() =~
               "Edit Meerkat"

      assert_patch(index_live, Routes.meerkat_index_path(conn, :edit, meerkat))

      assert index_live
             |> form("#meerkat-form", meerkat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#meerkat-form", meerkat: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.meerkat_index_path(conn, :index))

      assert html =~ "Meerkat updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes meerkat in listing", %{conn: conn, meerkat: meerkat} do
      {:ok, index_live, _html} = live(conn, Routes.meerkat_index_path(conn, :index))

      assert index_live |> element("#meerkat-#{meerkat.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#meerkat-#{meerkat.id}")
    end
  end

  describe "Show" do
    setup [:create_meerkat]

    test "displays meerkat", %{conn: conn, meerkat: meerkat} do
      {:ok, _show_live, html} = live(conn, Routes.meerkat_show_path(conn, :show, meerkat))

      assert html =~ "Show Meerkat"
      assert html =~ meerkat.name
    end

    test "updates meerkat within modal", %{conn: conn, meerkat: meerkat} do
      {:ok, show_live, _html} = live(conn, Routes.meerkat_show_path(conn, :show, meerkat))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Meerkat"

      assert_patch(show_live, Routes.meerkat_show_path(conn, :edit, meerkat))

      assert show_live
             |> form("#meerkat-form", meerkat: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#meerkat-form", meerkat: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.meerkat_show_path(conn, :show, meerkat))

      assert html =~ "Meerkat updated successfully"
      assert html =~ "some updated name"
    end
  end
end
