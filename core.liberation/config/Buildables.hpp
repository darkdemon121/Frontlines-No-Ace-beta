class Buildables {
    class Buildings {
        displayName = "Buildings";
        entries[] = {
            {"FOB HQ", "Land_Cargo_HQ_V1_F", 300, 50},
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
            {"AA", "B_soldier_AA_F", 50, 10, 1}
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
            {"MBT", "B_MBT_01_TUSK_F", 900, 250, 8}
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
            {"AT Static", "B_static_AT_F", 150, 30}
        };
    };
};
