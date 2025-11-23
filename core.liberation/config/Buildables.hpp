class Buildables {
    class Buildings {
        displayName = "Buildings";
        entries[] = {
            {"FOB HQ Truck", "B_Truck_01_box_F", 300, 50},
            {"Barracks", "Land_MilOffices_V1_F", 150, 25},
            {"Factory", "Land_Cargo_Tower_V1_F", 250, 75},
            {"Air Control", "Land_Airport_01_controlTower_F", 400, 100},
            {"Fuel Depot", "Land_dp_smallFactory_F", 250, 80},
            {"Prison", "Land_i_Barracks_V1_F", 200, 60},
            {"Friendly Prison", "Land_Barracks_01_grey_F", 200, 60},
            {"Tactical Map Board", "Land_MapBoard_01_Wall_F", 75, 10},
            {"Civilian Housing", "Land_i_House_Big_01_V2_F", 100, 10},
            {"Sandbag Wall", "Land_BagFence_Long_F", 10, 0},
            {"HMG Nest", "Land_BagBunker_Small_F", 50, 10}
        };
    };
    class Infantry {
        displayName = "Infantry";
        requires[] = {"Barracks"};
        entries[] = {
            {"Rifleman", "B_Soldier_F", 25, 0, 1},
            {"Autorifleman", "B_soldier_AR_F", 30, 0, 1},
            {"Grenadier", "B_soldier_GL_F", 30, 0, 1},
            {"Medic", "B_medic_F", 35, 0, 1},
            {"Engineer", "B_engineer_F", 40, 0, 1},
            {"AT", "B_Soldier_LAT_F", 40, 0, 1},
            {"AA", "B_soldier_AA_F", 50, 10, 1},
            {"Squad Leader", "B_Soldier_SL_F", 45, 0, 1},
            {"Marksman", "B_soldier_M_F", 45, 0, 1},
            {"JTAC", "B_recon_JTAC_F", 50, 0, 1},
            {"Sniper", "B_sniper_F", 60, 0, 1}
        };
    };
    class Vehicles {
        displayName = "Vehicles";
        requires[] = {"Factory"};
        entries[] = {
            {"FOB Truck", "B_Truck_01_transport_F", 200, 40, 3, 1},
            {"MRAP (HMG)", "B_MRAP_01_hmg_F", 250, 60, 3},
            {"MRAP (GMG)", "B_MRAP_01_gmg_F", 275, 70, 3},
            {"APC", "B_APC_Wheeled_01_cannon_F", 500, 150, 5},
            {"IFV (Tracked)", "B_APC_Tracked_01_rcws_F", 650, 180, 6},
            {"AA Tank", "B_APC_Tracked_01_AA_F", 700, 200, 7},
            {"MBT", "B_MBT_01_TUSK_F", 900, 250, 8},
            {"Self-Propelled Artillery", "B_MBT_01_arty_F", 950, 300, 10},
            {"MLRS", "B_MBT_01_mlrs_F", 1100, 350, 12}
        };
    };
    class Helicopters {
        displayName = "Helicopters";
        requires[] = {"Air Control", "Airport"};
        entries[] = {
            {"Light Transport", "B_Heli_Light_01_F", 250, 80, 4},
            {"Transport Heli", "B_Heli_Transport_03_F", 400, 150, 5},
            {"Armed Transport", "B_Heli_Transport_01_F", 500, 160, 6},
            {"CAS Heli", "B_Heli_Attack_01_dynamicLoadout_F", 800, 250, 8}
        };
    };
    class Planes {
        displayName = "Planes";
        requires[] = {"Air Control", "Airport"};
        entries[] = {
            {"CAS Jet", "B_Plane_CAS_01_dynamicLoadout_F", 1200, 400, 10},
            {"Fighter", "B_Plane_Fighter_01_F", 1400, 500, 12}
        };
    };
    class Defenses {
        displayName = "Defenses";
        requires[] = {};
        entries[] = {
            {"HMG", "B_HMG_01_F", 75, 10},
            {"GMG", "B_GMG_01_F", 100, 15},
            {"AA Static", "B_static_AA_F", 150, 30},
            {"AT Static", "B_static_AT_F", 150, 30},
            {"Mortar", "B_Mortar_01_F", 220, 40}
        };
    };
    class Fortifications {
        displayName = "Fortifications";
        entries[] = {
            {"Barracks Long", "Land_Barracks_F", 180, 20},
            {"Medevac House", "Land_Medevac_house_V1_F", 140, 15},
            {"Medevac HQ", "Land_Medevac_HQ_V1_F", 160, 20},
            {"Cargo Container 20 (Green)", "Land_Cargo20_military_green_F", 45, 5},
            {"Cargo Container 40 (Green)", "Land_Cargo40_military_green_F", 65, 8},
            {"Cargo Container 20 (Blue)", "Land_Cargo20_blue_F", 45, 5},
            {"Cargo Container 20 (Grey)", "Land_Cargo20_grey_F", 45, 5},
            {"Cargo Container 20 (Light Green)", "Land_Cargo20_light_green_F", 45, 5},
            {"Cargo Box", "Land_CargoBox_V1_F", 25, 0},
            {"Container Line 01", "Land_ContainerLine_01_F", 30, 0},
            {"Container Line 02", "Land_ContainerLine_02_F", 30, 0},
            {"Container Line 03", "Land_ContainerLine_03_F", 30, 0},
            {"High Tower", "Land_HighTower_F", 320, 40},
            {"High Tower (Dark)", "Land_HighTower_noLights_F", 300, 40},
            {"Small Radio Tower 1", "Land_TTowerSmall_1_F", 140, 15},
            {"Small Radio Tower 2", "Land_TTowerSmall_2_F", 140, 15},
            {"Tall Radio Tower", "Land_TTowerBig_1_F", 240, 30},
            {"Large Radio Tower", "Land_TTowerBig_2_F", 260, 30},
            {"Communication Mast", "Land_Communication_F", 200, 25},
            {"Small Radar", "Land_Radar_Small_F", 220, 30},
            {"Radar Dome", "Land_Radar_F", 260, 35},
            {"Bunker Small", "Land_Bunker_01_small_F", 110, 12},
            {"Bunker Large", "Land_Bunker_01_big_F", 180, 20},
            {"Bunker HQ", "Land_Bunker_01_HQ_F", 220, 25},
            {"Bunker Tall", "Land_Bunker_01_tall_F", 230, 25},
            {"Bunker Blocks (1)", "Land_Bunker_01_blocks_1_F", 45, 5},
            {"Bunker Blocks (3)", "Land_Bunker_01_blocks_3_F", 65, 5},
            {"Bunker Blocks (5)", "Land_Bunker_01_blocks_5_F", 85, 6},
            {"Bunker Wall 01", "Land_Bunker_01_wall_01_F", 35, 2},
            {"Bunker Wall 02", "Land_Bunker_01_wall_02_F", 35, 2},
            {"Bunker Wall 03", "Land_Bunker_01_wall_03_F", 35, 2},
            {"H-Barrier 1", "Land_HBarrier_1_F", 15, 0},
            {"H-Barrier 3", "Land_HBarrier_3_F", 18, 0},
            {"H-Barrier 5", "Land_HBarrier_5_F", 20, 0},
            {"H-Barrier Big", "Land_HBarrierBig_F", 30, 0},
            {"H-Barrier Wall 4m", "Land_HBarrierWall4_F", 24, 0},
            {"H-Barrier Wall 6m", "Land_HBarrierWall6_F", 28, 0},
            {"H-Barrier Corridor", "Land_HBarrierWall_corridor_F", 34, 0},
            {"H-Barrier Corner", "Land_HBarrierWall_corner_F", 28, 0},
            {"H-Barrier Tower", "Land_HBarrierTower_F", 80, 8},
            {"Sandbag Long (Green)", "Land_BagFence_01_long_green_F", 10, 0},
            {"Sandbag Short (Green)", "Land_BagFence_01_short_green_F", 8, 0},
            {"Sandbag Round (Green)", "Land_BagFence_01_round_green_F", 10, 0},
            {"Sandbag Corner (Green)", "Land_BagFence_01_corner_green_F", 10, 0},
            {"Sandbag End (Green)", "Land_BagFence_01_end_green_F", 8, 0},
            {"Sandbag Bunker Large", "Land_BagBunker_01_large_green_F", 120, 10},
            {"Sandbag Bunker Tower", "Land_BagBunker_Tower_F", 140, 12},
            {"Medical Tent", "Land_MedicalTent_01_white_generic_open_F", 80, 6},
            {"Hangar Tent", "Land_TentHangar_V1_F", 200, 20},
            {"Dome Tent", "Land_TentDome_F", 60, 6},
            {"Tent A", "Land_TentA_F", 45, 4},
            {"Canvas Cover", "Land_CanvasCover_01_F", 20, 0},
            {"Connector Tent", "Land_ConnectorTent_01_F", 25, 0},
            {"Repair Depot (Tan)", "Land_RepairDepot_01_tan_F", 220, 25},
            {"Repair Depot (Green)", "Land_RepairDepot_01_green_F", 220, 25},
            {"Repair Depot (Black)", "Land_RepairDepot_01_black_F", 220, 25},
            {"Industrial Shed", "Land_i_Shed_Ind_F", 120, 12},
            {"Garage", "Land_i_Garage_V1_F", 90, 10},
            {"Fuel Tank Large", "Land_dp_bigTank_F", 180, 20},
            {"Fuel Tank Small", "Land_dp_smallTank_F", 140, 15},
            {"Concrete Wall 4m", "Land_Mil_WallBig_4m_F", 24, 0},
            {"Concrete Wall 8m", "Land_Mil_WallBig_8m_F", 32, 0},
            {"Concrete Wall Corner", "Land_Mil_WallBig_Corner_F", 28, 0},
            {"Concrete Wall Gate", "Land_Mil_WallBig_Gate_F", 40, 0},
            {"Road Barrier", "Land_RoadBarrier_01_F", 8, 0},
            {"Road Barrier (Low)", "Land_RoadBarrier_02_F", 8, 0},
            {"Road Barrier Small", "Land_RoadBarrier_small_F", 5, 0},
            {"Watchtower V1", "Land_Watchtower_V1_F", 80, 8},
            {"Watchtower V2", "Land_Watchtower_V2_F", 85, 8},
            {"Watchtower V3", "Land_Watchtower_V3_F", 90, 8},
            {"Gun Shelter 01", "Land_GunShelter_01_F", 140, 12},
            {"Gun Shelter 02", "Land_GunShelter_02_F", 150, 12},
            {"Fortified Artillery Nest", "Land_fort_artillery_nest", 160, 18},
            {"Fort Rampart", "Land_fort_rampart_EP1", 140, 12},
            {"Fort Watchtower", "Land_fort_watchtower", 150, 12},
            {"Fort Watchtower (Alt)", "Land_Fort_Watchtower", 150, 12},
            {"Ammo Crates", "Land_AmmoCrates_Boxes_F", 20, 0}
        };
    };
};
