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