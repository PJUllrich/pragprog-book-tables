defmodule MeowWeb.MeowLiveTest do
  use MeowWeb.ConnCase, async: true

  import Meow.MeerkatsFixtures

  describe "sorting" do
    setup %{conn: conn} do
      meerkat_1 = meerkat_fixture(%{name: "Arnold"})
      meerkat_2 = meerkat_fixture(%{name: "Bertie"})

      {:ok, %{conn: conn, meerkat_1: meerkat_1, meerkat_2: meerkat_2}}
    end

    test "sorts ascending by ID", %{conn: conn, meerkat_1: meerkat_1, meerkat_2: meerkat_2} do
      {:ok, _live, html} =
        live(conn, Routes.live_path(conn, MeowWeb.MeowLive, sort_by: :id, sort_dir: :asc))

      assert get_row_ids(html) == [meerkat_1.id, meerkat_2.id]
    end

    test "sorts descending by ID", %{conn: conn, meerkat_1: meerkat_1, meerkat_2: meerkat_2} do
      {:ok, _live, html} =
        live(conn, Routes.live_path(conn, MeowWeb.MeowLive, sort_by: :id, sort_dir: :desc))

      assert get_row_ids(html) == [meerkat_2.id, meerkat_1.id]
    end

    test "sorts ascending by Name", %{conn: conn, meerkat_1: meerkat_1, meerkat_2: meerkat_2} do
      {:ok, _live, html} =
        live(conn, Routes.live_path(conn, MeowWeb.MeowLive, sort_by: :name, sort_dir: :asc))

      assert get_row_ids(html) == [meerkat_1.id, meerkat_2.id]
    end

    test "sorts descending by Name", %{conn: conn, meerkat_1: meerkat_1, meerkat_2: meerkat_2} do
      {:ok, _live, html} =
        live(conn, Routes.live_path(conn, MeowWeb.MeowLive, sort_by: :name, sort_dir: :desc))

      assert get_row_ids(html) == [meerkat_2.id, meerkat_1.id]
    end
  end

  describe "pagination" do
    setup %{conn: conn} do
      meerkats = for _ <- 1..25, do: meerkat_fixture()

      {:ok, %{conn: conn, meerkats: meerkats}}
    end

    test "shows the first page by default", %{conn: conn, meerkats: meerkats} do
      {:ok, _live, html} = live(conn, Routes.live_path(conn, MeowWeb.MeowLive))
      first_10_meerkat_ids = Enum.take(meerkats, 20) |> Enum.map(& &1.id)

      assert get_row_ids(html) == first_10_meerkat_ids
    end

    test "respects the limit-parameter", %{conn: conn, meerkats: meerkats} do
      {:ok, _live, html} = live(conn, Routes.live_path(conn, MeowWeb.MeowLive, limit: 5))
      first_5_meerkat_ids = Enum.take(meerkats, 5) |> Enum.map(& &1.id)

      assert get_row_ids(html) == first_5_meerkat_ids
    end

    test "respects the offset-parameter", %{conn: conn, meerkats: meerkats} do
      {:ok, _live, html} = live(conn, Routes.live_path(conn, MeowWeb.MeowLive, offset: 20))
      last_5_meerkat_ids = Enum.take(meerkats, -5) |> Enum.map(& &1.id)

      assert get_row_ids(html) == last_5_meerkat_ids
    end

    test "respects the combination of limit and offset parameters", %{
      conn: conn,
      meerkats: meerkats
    } do
      {:ok, _live, html} =
        live(conn, Routes.live_path(conn, MeowWeb.MeowLive, limit: 4, offset: 20))

      last_5_meerkat_ids = Enum.take(meerkats, -5) |> Enum.map(& &1.id)
      last_4_meerkat_ids_wo_last_one = Enum.drop(last_5_meerkat_ids, -1)

      assert get_row_ids(html) == last_4_meerkat_ids_wo_last_one
    end
  end

  describe "handle_params" do
    test "shows an error message if invalid params were given", %{conn: conn} do
      {:ok, _live, html} =
        live(
          conn,
          Routes.live_path(conn, MeowWeb.MeowLive,
            sort_by: :name,
            sort_dir: :desc,
            limit: 4,
            offset: -1
          )
        )

      assert html =~ "We are unable to show you the data as you wished"
      assert get_row_ids(html) == []
    end
  end

  describe "filter" do
    setup %{conn: conn} do
      meerkat_1 = meerkat_fixture(%{name: "Arnold", gender: :male, weight: 100})
      meerkat_2 = meerkat_fixture(%{name: "Bertie", gender: :female, weight: 200})

      {:ok, %{conn: conn, meerkat_1: meerkat_1, meerkat_2: meerkat_2}}
    end

    test "filters by id", %{conn: conn, meerkat_2: meerkat_2} do
      {:ok, _live, html} = live(conn, Routes.live_path(conn, MeowWeb.MeowLive, id: meerkat_2.id))

      assert get_row_ids(html) == [meerkat_2.id]
    end

    test "filters by name", %{conn: conn, meerkat_2: meerkat_2} do
      {:ok, _live, html} = live(conn, Routes.live_path(conn, MeowWeb.MeowLive, name: "rti"))

      assert get_row_ids(html) == [meerkat_2.id]
    end
  end

  defp get_row_ids(html) do
    html
    |> Floki.parse_document!()
    |> Floki.find("tbody > tr")
    |> Floki.attribute("data-test-id")
    |> Enum.map(&String.to_integer/1)
  end
end
