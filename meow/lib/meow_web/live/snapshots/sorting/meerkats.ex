defmodule Meow.Snapshots.Meerkats do
  import Ecto.Query, warn: false

  alias Meow.Repo
  alias Meow.Meerkats.Meerkat

  def list_meerkats do
    Repo.all(Meerkat)
  end

  def list_meerkats(opts) do
    from(m in Meerkat)
    |> sort(opts)
    |> Repo.all()
  end

  defp sort(query, %{sort_by: sort_by, sort_dir: sort_dir})
       when sort_by in [:id, :name] and
              sort_dir in [:asc, :desc] do
    order_by(query, {^sort_dir, ^sort_by})
  end

  defp sort(query, _opts), do: query
end
