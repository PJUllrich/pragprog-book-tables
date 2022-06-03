defmodule MeowWeb.Forms.SortingFormTest do
  use Meow.DataCase, async: true

  alias MeowWeb.Forms.SortingForm

  @default_params %{
    "sort_by" => "name",
    "sort_dir" => "desc"
  }

  describe "parse/1" do
    test "parses all fields correctly" do
      {:ok, params} = SortingForm.parse(@default_params)
      assert params.sort_by == :name
      assert params.sort_dir == :desc
    end

    test "validates the fields" do
      assert {:ok, _params} = SortingForm.parse(@default_params)

      assert {:error, _changeset} =
               @default_params |> Map.merge(%{"sort_by" => "foo"}) |> SortingForm.parse()

      assert {:error, _changeset} =
               @default_params |> Map.merge(%{"sort_dir" => "foo"}) |> SortingForm.parse()
    end
  end
end
