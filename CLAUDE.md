# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Phoenix LiveView application for managing a Fantasy Premier League (FPL) competition called "Clash of Clans FPL". The application tracks teams, fixtures, and managers across multiple seasons, with data integration from external FPL APIs and CSV imports.

## Core Architecture

### Main Components
- **Phoenix LiveView Frontend**: Interactive UI with real-time updates for teams, fixtures, and managers
- **Ecto Database Layer**: PostgreSQL with migrations for teams, fixtures, managers, and season data
- **Data Integration**: CSV import system and external API integration for FPL data
- **Scheduler**: Background job processing for periodic data updates

### Key Modules
- `ClashOfClansFpl.Standings` - Core business logic for teams and league standings
- `ClashOfClansFpl.Fixtures` - Fixture management and results processing
- `ClashOfClansFpl.Managers` - Manager data and statistics
- `ClashOfClansFpl.ClashCSV` - CSV data import/export functionality
- `ClashOfClansFpl.SecondHalf` - Special logic for mid-season league changes
- `ClashOfClansFpl.Scheduler` - Background task scheduling

### Data Model
- Teams have FPL IDs, points, positions, and manager counts
- Fixtures track gameweek results and scores
- Managers have overall points, gameweek ranks, and MVP status
- All entities are season-aware (default season is "25/26")

## Development Commands

### Setup and Dependencies
```bash
mix setup                    # Install dependencies, setup database, build assets
mix deps.get                 # Install dependencies only
mix ecto.setup              # Create database, run migrations, seed data
mix ecto.reset              # Drop and recreate database
```

### Development Server
```bash
mix phx.server              # Start development server on localhost:4000
```

### Database Operations
```bash
mix ecto.create             # Create database
mix ecto.migrate            # Run pending migrations
mix ecto.drop               # Drop database
mix run priv/repo/seeds.exs # Run seed data
```

### Assets
```bash
mix assets.setup            # Install Tailwind and esbuild
mix assets.build            # Build assets for development
mix assets.deploy           # Build and minify assets for production
```

### Testing
```bash
mix test                    # Run all tests (with test database setup)
mix test --only live        # Run only LiveView tests
mix test test/specific_test.exs  # Run specific test file
```

## Data Management

The application heavily relies on CSV data imports stored in `csv_data/` directories organized by date. The main data processing workflow involves:

1. Importing manager data from external FPL APIs
2. Processing fixture results and calculating standings
3. Updating team positions and league tables
4. Generating CSV exports for external analysis

Key functions for data operations (run in `iex -S mix`):
```elixir
# Import managers for a gameweek
Standings.save_gameweek_league_managers(gameweek)

# Import fixtures for a gameweek  
Standings.save_gameweek_fixtures(gameweek)

# Update team positions after data changes
Standings.update_positions()

# Generate CSV exports
ClashOfClansFpl.ClashCSV.generate_csv_with_headers(gameweek)
```

## Routes and LiveViews

- `/` - Main dashboard (ClashTeamLive.Index)
- `/teams` - Team management interface
- `/fixtures` - Fixture management and results
- `/managers` - Manager statistics and data
- `/dev/dashboard` - Phoenix LiveDashboard (development only)

## Season Management

The application is designed to handle multiple FPL seasons. The default season is "25/26" but can be overridden in most functions. Season data is stored across all main entities (teams, fixtures, managers) to maintain historical records.