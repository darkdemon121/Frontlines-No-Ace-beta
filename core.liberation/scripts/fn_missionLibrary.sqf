// Returns all mission definitions grouped by category
private _defs = [];

private _add = {
    params ["_id", "_title", "_category", "_type", "_description", ["_extra", createHashMap]];
    private _base = createHashMapFromArray [
        ["id", _id],
        ["title", _title],
        ["category", _category],
        ["type", _type],
        ["description", _description]
    ];
    {
        _base set [_x select 0, _x select 1];
    } forEach _extra;
    _defs pushBack _base;
};

// SABOTAGE
[ "sabotage_radar", "Destroy Enemy Radar", "SABOTAGE MISSIONS", "destroy", "Destroy the radar node limiting enemy AA bonuses.", [["objects", ["Land_Radar_Small_F"]], ["guards", 10], ["sabotage", true], ["payout", 900]]] call _add;
[ "sabotage_fuel", "Sabotage Fuel Depot", "SABOTAGE MISSIONS", "destroy", "Plant charges on enemy fuel tanks to halt patrols.", [["objects", ["Land_FuelStation_Feed_F", "Land_ReservoirTank_A_Industrial_F"]], ["guards", 8], ["sabotage", true], ["payout", 800]]] call _add;
[ "sabotage_power", "Disable Power Station", "SABOTAGE MISSIONS", "destroy", "Shut down the power plant to blind nearby bases.", [["objects", ["Land_PowerStation_01_F"]], ["guards", 8], ["sabotage", true], ["payout", 750]]] call _add;
[ "sabotage_artillery", "Destroy Artillery Battery", "SABOTAGE MISSIONS", "destroy", "Neutralize SPGs or mortars shelling FOBs.", [["objects", ["O_Mortar_01_F", "O_Mortar_01_F", "O_Mortar_01_F"]], ["guards", 8], ["sabotage", true], ["payout", 950]]] call _add;
[ "sabotage_bridge", "Blow Up Bridge", "SABOTAGE MISSIONS", "destroy", "Collapse a key bridge to reroute traffic.", [["objects", ["Land_Bridge_Asphalt_F"]], ["guards", 6], ["sabotage", true], ["payout", 700]]] call _add;
[ "repair_bridge", "Repair Bridge", "SABOTAGE MISSIONS", "defend", "Secure and rebuild a destroyed bridge for friendlies.", [["objects", ["Land_Pier_F"]], ["guards", 4], ["duration", 300], ["sabotage", false], ["payout", 650]]] call _add;
[ "sabotage_ammo", "Infiltrate Ammo Dump", "SABOTAGE MISSIONS", "destroy", "Plant charges on ammo crates without triggering alarms.", [["objects", ["Box_East_AmmoVeh_F", "Box_East_Ammo_F"]], ["guards", 8], ["sabotage", true], ["payout", 800]]] call _add;
[ "sabotage_airfield_fuel", "Sabotage Airfield Fuel Pumps", "SABOTAGE MISSIONS", "destroy", "Disable pumps to ground enemy aircraft.", [["objects", ["Land_fs_feed_F", "Land_fs_feed_F"]], ["guards", 10], ["sabotage", true], ["payout", 900]]] call _add;
[ "sabotage_command_vehicle", "Disable Command Vehicle", "SABOTAGE MISSIONS", "destroy", "Destroy or capture the mobile HQ vehicle.", [["objects", ["O_T_LSV_02_armed_F"]], ["guards", 6], ["sabotage", true], ["payout", 850]]] call _add;

// INTELLIGENCE
[ "intel_laptop", "Recover Laptop or Hard Drive", "INTELLIGENCE OPERATIONS", "intel", "Recover data from an officer tent and exfiltrate it.", [["objects", ["Land_Laptop_device_F"]], ["guards", 6], ["payout", 700]]] call _add;
[ "intel_wiretap", "Intercept Enemy Communications", "INTELLIGENCE OPERATIONS", "intel", "Install a wiretap on an enemy radio tower.", [["objects", ["Land_TTowerBig_2_F"]], ["guards", 6], ["payout", 650]]] call _add;
[ "intel_hack", "Hack Enemy Computer Node", "INTELLIGENCE OPERATIONS", "intel", "Upload a virus to scramble enemy map intel.", [["objects", ["Land_DataTerminal_01_F"]], ["guards", 6], ["payout", 650]]] call _add;
[ "intel_body", "Search Dead Officer for Intel", "INTELLIGENCE OPERATIONS", "patrol", "Eliminate or find an officer carrying documents.", [["guards", 5], ["payout", 550]]] call _add;
[ "intel_spy", "Capture Enemy Spy", "INTELLIGENCE OPERATIONS", "escort", "Detain an enemy recon agent operating in friendly lines.", [["objects", ["O_G_Survivor_F"]], ["guards", 4], ["payout", 600]]] call _add;
[ "intel_photo", "Photo Recon", "INTELLIGENCE OPERATIONS", "intel", "Take photos of enemy base construction and submit evidence.", [["objects", ["Land_CampingTable_small_F"]], ["guards", 4], ["payout", 600]]] call _add;
[ "intel_drone", "Drone Recon Mission", "INTELLIGENCE OPERATIONS", "patrol", "Deploy a UAV to scan marked areas for troops.", [["guards", 4], ["payout", 550]]] call _add;

// SPECIAL OPS
[ "specops_hvt_kill", "Assassinate HVT", "SPECIAL OPERATIONS", "destroy", "Kill the enemy general touring a guarded facility.", [["objects", ["O_officer_F"]], ["guards", 10], ["payout", 1000]]] call _add;
[ "specops_hvt_capture", "Capture HVT Alive", "SPECIAL OPERATIONS", "escort", "Capture and extract a hostile VIP alive.", [["objects", ["O_Officer_F"]], ["guards", 10], ["payout", 1100]]] call _add;
[ "specops_sniper", "Neutralize Enemy Sniper Team", "SPECIAL OPERATIONS", "patrol", "Hunt down a sniper duo harassing the line.", [["guards", 4], ["payout", 700]]] call _add;
[ "specops_prototype", "Destroy Prototype Weapon", "SPECIAL OPERATIONS", "destroy", "Sabotage an experimental tank or AA system.", [["objects", ["O_MBT_04_cannon_F"]], ["guards", 8], ["payout", 1200]]] call _add;
[ "specops_heli_pad", "Sabotage Helicopter on Pad", "SPECIAL OPERATIONS", "destroy", "Plant charges on a parked helicopter quietly.", [["objects", ["O_Heli_Attack_02_black_F"]], ["guards", 6], ["payout", 900]]] call _add;

// RESCUE
[ "rescue_pilot", "Pilot Rescue", "RESCUE / EXTRACTION", "escort", "Recover downed pilots hiding from patrols.", [["objects", ["B_helicrew_F"]], ["guards", 4], ["payout", 750]]] call _add;
[ "rescue_extraction", "Extraction Under Fire", "RESCUE / EXTRACTION", "escort", "Escort a pinned squad to an LZ.", [["objects", ["B_Soldier_F"]], ["guards", 6], ["payout", 850]]] call _add;
[ "rescue_hostage", "Hostage Rescue", "RESCUE / EXTRACTION", "escort", "Rescue civilians or diplomats from captivity.", [["objects", ["C_scientist_F"]], ["guards", 8], ["payout", 900]]] call _add;
[ "rescue_vip_escort", "VIP Escort", "RESCUE / EXTRACTION", "escort", "Retrieve and escort a scientist or official.", [["objects", ["C_man_pilot_F"]], ["guards", 6], ["payout", 800]]] call _add;
[ "rescue_pow", "POW Liberation", "RESCUE / EXTRACTION", "escort", "Free captured soldiers and return them to FOB.", [["objects", ["B_Soldier_unarmed_F"]], ["guards", 8], ["payout", 950]]] call _add;
[ "rescue_drone", "Downed Drone Retrieval", "RESCUE / EXTRACTION", "intel", "Recover sensitive drone wreckage.", [["objects", ["Land_UAV_06_F"]], ["guards", 4], ["payout", 650]]] call _add;
[ "rescue_pow_exchange", "POW Exchange", "RESCUE / EXTRACTION", "escort", "Perform a hostage-for-prisoner swap.", [["objects", ["C_Man_casual_4_F"]], ["guards", 6], ["payout", 900]]] call _add;

// LOGISTICS
[ "logi_convoy_def", "Convoy Defense", "LOGISTICS & SUPPLY MISSIONS", "defend", "Protect a friendly convoy along its route.", [["objects", ["B_Truck_01_transport_F"]], ["guards", 6], ["duration", 480], ["payout", 850]]] call _add;
[ "logi_destroy_convoy", "Destroy Enemy Supply Convoy", "LOGISTICS & SUPPLY MISSIONS", "destroy", "Ambush enemy ammo or fuel trucks.", [["objects", ["O_Truck_03_fuel_F", "O_Truck_03_ammo_F"]], ["guards", 6], ["payout", 850]]] call _add;
[ "logi_steal_fuel", "Steal Enemy Fuel Truck", "LOGISTICS & SUPPLY MISSIONS", "escort", "Capture a fuel truck and drive it home.", [["objects", ["O_Truck_03_fuel_F"]], ["guards", 6], ["payout", 800]]] call _add;
[ "logi_repair_tower", "Repair Communications Tower", "LOGISTICS & SUPPLY MISSIONS", "defend", "Bring engineer supplies to fix a tower.", [["objects", ["Land_TTowerBig_1_F"]], ["guards", 4], ["duration", 360], ["payout", 700]]] call _add;
[ "logi_medical_evax", "Medical Evacuation", "LOGISTICS & SUPPLY MISSIONS", "escort", "Evacuate wounded from the battlefield.", [["objects", ["C_man_w_worker_F"]], ["guards", 4], ["payout", 650]]] call _add;
[ "logi_supply_drop", "Capture Supply Drop", "LOGISTICS & SUPPLY MISSIONS", "defend", "Secure an enemy supply crate.", [["objects", ["B_supplyCrate_F"]], ["guards", 6], ["duration", 300], ["payout", 750]]] call _add;

// RECON
[ "recon_lrrp", "Long Range Recon Patrol", "RECONNAISSANCE & PATROL MISSIONS", "patrol", "Scout multiple objective areas for enemy presence.", [["guards", 6], ["payout", 700]]] call _add;
[ "recon_patrol_zone", "Patrol Zone to Secure It", "RECONNAISSANCE & PATROL MISSIONS", "patrol", "Clear an area of roaming patrols.", [["guards", 6], ["payout", 650]]] call _add;
[ "recon_abandoned", "Check Abandoned Village", "RECONNAISSANCE & PATROL MISSIONS", "patrol", "Investigate an abandoned hamlet for threats.", [["guards", 5], ["payout", 550]]] call _add;
[ "recon_map_aa", "Map Enemy AA Positions", "RECONNAISSANCE & PATROL MISSIONS", "intel", "Mark hostile AA emplacements.", [["objects", ["O_static_AA_F"]], ["guards", 6], ["payout", 750]]] call _add;
[ "recon_mark_armor", "Mark Enemy Armor Movement", "RECONNAISSANCE & PATROL MISSIONS", "patrol", "Shadow hostile armor along roads.", [["guards", 6], ["payout", 700]]] call _add;
[ "recon_war_crime", "Observe Enemy War Crime", "RECONNAISSANCE & PATROL MISSIONS", "intel", "Document evidence of civilian executions.", [["objects", ["Land_Cargo_Patrol_V1_F"]], ["guards", 6], ["payout", 650]]] call _add;

// MINES
[ "mine_clear", "Clear Minefield", "MINEFIELD & ENGINEER MISSIONS", "destroy", "Defuse or clear mines blocking a road.", [["objects", ["Land_Sign_Mines_F"]], ["guards", 4], ["payout", 700]]] call _add;
[ "mine_factory", "Destroy IED Factory", "MINEFIELD & ENGINEER MISSIONS", "destroy", "Destroy the bomb-making workshop.", [["objects", ["Land_Slum_House01_F"]], ["guards", 8], ["payout", 950]]] call _add;
[ "mine_roadside", "Disarm Roadside IEDs", "MINEFIELD & ENGINEER MISSIONS", "destroy", "Sweep and disarm roadside devices.", [["objects", ["IEDUrbanSmall_F", "IEDLandBig_F"]], ["guards", 6], ["payout", 750]]] call _add;
[ "mine_bridge_build", "Bridge Construction", "MINEFIELD & ENGINEER MISSIONS", "defend", "Emplace a portable bridge for armor.", [["objects", ["Land_Pier_wall_F"]], ["guards", 4], ["duration", 360], ["payout", 700]]] call _add;

// ENEMY REACTION
[ "reaction_counter_patrol", "Counter-Invasion Patrol", "ENEMY MOVEMENT / REACTION MISSIONS", "patrol", "Stop an enemy push into friendly lines.", [["guards", 8], ["payout", 850]]] call _add;
[ "reaction_heli", "Intercept Reinforcement Helicopters", "ENEMY MOVEMENT / REACTION MISSIONS", "destroy", "Shoot down reinforcement helis en route.", [["objects", ["O_Heli_Light_02_F"]], ["guards", 6], ["payout", 900]]] call _add;
[ "reaction_armor", "Stop Armor Reinforcements", "ENEMY MOVEMENT / REACTION MISSIONS", "destroy", "Eliminate tanks moving to a contested city.", [["objects", ["O_MBT_02_cannon_F", "O_APC_Tracked_02_cannon_F"]], ["guards", 8], ["payout", 1000]]] call _add;
[ "reaction_eliminate_patrol", "Eliminate Enemy Patrol", "ENEMY MOVEMENT / REACTION MISSIONS", "patrol", "Destroy a patrolling fireteam.", [["guards", 6], ["payout", 650]]] call _add;

// URBAN OPS
[ "urban_gov", "Secure Government Building", "URBAN OPERATIONS", "defend", "Capture city hall being used as HQ.", [["objects", ["Land_City_8m_F"]], ["guards", 10], ["duration", 420], ["payout", 950]]] call _add;
[ "urban_checkpoint", "Eliminate Enemy Checkpoint", "URBAN OPERATIONS", "destroy", "Destroy a fortified checkpoint.", [["objects", ["Land_BagBunker_Small_F"]], ["guards", 8], ["payout", 800]]] call _add;
[ "urban_apartments", "Clear Apartment Complex", "URBAN OPERATIONS", "patrol", "Clear multi-story apartment blocks.", [["guards", 10], ["payout", 900]]] call _add;
[ "urban_rescue_civ", "Rescue Civilians in Collapsed Building", "URBAN OPERATIONS", "escort", "Recover civilians trapped in ruins.", [["objects", ["C_man_p_fugitive_F"]], ["guards", 6], ["payout", 750]]] call _add;

// DEFENSIVE
[ "defense_hold_line", "Hold the Line", "DEFENSIVE MISSIONS", "defend", "Defend a friendly town from counterattack.", [["objects", ["Land_HBarrier_Big_F"]], ["guards", 10], ["duration", 480], ["payout", 1000]]] call _add;
[ "defense_fob", "FOB Defense", "DEFENSIVE MISSIONS", "defend", "Repel waves attacking a FOB.", [["objects", ["Land_Cargo_HQ_V1_F"]], ["guards", 12], ["duration", 480], ["payout", 1100]]] call _add;
[ "defense_radar", "Radar Defense", "DEFENSIVE MISSIONS", "defend", "Protect the radar site from strikes.", [["objects", ["Land_Radar_Small_F"]], ["guards", 10], ["duration", 420], ["payout", 950]]] call _add;
[ "defense_aa", "Protect AA Installation", "DEFENSIVE MISSIONS", "defend", "Secure AA positions against air strikes.", [["objects", ["B_static_AA_F"]], ["guards", 10], ["duration", 420], ["payout", 950]]] call _add;

// AIR
[ "air_sead", "Suppress Enemy Air Defense", "AIR MISSIONS", "destroy", "Take out AA batteries limiting CAS.", [["objects", ["O_static_AA_F", "O_static_AA_F"]], ["guards", 8], ["payout", 1100]]] call _add;
[ "air_intercept", "Air Intercept", "AIR MISSIONS", "destroy", "Intercept enemy CAS or drones.", [["objects", ["O_UAV_02_F"]], ["guards", 6], ["payout", 900]]] call _add;
[ "air_insert_extract", "Insertion + Extraction", "AIR MISSIONS", "escort", "Insert a recon team then extract them later.", [["objects", ["B_recon_F"]], ["guards", 6], ["payout", 850]]] call _add;
[ "air_airdrop", "Airdrop Supplies", "AIR MISSIONS", "defend", "Airdrop ammo to friendly troops and secure it.", [["objects", ["Box_NATO_AmmoVeh_F"]], ["guards", 4], ["duration", 300], ["payout", 750]]] call _add;

// COVERT
[ "covert_undercover", "Undercover Spy Mission", "COVERT OPERATIONS", "intel", "Blend with civilians to gather data.", [["objects", ["C_Man_casual_6_F"]], ["guards", 4], ["payout", 700]]] call _add;
[ "covert_tracker", "Plant Tracker on Enemy Vehicle", "COVERT OPERATIONS", "intel", "Attach a beacon to a patrolling tank.", [["objects", ["O_MBT_02_cannon_F"]], ["guards", 6], ["payout", 800]]] call _add;
[ "covert_bug_meeting", "Bug a Meeting House", "COVERT OPERATIONS", "intel", "Bug the meeting site used by officers.", [["objects", ["Land_i_House_Big_02_V1_F"]], ["guards", 6], ["payout", 750]]] call _add;

// HEAVY COMBAT
[ "heavy_tank_hunt", "Tank Hunter Mission", "HEAVY COMBAT MISSIONS", "destroy", "Destroy an armored platoon.", [["objects", ["O_MBT_02_cannon_F", "O_APC_Tracked_02_cannon_F"]], ["guards", 12], ["payout", 1200]]] call _add;
[ "heavy_mech", "Mechanized Assault", "HEAVY COMBAT MISSIONS", "patrol", "Clear a town held by mechanized infantry.", [["guards", 12], ["payout", 1150]]] call _add;
[ "heavy_fort", "Fortification Assault", "HEAVY COMBAT MISSIONS", "destroy", "Capture a bunker complex bristling with statics.", [["objects", ["Land_BagBunker_Tower_F"]], ["guards", 12], ["payout", 1200]]] call _add;
[ "heavy_mobile_aa", "Destroy Mobile AA Convoy", "HEAVY COMBAT MISSIONS", "destroy", "Take out hardened AA vehicles with escorts.", [["objects", ["O_APC_Tracked_02_AA_F", "O_APC_Tracked_02_cannon_F"]], ["guards", 10], ["payout", 1250]]] call _add;

// GAMEPLAY SYSTEMS
[ "gameplay_fob", "FOB Construction Mission", "GAMEPLAY SYSTEM MISSIONS", "defend", "Secure ground to build a new FOB.", [["objects", ["Land_Cargo_Patrol_V1_F"]], ["guards", 6], ["duration", 420], ["payout", 850]]] call _add;
[ "gameplay_resource", "Resource Capture Mission", "GAMEPLAY SYSTEM MISSIONS", "defend", "Capture an oil field or refinery.", [["objects", ["Land_ReservoirTank_A_Industrial_F"]], ["guards", 8], ["duration", 420], ["payout", 900]]] call _add;
[ "gameplay_recruit", "Recruit Resistance Fighters", "GAMEPLAY SYSTEM MISSIONS", "escort", "Meet local militia and recruit them.", [["objects", ["I_G_Survivor_F"]], ["guards", 4], ["payout", 650]]] call _add;
[ "gameplay_infection", "Infection/Extraction Scenario", "GAMEPLAY SYSTEM MISSIONS", "defend", "Recover secret crates and defend the site.", [["objects", ["CargoNet_01_box_F"]], ["guards", 10], ["duration", 480], ["payout", 1100]]] call _add;

// CHAOS / EMERGENT
[ "chaos_counterstrike", "Random Enemy Counterstrike", "CHAOS/EMERGENT MISSIONS", "defend", "Repel a spontaneous counterattack.", [["objects", ["Land_HBarrierTower_F"]], ["guards", 10], ["duration", 420], ["payout", 1000]]] call _add;
[ "chaos_crash", "High-Value Crash Site", "CHAOS/EMERGENT MISSIONS", "defend", "Secure a crash site before the enemy does.", [["objects", ["Land_Wreck_Heli_Attack_02_F"]], ["guards", 8], ["duration", 360], ["payout", 850]]] call _add;
[ "chaos_vip_ambush", "VIP Ambush", "CHAOS/EMERGENT MISSIONS", "escort", "Protect the commander from an assassination attempt.", [["objects", ["B_officer_F"]], ["guards", 8], ["payout", 900]]] call _add;

missionNamespace setVariable ["front_missionDefinitions", _defs];
publicVariable "front_missionDefinitions";
_defs
