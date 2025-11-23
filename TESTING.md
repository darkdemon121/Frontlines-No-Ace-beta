# Testing the Invasion Liberation Template

Because this mission targets Arma 3, automated CI-style testing is not available in this environment. Use the following manual steps to validate the template in-game:

1. Copy the `core.liberation` folder into your Arma 3 profile missions directory (e.g., `%USERPROFILE%\Documents\Arma 3\missions` on Windows).
2. Launch Arma 3, open the Eden Editor, and load the mission on any terrain.
3. Start the scenario in singleplayer preview:
   - Confirm sectors (towns, military bases, factories, fuel depots, radio towers, roadblocks) spawn with red markers and CSAT defenders.
   - Verify FOB HQ logistics action appears when near the HQ and opens the build menu placeholder.
   - Capture a sector and check that enemy counterattacks and friendly patrols start occurring over time.
   - Take factories and fuel depots, build the matching structures, and watch resources/fuel increment every five minutes.
   - Walk into a town/village marker and interact with the shopkeeper; buy a weapon/vehicle from the tabbed market UI and confirm it spawns beside the stall and deducts from your private balance.
   - Open the "Private Funds" and "Faction Funds" mouse-wheel actions to confirm personal cash and the shared resource/fuel pool display separately and that mission completions/sector captures increase the hourly private income bonus.
   - Ensure side missions (roadblock, patrol, scouting, supply convoy) generate periodically.
   - Open the map and watch the battle overlay refresh every chosen interval: red circles for heavy fighting, yellow for contacts, green for quiet areas, and blue/red front icons.
   - Build a Tactical Map board from the Buildings tab, use the "View Tactical Map" action at a FOB, and confirm friendly groups plus spotted enemies render on the static map.
   - On a map with water access, confirm ports and carrier groups appear as extra sectors with boat/infantry defenders, patrol boats loop along the coast, and amphibious assaults occasionally launch toward contested shores.
   - Confirm the mission uses the default Arma loading placeholder unless you set your own `loadScreen` path in `description.ext`.
4. Host a multiplayer session (LAN is fine) to verify respawn, parameters, and that build-menu actions remain limited to FOBs.

If you encounter script errors, use the Arma 3 diagnostic console or `-showScriptErrors` startup parameter to locate the offending SQF line and report it with reproduction steps.
