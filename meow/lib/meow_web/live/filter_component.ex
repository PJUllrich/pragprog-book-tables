defmodule MeowWeb.MeerkatLive.FilterComponent do
  use MeowWeb, :live_component

  alias MeowWeb.Forms.FilterForm

  def render(assigns) do
    ~H"""
    <div id="table-filter">
      <.form let={f} for={@changeset} as="filter" phx-submit="search" phx-target={@myself} >
        <div class="row">
          <div class="w-15">
            <%= label f, :id %>
            <%= number_input f, :id %>
            <%= error_tag f, :id %>
          </div>
          <div class="w-30">
            <%= label f, :name %>
            <%= text_input f, :name %>
            <%= error_tag f, :name %>
          </div>
          <div class="btn-submit">
            <%= submit "Search" %>
          </div>
        </div>
      </.form>
    </div>
    """
  end

  def update(%{filter: filter}, socket) do
    {:ok, assign(socket, :changeset, FilterForm.change_values(filter))}
  end

  def handle_event("search", %{"filter" => filter}, socket) do
    case FilterForm.parse(filter) do
      {:ok, opts} ->
        send(self(), {:update, opts})
        {:noreply, socket}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
