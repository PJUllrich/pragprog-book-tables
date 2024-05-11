defmodule MeowWeb.InfinityLive do
  use MeowWeb, :live_view

  alias Meow.Meerkats

  def render(assigns) do
    ~H"""
    <table>
      <div id="ping-div" phx-hook="PingPongHook" />
      <tbody id="meerkats"
             phx-update="stream"
             phx-hook="InfinityScroll">
        <%= for {dom_id, meerkat} <- @streams.meerkats do %>
          <tr id={dom_id}>
            <td><%= meerkat.id %></td>
            <td><%= meerkat.name %></td>
          </tr>
        <% end %>
      </tbody>
    </table>
    """
  end

  def mount(_params, _session, socket) do
    count = Meerkats.meerkat_count()

    socket =
      socket
      |> assign(offset: 0, limit: 25, count: count)
      |> load_meerkats()

    {:ok, socket}
  end

  def handle_event("ping", params, socket) do
    IO.inspect("ping", label: "Event")
    IO.inspect(params, label: "Params")
    {:noreply, push_event(socket, "pong", %{message: "Hello there!"})}
  end

  def handle_event("load-more", _params, socket) do
    %{offset: offset, limit: limit, count: count} = socket.assigns

    socket =
      if offset < count do
        socket
        |> assign(offset: offset + limit)
        |> load_meerkats()
      else
        socket
      end

    {:noreply, socket}
  end

  defp load_meerkats(%{assigns: %{offset: offset, limit: limit}} = socket) do
    meerkats = Meerkats.list_meerkats_with_pagination(offset, limit)
    stream(socket, :meerkats, meerkats)
  end
end
