## Setup

```
# Versions
mix phx.new - 1.6.2
phoenix - 1.6.2
phoenix_live_view - 0.16.4
Elixir - 1.12.1
erlang - 24.0.6
```

### Setup Phoenix Template and LiveView

```
mix phx.new meow --no-dashboard --no-gettext --no-dashboard --no-mailer
```

Delete `/lib/meow_web/templates/page/`
Delete `/lib/meow_web/controllers`

Add `/lib/meow_web/live/meow_live.ex`
Change in router `get "/", PageController, :index` => `live "/", MeowLive`

Add to `MeowLive`

```
defmodule MeowWeb.MeowLive do
  use MeowWeb, :live_view

  @impl true
  def render(assigns), do: MeowWeb.MeowView.render("index.html", assigns)

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
```

Add `MeowView` in `/lib/meow_web/views`

```
defmodule MeowWeb.MeowView do
  use MeowWeb, :view
end
```

Add `index.html.heex` in `/lib/meow_web/templates/meow`

### Setup Ecto models

```
mix phx.gen.context Meerkats Meerkat meerkats name:string gender:string age:integer weight:integer height:integer
```

Write `seeds.exs` for populating the databaste.

### Presenting the data

Fetch all meerkats with `Meerkats.list_meerkats()` and assign `:meerkats` to `socket`.
Show each meerkat datapoint as a table row.
Format `age` and `height` with functions in `MeowView`.

Don't load anything in `mount/3` and don't assign any assigns, but do everything in `handle_params/3`, because we use `handle_params/3` to re-fetch and re-assign everything whenever a `live_patch` is executed. This is worse for SEO, so if that is a concern, load the meerkats in `load_meerkats_from_params/2` also if the socket is not connected.

https://elixirforum.com/t/understanding-the-liveview-life-cycle/44300
https://hexdocs.pm/phoenix_live_view/live-navigation.html#handle_params-3

## Sorting the table

Replace table headers with `live_patch/2` links that call the `handle_params/3` callback with updated params.

Problem: How to decide whether the sorting direction should be `:asc`, `:desc`, or `:none`?

Problem: How to merge the `sort_by` and `sort_dir` params with the other params for e.g. filtering?

Problem: `fields/0` in `SortingForm` isn't nice. I would rather like to have a `@fields` module attribute, but don't know how to move the `EctoEnum` generation into a private function.
Answer: It's possible to call a function in a module attribute, but only from a different module. I moved the `enum/1` function to a `EctoHelpers` module.

## Paginating

Add `paginate/2` functions to `meerkats.ex`

Add `limit` and `offset` fields to `SortingForm`.
Make sure that they are both greater or equal to `0` by validating them.

Add `meerkat_count` to `meerkats.ex` for getting the total count.

Show pagination buttons at the bottom of the table, each button being a `push_patch`

## Infinity Paginating
2 problems:
1. "load-more" is pushed multiple times when the list is complete (e.g. no new meerkats are loaded)
2. "load-more" is pushed also when the user scrolls back/upwards again.

Solutions:
1. Keep track of `lastScrollAt` and only push the event if the `lastScrollAt` was below 90% and the new one is above 90%. This eliminates all messages after the list is exhausted from the JS to the LiveView. Problem: When the user scrolls up (below 90%) and down (above 90%) again, another message is pushed, incrementing the `offset` by another `limit`. We will handle this by keeping track of the `total_count` in the LiveView.

### References
https://elixirschool.com/blog/live-view-live-component/
https://dashbit.co/blog/surface-liveview