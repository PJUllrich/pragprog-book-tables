defmodule MeowWeb.MeerkatLive.PaginationComponent do
  use MeowWeb, :live_component

  alias MeowWeb.Forms.PaginationForm

  @impl true
  def render(assigns) do
    ~H"""
    <div class="pagination">
      <div class="page-stepper">
        <%= for {page_number, current_page?} <- pages(@pagination) do %>
          <div phx-click="show_page" phx-value-page={page_number} phx-target={@myself} class={"pagination-button #{if current_page?, do: "active"}"} >
            <%= page_number %>
          </div>
        <% end %>
      </div>
      <div>
        <.form :let={f} for={%{}} as={:page_size} phx-change="set_page_size" phx-target={@myself} >
          <%= select f, :page_size, [10, 20, 50, 100], selected: @pagination.page_size %>
        </.form>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("show_page", params, socket) do
    parse_params(params, socket)
  end

  @impl true
  def handle_event("set_page_size", %{"page_size" => params}, socket) do
    parse_params(params, socket)
  end

  defp parse_params(params, socket) do
    %{pagination: pagination} = socket.assigns

    case PaginationForm.parse(params, pagination) do
      {:ok, opts} ->
        send(self(), {:update, opts})
        {:noreply, socket}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  def pages(%{page_size: page_size, page: current_page, total_count: total_count}) do
    page_count = ceil(total_count / page_size)

    for page <- 1..page_count//1 do
      current_page? = page == current_page

      {page, current_page?}
    end
  end
end
