# Frontlines Liberation Template

This folder contains a dynamic Liberation-style sandbox that can be dropped onto any terrain. On mission start the scripts scan the map to seed sectors (towns, military sites, roadblocks, factories, fuel depots, and radio towers) and fill them with the faction chosen in the lobby parameters. The build menu, economy, and AI commanders are data driven so you can adapt them for different factions via the `mod_template` folder or the ready-made presets in `factions/` (organized by side for mission parameters) that mirror the LRX template set: vanilla NATO/CSAT/AAF/Syndikat, CTRG, RHS US Army/USMC/VDV/MSV/CDF/ChDKZ, 3CB BAF, and CUP BAF.

## Key Features
- **Dynamic sector generation:** uses `fn_initWorld` and `fn_generateSectors` to find city, military, industrial, and road objectives automatically.
- **Defended objectives:** `fn_setupDefenses` pulls unit lists from faction templates to garrison each site with infantry, vehicles, and occasional air cover.
- **Side missions:** `fn_sideMissions` now seeds a 73-mission catalog (sabotage, intel, recon, logistics, covert, heavy combat,
  defensive, air, and chaos events) that can auto-rotate or be started manually from the FOB mission board tabs.
- **Mission board & POWs:** `fn_spawnLogisticsMenu` also exposes a Mission Board dialog at FOBs with category tabs, while `fn_prisoners`
  lets players detain surrendered enemies and stash them in a buildable Prison for exchanges; friendly/offending squads and players
  are instead escorted to a Friendly Prison and released via its action menu after paying the resource cost.
- **Logistics & build menu:** `fn_spawnLogisticsMenu` and `config/Buildables.hpp` define FOB-only build tabs (buildings, infantry, vehicles, helicopters, planes, defenses) with unlock conditions (airfield ownership, barracks, factory, air control). Additional infantry (engineers/AA), armor (IFV/MBT/AA), turrets, and fast movers are available for purchase to match the larger faction pools. The logistics menu spends faction resources/fuel/manpower, while the town shop is strictly for personal-cash gear and civilian vehicle buys so infantry creation stays in the FOB build flow.
- **Economy & civilians:** `fn_economyLoop` ties resource/fuel income to captured factories/fuel depots and to housed civilians that also raise manpower for recruitment.
- **Private cash & markets:** `fn_shops`, `config/ShopCatalog.hpp`, and `fn_shopMenu` create marked shopkeepers in civilian towns with weapon/gear/vehicle/supply tabs that charge player-specific dollars. `fn_privateEconomy` tracks each player's balance plus an hourly income bonus that grows as missions complete and sectors fall; hints on the mouse-wheel show both personal cash and the faction resource/fuel totals.
- **Ambient fronts:** `fn_aiCommander` dispatches enemy counterattacks and friendly auto-attacks from FOBs to keep the map active.
- **Battle overlay & intel board:** `fn_battleOverlay` paints live hotspots (red/yellow/green) plus BLUFOR/OPFOR front markers on the map at a configurable interval, while a buildable Tactical Map board at FOBs (`fn_intelMap` via a Map Board action) shows friendly groups and spotted enemies for planning without leaving the base.
- **Role selection:** `config/PlayableRoles.hpp` now exposes a 30-player roster organized as platoon HQ, Alpha/Bravo/Charlie assault squads, weapons, recon, armor, and aviation so multiplayer teams can fill invasion-style billets with matching loadouts.
- **Persistence:** `fn_persistenceLoad`/`fn_persistenceSave` read and write game state to the server profile and `fn_persistenceAutoSave` keeps progress every 15 minutes so sectors, resources, and FOBs survive restarts.
- **Faction parameters:** Lobby parameters select the playable BLUFOR faction and the opposing OPFOR/IND faction, pulling unit and static pools from `factions/` before persistence restores long-term progress. The selector lists every bundled LRX-style preset and gracefully falls back to NATO/CSAT if mod classnames are missing.

## Files
- `description.ext` / `params.hpp`: mission configuration and lobby parameters.
- `init.sqf` / `mission.sqf`: bootstrap that calls the function pipeline.
- `scripts/`: mission logic (world scan, sectors, defenses, logistics, economy, AI, side missions, mission board, POW handling).
- `config/`: helper configs such as `Buildables.hpp` and function registration.
- `factions/`: simple SQF presets grouped by side for the lobby faction selectors.
- `mod_template/`: faction presets mirroring Liberation RX style (NATO, CSAT, AAF) to copy/extend.
