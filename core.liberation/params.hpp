class Params {
    class startingResources {
        title = "Starting Resources";
        values[] = {500, 1000, 2000};
        texts[] = {"500", "1000", "2000"};
        default = 1000;
    };
    class startingFuel {
        title = "Starting Fuel";
        values[] = {100, 250, 500};
        texts[] = {"100", "250", "500"};
        default = 250;
    };
    class friendlyFaction {
        title = "Playable (BLUFOR) Faction";
        values[] = {0, 1, 2, 3, 4, 5, 6};
        texts[] = {
            "NATO (Woodland)",
            "NATO (Pacific)",
            "CTRG (Spec Ops)",
            "RHS US Army (OCP)",
            "RHS USMC (Woodland)",
            "3CB BAF (MTP)",
            "CUP BAF (Woodland)"
        };
        default = 0;
    };
    class enemyFaction {
        title = "Enemy Faction (OPFOR or IND)";
        values[] = {0, 1, 2, 3, 4, 5, 6, 7};
        texts[] = {
            "CSAT (Woodland)",
            "CSAT (Pacific)",
            "AAF", "Syndikat",
            "RHS VDV (EMR)",
            "RHS MSV (Flora)",
            "RHS CDF (Woodland)",
            "RHS ChDKZ (Guerrilla)"
        };
        default = 0;
    };
    class civDensity {
        title = "Civilian Density";
        values[] = {0, 1, 2};
        texts[] = {"None", "Sporadic", "Dense"};
        default = 1;
    };
    class aiAggression {
        title = "Enemy Aggression";
        values[] = {0, 1, 2};
        texts[] = {"Cautious", "Assertive", "Relentless"};
        default = 1;
    };
    class sideMissions {
        title = "Enable Side Missions";
        values[] = {0, 1};
        texts[] = {"Disabled", "Enabled"};
        default = 1;
    };
    class enemyCaptureTime {
        title = "Enemy Sector Capture Time (seconds)";
        values[] = {300, 600, 900, 1200};
        texts[] = {"5 minutes", "10 minutes", "15 minutes", "20 minutes"};
        default = 600;
    };
    class aiPopulationScale {
        title = "Overall AI Presence";
        values[] = {50, 75, 100, 150, 200, 300, 500};
        texts[] = {"50%", "75%", "100%", "150%", "200%", "300%", "500%"};
        default = 100;
    };
    class battleOverlayInterval {
        title = "Battle Overlay Refresh (seconds)";
        values[] = {10, 20, 30, 60};
        texts[] = {"10", "20", "30", "60"};
        default = 30;
    };
};
