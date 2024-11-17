defmodule ClashOfClansFpl.Fixtures.FixtureResults do
  @moduledoc """
  Season 2024/2025.
  """

  # GW 1
  [
    {"Man Utd 65 - 75 Fulham"},
    {"Ipswich 65 - 71 Liverpool"},
    {"Arsenal 62 - 67 Wolves"},
    {"Everton 67 - 63 Brighton"},
    {"Newcastle 58 - 66 Southampton"},
    {"Nott'm Forest 61 - 63 Bournemouth"},
    {"West Ham 64 - 66 Aston Villa"},
    {"Brentford 68 - 69 Crystal Palace"},
    {"Chelsea 61 - 69 Man City"},
    {"Leicester 62 - 61 Spurs"}
  ]

  # GW 2
  [
    {"Brighton 76 - 72 Man Utd"},
    {"Crystal Palace 78 - 90 West Ham"},
    {"Fulham 86 - 82 Leicester"},
    {"Man City 83 - 84 Ipswich"},
    {"Southampton 76 - 78 Nott'm Forest"},
    {"Spurs 77 - 70 Everton"},
    {"Aston Villa 78 - 79 Arsenal"},
    {"Bournemouth 70 - 77 Newcastle"},
    {"Wolves 92 - 72 Chelsea"},
    {"Liverpool 73 - 78 Brentford"}
  ]

  # GW 3
  [
    {"Arsenal 76 - 73 Brighton"},
    {"Brentford 68 - 74 Southampton"},
    {"Everton 71 - 59 Bournemouth"},
    {"Ipswich 77 - 79 Fulham"},
    {"Leicester 77 - 85 Aston Villa"},
    {"Nott'm Forest 68 - 78 Wolves"},
    {"West Ham 78 - 73 Man City"},
    {"Chelsea 72 - 89 Crystal Palace"},
    {"Newcastle 73 - 73 Spurs"},
    {"Man Utd 66 - 79 Liverpool"}
  ]

  # GW 4 - Average
  [
    {"Southampton 43 - 53 Man Utd"},
    {"Brighton 51 - 50 Ipswich"},
    {"Crystal Palace 51 - 50 Leicester"},
    {"Fulham 51 - 52 West Ham"},
    {"Liverpool 40 - 42 Nott'm Forest"},
    {"Man City 46 - 40 Brentford"},
    {"Aston Villa 46 - 48 Everton"},
    {"Bournemouth 42 - 50 Chelsea"},
    {"Spurs 48 - 51 Arsenal"},
    {"Wolves 52 - 51 Newcastle"}
  ]

  # GW 4 - Median
  [
    {"Southampton 40 - 52 Man Utd"},
    {"Brighton 48 - 53 Ipswich"},
    {"Crystal Palace 48 - 51 Leicester"},
    {"Fulham 50 - 50 West Ham"},
    {"Liverpool 38 - 44 Nott'm Forest"},
    {"Man City 48 - 41 Brentford"},
    {"Aston Villa 45 - 47 Everton"},
    {"Bournemouth 44 - 49 Chelsea"},
    {"Spurs 48 - 51 Arsenal"},
    {"Wolves 55 - 51 Newcastle"}
  ]

  # GW 5
  # Duplicates
  %{
    %{fpl_id: 48930, t_name: "Edrit Vardrid", p_name: "T K"} => 2,
    %{fpl_id: 114_067, t_name: "Clash Of Clans admin", p_name: "FPL HQ"} => 20,
    %{fpl_id: 3_060_242, t_name: "Frequency 102", p_name: "Ruslan Shakiryanov"} => 3,
    %{fpl_id: 4_168_231, t_name: "Maximiliano", p_name: "Maxim NISVITAILOV"} => 2,
    %{fpl_id: 4_369_314, t_name: "Slot Machine �", p_name: "Yermek Abdurakhmanov"} => 2
  }

  # 6
  %{
    %{fpl_id: 48930, t_name: "Edrit Vardrid", p_name: "T K"} => 2,
    %{fpl_id: 3_060_242, t_name: "Frequency 102", p_name: "Ruslan Shakiryanov"} => 3,
    %{fpl_id: 4_168_231, t_name: "Maximiliano", p_name: "Maxim NISVITAILOV"} => 2,
    %{fpl_id: 4_369_314, t_name: "Slot Machine �", p_name: "Yermek Abdurakhmanov"} => 2
  }

  # Просим отписаться в комментах:
  # ID: 48930, 3060242, 4168231, 4369314
  # Название команды: Edrit Vardrid, Frequency 102, Maximiliano, Slot Machine �
  # Менеджер: T K, Ruslan Shakiryanov, Maxim NISVITAILOV, Yermek Abdurakhmanov

  # Вы вступили в 2-3 лиг Clash of Clans, поэтому ваши очки не учтены в подсчетах.
  # Выберите одну лигу, в которой хотите участвовать, и сообщите нам или выйдите самостоятельно из остальных лиг.

  # GW 5 - Average
  [
    {"West Ham 65 - 62 Chelsea"},
    {"Aston Villa 74 - 67 Wolves"},
    {"Fulham 72 - 55 Newcastle"},
    {"Leicester 66 - 62 Everton"},
    {"Liverpool 64 - 62 Bournemouth"},
    {"Southampton 65 - 65 Ipswich"},
    {"Spurs 66 - 68 Brentford"},
    {"Crystal Palace 66 - 62 Man Utd"},
    {"Brighton 63 - 64 Nott'm Forest"},
    {"Man City 68 - 65 Arsenal"}
  ]

  # GW 5 - Median
  [
    {"West Ham 61 - 61 Chelsea"},
    {"Aston Villa 72 - 68 Wolves"},
    {"Fulham 70 - 56 Newcastle"},
    {"Leicester 64 - 61 Everton"},
    {"Liverpool 63 - 63 Bournemouth"},
    {"Southampton 69 - 63 Ipswich"},
    {"Spurs 67 - 67 Brentford"},
    {"Crystal Palace 65 - 63 Man Utd"},
    {"Brighton 59 - 69 Nott'm Forest"},
    {"Man City 72 - 63 Arsenal"}
  ]

  # GW 6 - Average
  [
    {"Newcastle 61 - 47 Man City"},
    {"Arsenal 50 - 46 Leicester"},
    {"Brentford 49 - 43 West Ham"},
    {"Chelsea 57 - 60 Brighton"},
    {"Everton 54 - 54 Crystal Palace"},
    {"Nott'm Forest 54 - 63 Fulham"},
    {"Wolves 55 - 53 Liverpool"},
    {"Ipswich 58 - 52 Aston Villa"},
    {"Man Utd 47 - 50 Spurs"},
    {"Bournemouth 60 - 50 Southampton"}
  ]

  # GW 6 - Median
  [
    {"Newcastle 63 - 44 Man City"},
    {"Arsenal 49 - 40 Leicester"},
    {"Brentford 45 - 42 West Ham"},
    {"Chelsea 56 - 56 Brighton"},
    {"Everton 54 - 57 Crystal Palace"},
    {"Nott'm Forest 60 - 70 Fulham"},
    {"Wolves 54 - 54 Liverpool"},
    {"Ipswich 60 - 53 Aston Villa"},
    {"Man Utd 44 - 55 Spurs"},
    {"Bournemouth 60 - 51 Southampton"}
  ]

  # GW 7 - Average
  [
    {"Crystal Palace 49 - 54 Liverpool"},
    {"Arsenal 54 - 50 Southampton"},
    {"Brentford 47 - 49 Wolves"},
    {"Leicester 52 - 46 Bournemouth"},
    {"Man City 55 - 56 Fulham"},
    {"West Ham 54 - 50 Ipswich"},
    {"Everton 43 - 50 Newcastle"},
    {"Aston Villa 47 - 46 Man Utd"},
    {"Chelsea 47 - 47 Nott'm Forest"},
    {"Brighton 52 - 49 Spurs"}
  ]

  # GW 7 - Median
  [
    {"Crystal Palace 51 - 55 Liverpool"},
    {"Arsenal 52 - 52 Southampton"},
    {"Brentford 42 - 45 Wolves"},
    {"Leicester 54 - 47 Bournemouth"},
    {"Man City 57 - 55 Fulham"},
    {"West Ham 54 - 46 Ipswich"},
    {"Everton 45 - 53 Newcastle"},
    {"Aston Villa 51 - 47 Man Utd"},
    {"Chelsea 46 - 45 Nott'm Forest"},
    {"Brighton 53 - 47 Spurs"}
  ]

  # GW 8 - Duplicates
  %{
    %{fpl_id: 114_067, t_name: "Clash Of Clans admin", p_name: "FPL HQ"} => 20,
    %{fpl_id: 115_668, t_name: "Almaty Gunners �", p_name: "Adilet Tursynbek"} => 2,
    %{fpl_id: 2_988_428, t_name: "dstankevych", p_name: "Dmytro Stankevych"} => 2,
    %{fpl_id: 3_060_242, t_name: "Frequency 102", p_name: "Ruslan Shakiryanov"} => 3
  }

  # GW 8 - Average
  [
    {"Spurs 39 - 30 West Ham"},
    {"Fulham 38 - 40 Aston Villa"},
    {"Man Utd 36 - 41 Brentford"},
    {"Newcastle 40 - 39 Brighton"},
    {"Southampton 43 - 37 Leicester"},
    {"Ipswich 38 - 40 Everton"},
    {"Bournemouth 43 - 40 Arsenal"},
    {"Wolves 35 - 38 Man City"},
    {"Liverpool 41 - 39 Chelsea"},
    {"Nott'm Forest 44 - 45 Crystal Palace"}
  ]

  # GW 8 - Median
  [
    {"Spurs 36 - 28 West Ham"},
    {"Fulham 39 - 40 Aston Villa"},
    {"Man Utd 34 - 36 Brentford"},
    {"Newcastle 41 - 38 Brighton"},
    {"Southampton 47 - 37 Leicester"},
    {"Ipswich 36 - 39 Everton"},
    {"Bournemouth 39 - 41 Arsenal"},
    {"Wolves 36 - 39 Man City"},
    {"Liverpool 39 - 38 Chelsea"},
    {"Nott'm Forest 43 - 48 Crystal Palace"}
  ]

  # GW 9 - Duplicates
  %{
    %{fpl_id: 114_067, t_name: "Clash Of Clans admin", p_name: "FPL HQ"} => 20,
    %{fpl_id: 115_668, t_name: "Almaty Gunners �", p_name: "Adilet Tursynbek"} => 2,
    %{fpl_id: 834_468, t_name: "hhberries", p_name: "hedgehogs & berries"} => 2,
    %{fpl_id: 2_988_428, t_name: "dstankevych", p_name: "Dmytro Stankevych"} => 2,
    %{fpl_id: 3_060_242, t_name: "Frequency 102", p_name: "Ruslan Shakiryanov"} => 3
  }

  # GW 9 - Average
  [
    {"Leicester 65 - 62 Nott'm Forest"},
    {"Aston Villa 58 - 64 Bournemouth"},
    {"Brentford 60 - 57 Ipswich"},
    {"Brighton 60 - 62 Wolves"},
    {"Man City 56 - 60 Southampton"},
    {"Everton 59 - 60 Fulham"},
    {"Chelsea 58 - 56 Newcastle"},
    {"Crystal Palace 61 - 60 Spurs"},
    {"West Ham 61 - 56 Man Utd"},
    {"Arsenal 60 - 61 Liverpool"}
  ]

  # GW 9 - Median
  [
    {"Leicester 65 - 59 Nott'm Forest"},
    {"Aston Villa 60 - 66 Bournemouth"},
    {"Brentford 63 - 54 Ipswich"},
    {"Brighton 61 - 64 Wolves"},
    {"Man City 56 - 61 Southampton"},
    {"Everton 57 - 67 Fulham"},
    {"Chelsea 57 - 55 Newcastle"},
    {"Crystal Palace 62 - 61 Spurs"},
    {"West Ham 60 - 54 Man Utd"},
    {"Arsenal 59 - 60 Liverpool"}
  ]

  # GW 10 - Average
  [
    {"Newcastle 47 - 45 Arsenal"},
    {"Bournemouth 48 - 50 Man City"},
    {"Ipswich 49 - 50 Leicester"},
    {"Liverpool 48 - 46 Brighton"},
    {"Nott'm Forest 43 - 39 West Ham"},
    {"Southampton 42 - 45 Everton"},
    {"Wolves 49 - 47 Crystal Palace"},
    {"Spurs 47 - 52 Aston Villa"},
    {"Man Utd 44 - 46 Chelsea"},
    {"Fulham 49 - 43 Brentford"}
  ]

  # GW 10 - Median
  [
    {"Newcastle 48 - 43 Arsenal"},
    {"Bournemouth 47 - 50 Man City"},
    {"Ipswich 48 - 50 Leicester"},
    {"Liverpool 48 - 45 Brighton"},
    {"Nott'm Forest 42 - 41 West Ham"},
    {"Southampton 41 - 43 Everton"},
    {"Wolves 49 - 46 Crystal Palace"},
    {"Spurs 46 - 57 Aston Villa"},
    {"Man Utd 43 - 47 Chelsea"},
    {"Fulham 47 - 41 Brentford"}
  ]

  # GW 11 duplicates
  %{
    %{fpl_id: 114067, p_name: "FPL HQ", t_name: "Clash Of Clans admin"} => 20,
    %{fpl_id: 834468, p_name: "hedgehogs & berries", t_name: "hhberries"} => 2,
    %{fpl_id: 3060242, p_name: "Ruslan Shakiryanov", t_name: "Frequency 102"} => 3
  }
  
  # GW 11 - Average
  [
    {"Brentford 57 - 56 Bournemouth"},
    {"Crystal Palace 57 - 54 Fulham"},
    {"West Ham 50 - 53 Everton"},
    {"Wolves 52 - 63 Southampton"},
    {"Brighton 58 - 51 Man City"},
    {"Liverpool 56 - 55 Aston Villa"},
    {"Man Utd 58 - 61 Leicester"},
    {"Nott'm Forest 51 - 55 Newcastle"},
    {"Spurs 48 - 58 Ipswich"},
    {"Chelsea 55 - 56 Arsenal"}
  ]
  
  # GW 11 - Median
  [
    {"Brentford 55 - 52 Bournemouth"},
    {"Crystal Palace 53 - 61 Fulham"},
    {"West Ham 49 - 53 Everton"},
    {"Wolves 53 - 63 Southampton"},
    {"Brighton 60 - 50 Man City"},
    {"Liverpool 57 - 59 Aston Villa"},
    {"Man Utd 59 - 57 Leicester"},
    {"Nott'm Forest 55 - 58 Newcastle"},
    {"Spurs 45 - 57 Ipswich"},
    {"Chelsea 55 - 53 Arsenal"}
  ]
  
  ################################################
  # Season 2023/2024 data
  ################################################

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

  # GW 24
  [
    {"Man City 79 - 68 Everton"},
    {"Fulham 75 - 71 Bournemouth"},
    {"Liverpool 63 - 69 Burnley"},
    {"Luton 74 - 75 Sheffield Utd"},
    {"Spurs 72 - 65 Brighton"},
    {"Wolves 67 - 75 Brentford"},
    {"Nott'm Forest 63 - 72 Newcastle"},
    {"West Ham 73 - 71 Arsenal"},
    {"Aston Villa 72 - 70 Man Utd"},
    {"Crystal Palace 63 - 68 Chelsea"}
  ]

  # GW 25
  [
    {"Brentford 65 - 74 Liverpool"},
    {"Burnley 92 - 79 Arsenal"},
    {"Fulham 77 - 76 Aston Villa"},
    {"Newcastle 84 - 66 Bournemouth"},
    {"Nott'm Forest 69 - 85 West Ham"},
    {"Spurs 81 - 85 Wolves"},
    {"Man City 79 - 77 Chelsea"},
    {"Sheffield Utd 89 - 77 Brighton"},
    {"Luton 80 - 79 Man Utd"},
    {"Everton 88 - 79 Crystal Palace"},
    {"Man City 79 - 65 Brentford"},
    {"Liverpool 74 - 80 Luton"}
  ]

  # GW 26
  [
    {"Aston Villa 52 - 52 Nott'm Forest"},
    {"Brighton 51 - 49 Everton"},
    {"Crystal Palace 47 - 61 Burnley"},
    {"Man Utd 49 - 63 Fulham"},
    {"Bournemouth 48 - 56 Man City"},
    {"Arsenal 52 - 49 Newcastle"},
    {"Wolves 46 - 46 Sheffield Utd"},
    {"West Ham 72 - 62 Brentford"}
  ]

  {"Liverpool 48 - 46 Luton"}

  # Che - TTH
  {"Liverpool 49 - 50 Luton"}

  # GW 27
  [
    {"Brentford 62 - 71 Chelsea"},
    {"Everton 72 - 67 West Ham"},
    {"Fulham 55 - 68 Brighton"},
    {"Newcastle 66 - 59 Wolves"},
    {"Nott'm Forest 66 - 69 Liverpool"},
    {"Spurs 69 - 68 Crystal Palace"},
    {"Luton 64 - 75 Aston Villa"},
    {"Burnley 77 - 67 Bournemouth"},
    {"Man City 74 - 68 Man Utd"},
    {"Sheffield Utd 70 - 67 Arsenal"}
  ]

  # GW 28
  [
    {"Man Utd 57 - 59 Everton"},
    {"Bournemouth 49 - 63 Sheffield Utd"},
    {"Crystal Palace 76 - 61 Luton"},
    {"Wolves 59 - 37 Fulham"},
    {"Arsenal 57 - 45 Brentford"},
    {"Aston Villa 53 - 62 Spurs"},
    {"Brighton 63 - 49 Nott'm Forest"},
    {"West Ham 53 - 59 Burnley"},
    {"Liverpool 54 - 56 Man City"},
    {"Chelsea 52 - 63 Newcastle"},
    {"Bournemouth 49 - 61 Luton"}
  ]

  # GW 29
  [
    {"Burnley 14 - 12 Brentford"},
    {"Luton 21 - 14 Nott'm Forest"},
    {"Fulham 20 - 16 Spurs"},
    {"West Ham 19 - 20 Aston Villa"},
    {"Arsenal 15 - 20 Chelsea"},
    {"Crystal Palace 27 - 20 Newcastle"},
    {"Man Utd 16 - 23 Sheffield Utd"},
    {"Wolves 27 - 14 Bournemouth"},
    {"Everton 22 - 18 Liverpool"},
    {"Brighton 28 - 17 Man City"}
  ]

  # GW 30
  [
    {"Newcastle 54 - 55 West Ham"},
    {"Bournemouth 51 - 66 Everton"},
    {"Chelsea 59 - 60 Burnley"},
    {"Nott'm Forest 51 - 66 Crystal Palace"},
    {"Sheffield Utd 39 - 57 Fulham"},
    {"Spurs 63 - 59 Luton"},
    {"Aston Villa 66 - 64 Wolves"},
    {"Brentford 49 - 59 Man Utd"},
    {"Liverpool 59 - 56 Brighton"},
    {"Man City 59 - 61 Arsenal"}
  ]

  # GW 31
  [
    {"Newcastle 55 - 61 Everton"},
    {"Nott'm Forest 56 - 30 Fulham"},
    {"Bournemouth 59 - 56 Crystal Palace"},
    {"Burnley 63 - 59 Wolves"},
    {"West Ham 58 - 60 Spurs"},
    {"Arsenal 56 - 54 Luton"},
    {"Brentford 59 - 53 Brighton"},
    {"Man City 56 - 64 Aston Villa"},
    {"Liverpool 57 - 55 Sheffield Utd"},
    {"Chelsea 55 - 54 Man Utd"}
  ]

  # GW 32
  [
    {"Crystal Palace 80 - 63 Man City"},
    {"Aston Villa 63 - 48 Brentford"},
    {"Everton 60 - 72 Burnley"},
    {"Fulham 46 - 63 Newcastle"},
    {"Luton 65 - 62 Bournemouth"},
    {"Wolves 62 - 63 West Ham"},
    {"Brighton 64 - 64 Arsenal"},
    {"Man Utd 64 - 62 Liverpool"},
    {"Sheffield Utd 64 - 57 Chelsea"},
    {"Spurs 62 - 57 Nott'm Forest"}
  ]

  # GW 33
  [
    {"Newcastle 85 - 68 Spurs"},
    {"Brentford 61 - 65 Sheffield Utd"},
    {"Burnley 60 - 66 Brighton"},
    {"Man City 71 - 68 Luton"},
    {"Nott'm Forest 58 - 71 Wolves"},
    {"Bournemouth 74 - 69 Man Utd"},
    {"Liverpool 67 - 55 Crystal Palace"},
    {"West Ham 63 - 56 Fulham"},
    {"Arsenal 74 - 73 Aston Villa"},
    {"Chelsea 72 - 70 Everton"}
  ]

  # GW 34
  [
    {"Luton 102 - 79 Brentford"},
    {"Sheffield Utd 103 - 74 Burnley"},
    {"Wolves 62 - 102 Arsenal"},
    {"Everton 101 - 97 Nott'm Forest"},
    {"Aston Villa 107 - 90 Bournemouth"},
    {"Crystal Palace 103 - 101 West Ham"},
    {"Fulham 57 - 92 Liverpool"},
    # Spurs MC
    # MU NU
    # Brighton Chelsea

    # Extra
    {"Arsenal 102 - 86 Chelsea"},
    {"Wolves 62 - 90 Bournemouth"},
    {"Crystal Palace 103 - 88 Newcastle"},
    {"Everton 101 - 92 Liverpool"},
    {"Man Utd 91 - 103 Sheffield Utd"},
    {"Brighton 84 - 94 Man City"}
  ]

  # GW 35
  [
    {"West Ham 55 - 65 Liverpool"},
    {"Fulham 49 - 66 Crystal Palace"},
    {"Man Utd 67 - 68 Burnley"},
    {"Newcastle 72 - 66 Sheffield Utd"},
    {"Wolves 72 - 70 Luton"},
    {"Everton 74 - 47 Brentford"},
    {"Aston Villa 76 - 68 Chelsea"},
    {"Bournemouth 66 - 71 Brighton"},
    {"Spurs 69 - 69 Arsenal"},
    {"Nott'm Forest 46 - 66 Man City"},
    {"Chelsea 68 - 69 Spurs"}
  ]

  # GW 36
  # early wrong one
  # [
  #   {"Luton 90 - 88 Everton"},
  #   {"Arsenal 83 - 77 Bournemouth"},
  #   {"Brentford 60 - 61 Fulham"},
  #   {"Burnley 77 - 92 Newcastle"},
  #   {"Sheffield Utd 81 - 63 Nott'm Forest"},
  #   {"Man City 85 - 75 Wolves"},
  #   {"Brighton 87 - 83 Aston Villa"},
  #   {"Chelsea 77 - 73 West Ham"},
  #   {"Liverpool 76 - 80 Spurs"},
  #   {"Crystal Palace 92 - 80 Man Utd"}
  # ]

  [
    {"Luton 94 - 99 Everton"},
    {"Arsenal 87 - 79 Bournemouth"},
    {"Brentford 65 - 65 Fulham"},
    {"Burnley 83 - 94 Newcastle"},
    {"Sheffield Utd 85 - 67 Nott'm Forest"},
    {"Man City 87 - 76 Wolves"},
    {"Brighton 87 - 89 Aston Villa"},
    {"Chelsea 84 - 77 West Ham"},
    {"Liverpool 81 - 86 Spurs"},
    {"Crystal Palace 94 - 86 Man Utd"}
  ]

  # GW 37
  [
    {"Fulham 87 - 115 Man City"},
    {"Bournemouth 111 - 88 Brentford"},
    {"Everton 116 - 115 Sheffield Utd"},
    {"Newcastle 116 - 115 Brighton"},
    {"Spurs 118 - 124 Burnley"},
    {"West Ham 112 - 112 Luton"},
    {"Wolves 109 - 98 Crystal Palace"},
    {"Nott'm Forest 102 - 110 Chelsea"},
    {"Man Utd 116 - 117 Arsenal"},
    {"Aston Villa 125 - 106 Liverpool"},

    # Extra
    {"Spurs 118 - 115 Man City"},
    {"Brighton 115 - 110 Chelsea"},
    {"Man Utd 116 - 116 Newcastle"}
  ]

  # GW 38
  [
    {"Arsenal 62 - 49 Everton"},
    {"Brentford 49 - 73 Newcastle"},
    {"Brighton 75 - 60 Man Utd"},
    {"Burnley 67 - 53 Nott'm Forest"},
    {"Chelsea 64 - 59 Bournemouth"},
    {"Crystal Palace 56 - 70 Aston Villa"},
    {"Liverpool 59 - 70 Wolves"},
    {"Luton 63 - 51 Fulham"},
    {"Man City 69 - 60 West Ham"},
    {"Sheffield Utd 63 - 71 Spurs"}
  ]
end
