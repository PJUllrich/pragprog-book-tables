defmodule MeowWeb.MeowLive do
  use MeowWeb, :live_view

  alias Meow.Meerkats

  @impl true
  def render(assigns), do: MeowWeb.MeowView.render("index.html", assigns)

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :meerkats, Meerkats.list_meerkats())}
  end
end
