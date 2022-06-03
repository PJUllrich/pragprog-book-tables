defmodule MeowWeb.Router do
  use MeowWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_live_flash)
    plug(:put_root_layout, {MeowWeb.LayoutView, :root})
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", MeowWeb do
    pipe_through(:browser)

    live("/", MeerkatLive)
    live("/infinity", InfinityLive)
  end
end
