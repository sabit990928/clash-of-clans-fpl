defmodule ClashOfClansFplWeb.Router do
  use ClashOfClansFplWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {ClashOfClansFplWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", ClashOfClansFplWeb do
    pipe_through :browser

    # get "/", PageController, :home

    live "/", ClashTeamLive.Index, :index

    live "/teams", TeamLive.Index, :index
    live "/teams/new", TeamLive.Index, :new
    live "/teams/:id/edit", TeamLive.Index, :edit

    live "/teams/:id", TeamLive.Show, :show
    live "/teams/:id/show/edit", TeamLive.Show, :edit

    # Fixtures
    live "/fixtures", FixtureLive.Index, :index
    live "/fixtures/new", FixtureLive.Index, :new
    live "/fixtures/:id/edit", FixtureLive.Index, :edit

    live "/fixtures/:id", FixtureLive.Show, :show
    live "/fixtures/:id/show/edit", FixtureLive.Show, :edit

    # Managers
    live "/managers", ManagerLive.Index, :index
    live "/managers/new", ManagerLive.Index, :new
    live "/managers/:id/edit", ManagerLive.Index, :edit

    live "/managers/:id", ManagerLive.Show, :show
    live "/managers/:id/show/edit", ManagerLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", ClashOfClansFplWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:clash_of_clans_fpl, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: ClashOfClansFplWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
