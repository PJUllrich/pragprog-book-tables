defmodule MeowWeb.MeerkatLive do
  use MeowWeb, :live_view

  alias Meow.Meerkats
  alias MeowWeb.Forms.SortingForm
  alias MeowWeb.Forms.PaginationForm
  alias MeowWeb.Forms.FilterForm

  @impl true
  def mount(_params, _session, socket), do: {:ok, socket}

  @impl true
  def handle_params(params, _url, socket) do
    socket =
      socket
      |> parse_params(params)
      |> assign_meerkats()

    {:noreply, socket}
  end

  @impl true
  def handle_info({:update, opts}, socket) do
    params = merge_and_sanitize_params(socket, opts)
    path = Routes.live_path(socket, __MODULE__, params)
    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  defp parse_params(socket, params) do
    with {:ok, sorting_opts} <- SortingForm.parse(params),
         {:ok, filter_opts} <- FilterForm.parse(params),
         {:ok, pagination_opts} <- PaginationForm.parse(params) do
      socket
      |> assign_sorting(sorting_opts)
      |> assign_filter(filter_opts)
      |> assign_pagination(pagination_opts)
    else
      _error ->
        socket
        |> assign_sorting()
        |> assign_filter()
        |> assign_pagination()
    end
  end

  defp assign_meerkats(socket) do
    params = merge_and_sanitize_params(socket)

    %{meerkats: meerkats, total_count: total_count} =
      Meerkats.list_meerkats_with_total_count(params)

    socket
    |> assign(:meerkats, meerkats)
    |> assign_total_count(total_count)
  end

  defp merge_and_sanitize_params(socket, overrides \\ %{}) do
    %{sorting: sorting, pagination: pagination, filter: filter} = socket.assigns

    %{}
    |> Map.merge(sorting)
    |> Map.merge(pagination)
    |> Map.merge(filter)
    |> Map.merge(overrides)
    |> Map.drop([:total_count])
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end

  defp assign_sorting(socket, overrides \\ %{}) do
    assign(socket, :sorting, SortingForm.default_values(overrides))
  end

  defp assign_pagination(socket, overrides \\ %{}) do
    assign(socket, :pagination, PaginationForm.default_values(overrides))
  end

  defp assign_filter(socket, overrides \\ %{}) do
    assign(socket, :filter, FilterForm.default_values(overrides))
  end

  defp assign_total_count(socket, total_count) do
    update(socket, :pagination, fn pagination -> %{pagination | total_count: total_count} end)
  end
end
