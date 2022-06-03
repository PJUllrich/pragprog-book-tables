defmodule MeowWeb.SortingViewTest do
  use MeowWeb.ConnCase, async: true

  import Phoenix.HTML

  alias MeowWeb.SortingView

  describe "sorting_link" do
    test "generates a link for sorting by a column ascending", %{conn: conn} do
      dom =
        SortingView.sorting_link(conn, %{sort_by: :id, sort_dir: :asc}, :name, do: nil)
        |> safe_to_string()

      assert dom =~ ~s|href="/?sort_by=name&amp;sort_dir=asc"|
    end

    test "sorts descending if sort_by is already set", %{conn: conn} do
      dom =
        SortingView.sorting_link(conn, %{sort_by: :name, sort_dir: :asc}, :name, do: nil)
        |> safe_to_string()

      assert dom =~ ~s|href="/?sort_by=name&amp;sort_dir=desc"|
    end

    test "falls back to the default sorting if a column is sorted descendingly already", %{
      conn: conn
    } do
      dom =
        SortingView.sorting_link(conn, %{sort_by: :name, sort_dir: :desc}, :name, do: nil)
        |> safe_to_string()

      assert dom =~ ~s|href="/?sort_by=id&amp;sort_dir=asc"|
    end
  end

  describe "sorting_column_title" do
    test "returns an ascending chevron if sorted ascending by the current key" do
      assert SortingView.sorting_column_title(%{sort_by: :name, sort_dir: :asc}, :name) ==
               "Name 🔼"
    end

    test "returns an descending chevron if sorted descending by the current key" do
      assert SortingView.sorting_column_title(%{sort_by: :name, sort_dir: :desc}, :name) ==
               "Name 🔽"
    end

    test "returns an empty string if not sorteg by the current key" do
      assert SortingView.sorting_column_title(%{sort_by: :id, sort_dir: :asc}, :name) == "Name "
    end
  end
end
