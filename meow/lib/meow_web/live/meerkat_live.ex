defmodule MeowWeb.MeerkatLive do
  use MeowWeb, :live_view

  alias Meow.Meerkats
  alias MeowWeb.Forms.SortingForm
  alias MeowWeb.Forms.FilterForm

  def mount(_params, _session, socket), do: {:ok, socket}

  def handle_params(params, _url, socket) do
    socket =
      socket
      |> parse_params(params)
      |> assign_meerkats()

    {:noreply, socket}
  end

  def handle_info({:update, opts}, socket) do
    params = merge_and_sanitize_params(socket, opts)
    path = Routes.live_path(socket, __MODULE__, params)
    {:noreply, push_patch(socket, to: path, replace: true)}
  end

  defp parse_params(socket, params) do
    with {:ok, sorting_opts} <- SortingForm.parse(params),
         {:ok, filter_opts} <- FilterForm.parse(params) do
      socket
      |> assign_filter(filter_opts)
      |> assign_sorting(sorting_opts)
    else
      _error ->
        socket
        |> assign_sorting()
        |> assign_filter()
    end
  end

  defp assign_sorting(socket, overrides \\ %{}) do
    opts = Map.merge(SortingForm.default_values(), overrides)
    assign(socket, :sorting, opts)
  end

  defp assign_filter(socket, overrides \\ %{}) do
    assign(socket, :filter, FilterForm.default_values(overrides))
  end

  defp assign_meerkats(socket) do
    params = merge_and_sanitize_params(socket)

    assign(socket, :meerkats, Meerkats.list_meerkats(params))
  end

  defp merge_and_sanitize_params(socket, overrides \\ %{}) do
    %{sorting: sorting, filter: filter} = socket.assigns

    %{}
    |> Map.merge(sorting)
    |> Map.merge(filter)
    |> Map.merge(overrides)
    |> drop_empty_params()
  end

  defp drop_empty_params(params) do
    params
    |> Enum.reject(fn {_key, value} -> is_nil(value) end)
    |> Map.new()
  end
end
