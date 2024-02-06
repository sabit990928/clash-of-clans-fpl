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

  [
    {"💣 Arsenal | t.me/FPL_HQ", 2_339_785, 32},
    {"🦁Aston Villa | t.me/FPL_HQ", 2_340_021, 36},
    {"🍒Bournemouth | t.me/FPL_HQ", 2_340_440, 53},
    {"🐝 Brentford | t.me/FPL_HQ", 2_340_461, 39},
    {"🔹Brighton | t.me/FPL_HQ", 2_339_736, 40},
    {"🍷 Burnley | t.me/FPL_HQ", 2_339_918, 39},
    {"🧿 Chelsea | t.me/FPL_HQ", 2_339_789, 28},
    {"🦅Crystal Palace | t.me/FPL_HQ", 2_340_487, 53},
    {"🍬 Everton | t.me/FPL_HQ", 2_340_494, 41},
    {"🏡 Fulham | t.me/FPL_HQ", 2_340_497, 33},
    {"♦️ Liverpool | t.me/FPL_HQ", 2_339_788, 32},
    {"🎩 Luton Town | t.me/FPL_HQ", 2_340_499, 36},
    {"🧑🏼‍🦲 Man city | t.me/FPL_HQ", 2_339_797, 31},
    {"😈 Man United | t.me/FPL_HQ", 2_339_778, 26},
    {"🔲 Newcastle Utd | t.me/FPL_HQ", 2_340_503, 47},
    {"🌳Nottingham | t.me/FPL_HQ", 2_340_513, 45},
    {"⚔️ Sheffield Utd | t.me/FPL_HQ", 2_340_517, 53},
    {"🐓Tottenham | t.me/FPL_HQ", 2_339_793, 29},
    {"West Ham United | t.me/FPL_HQ", 2_339_997, 40},
    {"🐺 Wolverhampton | t.me/FPL_HQ", 2_340_559, 30}
  ]

  # GW 19
  [
    {"Newcastle 41 - 41 Nott'm Forest"},
    {"Bournemouth 21 - 13 Fulham"},
    {"Sheffield Utd 21 - 18 Luton"},
    {"Burnley 24 - 31 Liverpool"},
    {"Man Utd 25 - 33 Aston Villa"},
    {"Brentford 24 - 25 Wolves"},
    {"Chelsea 26 - 21 Crystal Palace"},
    {"Everton 29 - 20 Man City"},
    {"Brighton 41 - 26 Spurs"},
    {"Arsenal 31 - 42 West Ham"}
  ]

  # After GW 20
  [
    {"💣 Arsenal | t.me/FPL_HQ", 19},
    {"🦁Aston Villa | t.me/FPL_HQ", 9},
    {"🍒Bournemouth | t.me/FPL_HQ", 9},
    {"🐝 Brentford | t.me/FPL_HQ", 3},
    {"🔹Brighton | t.me/FPL_HQ", 4},
    {"🍷 Burnley | t.me/FPL_HQ", 3},
    {"🧿 Chelsea | t.me/FPL_HQ", 21},
    {"🦅Crystal Palace | t.me/FPL_HQ", 2},
    {"🍬 Everton | t.me/FPL_HQ", 4},
    {"🏡 Fulham | t.me/FPL_HQ", 2},
    {"♦️ Liverpool | t.me/FPL_HQ", 30},
    {"🎩 Luton Town | t.me/FPL_HQ", 4},
    {"🧑🏼‍🦲 Man city | t.me/FPL_HQ", 7},
    {"😈 Man United | t.me/FPL_HQ", 41},
    {"🔲 Newcastle Utd | t.me/FPL_HQ", 4},
    {"🌳Nottingham | t.me/FPL_HQ", 4},
    {"⚔️ Sheffield Utd | t.me/FPL_HQ", 3},
    {"🐓Tottenham | t.me/FPL_HQ", 13},
    {"⚒West Ham United | t.me/FPL_HQ", 4},
    {"🐺 Wolverhampton | t.me/FPL_HQ", 3}
  ]

  # GW 20
  [
    {"Luton 76 - 77 Chelsea"},
    {"Aston Villa 80 - 78 Burnley"},
    {"Crystal Palace 97 - 70 Brentford"},
    {"Man City 78 - 72 Sheffield Utd"},
    {"Wolves 69 - 88 Everton"},
    {"Nott'm Forest 54 - 73 Man Utd"},
    {"Fulham 45 - 79 Arsenal"},
    {"Spurs 78 - 79 Bournemouth"},
    {"Liverpool 77 - 78 Newcastle"},
    {"West Ham 74 - 85 Brighton"}
  ]

  # Updated GW 20 after duplicate clearance
  [
    {"Luton 76 - 77 Chelsea"},
    {"Aston Villa 80 - 78 Burnley"},
    {"Crystal Palace 97 - 70 Brentford"},
    {"Man City 78 - 72 Sheffield Utd"},
    {"Wolves 69 - 88 Everton"},
    {"Nott'm Forest 54 - 73 Man Utd"},
    {"Fulham 45 - 78 Arsenal"},
    {"Spurs 78 - 79 Bournemouth"},
    {"Liverpool 77 - 78 Newcastle"},
    {"West Ham 74 - 85 Brighton"}
  ]

  # GW 21
  [
    {"Burnley 70 - 65 Luton"},
    {"Chelsea 52 - 23 Fulham"},
    {"Newcastle 53 - 59 Man City"},
    {"Everton 60 - 63 Aston Villa"},
    {"Man Utd 54 - 61 Spurs"},
    {"Arsenal 58 - 66 Crystal Palace"},
    {"Brentford 47 - 57 Nott'm Forest"},
    {"Sheffield Utd 48 - 52 West Ham"},
    {"Bournemouth 61 - 60 Liverpool"},
    {"Brighton 65 - 52 Wolves"}
  ]

  # GW 22
  [
    {"Nott'm Forest 49 - 54 Arsenal"},
    {"Fulham 48 - 55 Everton"},
    {"Luton 54 - 55 Brighton"},
    {"Crystal Palace 59 - 63 Sheffield Utd"},
    {"Aston Villa 54 - 55 Newcastle"},
    {"Man City 57 - 56 Burnley"},
    {"Spurs 56 - 52 Brentford"},
    {"Liverpool 57 - 58 Chelsea"},
    {"West Ham 57 - 55 Bournemouth"},
    {"Wolves 53 - 55 Man Utd"}
  ]

  # GW 23
  [
    {"Everton 75 - 67 Spurs"},
    {"Brighton 75 - 72 Crystal Palace"},
    {"Burnley 76 - 54 Fulham"},
    {"Newcastle 70 - 71 Luton"},
    {"Sheffield Utd 50 - 79 Aston Villa"},
    {"Bournemouth 68 - 60 Nott'm Forest"},
    {"Chelsea 65 - 49 Wolves"},
    {"Man Utd 70 - 54 West Ham"},
    {"Arsenal 69 - 66 Liverpool"},
    {"Brentford 49 - 64 Man City"}
  ]
end
