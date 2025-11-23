class CfgRoles {
    class roleCommand { displayName = "Command"; };
    class roleInfantry { displayName = "Infantry"; };
    class roleAlpha { displayName = "Alpha Assault"; };
    class roleBravo { displayName = "Bravo Assault"; };
    class roleCharlie { displayName = "Charlie Assault"; };
    class roleWeapons { displayName = "Weapons"; };
    class roleRecon { displayName = "Recon"; };
    class roleArmor { displayName = "Armor"; };
    class roleAviation { displayName = "Aviation"; };
    class roleSupport { displayName = "Support"; };
    class roleLogistics { displayName = "Logistics"; };
};

class CfgRespawnInventory {
    class front_rifleman {
        displayName = "Rifleman";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\private_gs.paa";
        role = "roleInfantry";
        uniformClass = "U_B_CombatUniform_mcam";
        backpack = "B_AssaultPack_mcamo";
        weapons[] = {"arifle_MX_F","hgun_P07_F","Binocular","Throw","Put"};
        magazines[] = {
            "30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag",
            "16Rnd_9x21_Mag","16Rnd_9x21_Mag","HandGrenade","HandGrenade","SmokeShell","SmokeShell"
        };
        items[] = {"FirstAidKit","FirstAidKit"};
        linkedItems[] = {"V_PlateCarrier1_rgr","H_HelmetB","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles"};
    };

    class front_grenadier : front_rifleman {
        displayName = "Grenadier";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\corporal_gs.paa";
        weapons[] = {"arifle_MX_GL_F","hgun_P07_F","Binocular","Throw","Put"};
        magazines[] = {
            "30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag",
            "16Rnd_9x21_Mag","16Rnd_9x21_Mag","HandGrenade","HandGrenade","SmokeShell","SmokeShell",
            "3Rnd_HE_Grenade_shell","3Rnd_HE_Grenade_shell","3Rnd_HE_Grenade_shell",
            "3Rnd_Smoke_Grenade_shell","3Rnd_Smoke_Grenade_shell"
        };
    };

    class front_autorifleman : front_rifleman {
        displayName = "Automatic Rifleman";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\corporal_gs.paa";
        weapons[] = {"arifle_MX_SW_F","hgun_P07_F","Binocular","Throw","Put"};
        magazines[] = {
            "100Rnd_65x39_caseless_mag","100Rnd_65x39_caseless_mag","100Rnd_65x39_caseless_mag","100Rnd_65x39_caseless_mag",
            "16Rnd_9x21_Mag","HandGrenade","HandGrenade","SmokeShell"
        };
        linkedItems[] = {"V_PlateCarrierGL_rgr","H_HelmetB_light","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles"};
    };

    class front_machinegunner : front_autorifleman {
        displayName = "Machine Gunner";
        backpack = "B_Kitbag_rgr";
        magazines[] = {
            "150Rnd_93x64_Mag","150Rnd_93x64_Mag","150Rnd_93x64_Mag","16Rnd_9x21_Mag",
            "HandGrenade","SmokeShell","SmokeShell"
        };
        weapons[] = {"LMG_Mk200_F","hgun_P07_F","Binocular","Throw","Put"};
    };

    class front_marksman : front_rifleman {
        displayName = "Marksman";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\sergeant_gs.paa";
        weapons[] = {"srifle_DMR_03_F","hgun_P07_F","Rangefinder","Throw","Put"};
        magazines[] = {
            "20Rnd_762x51_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag","20Rnd_762x51_Mag",
            "16Rnd_9x21_Mag","HandGrenade","SmokeShell","SmokeShell"
        };
        linkedItems[] = {
            "V_PlateCarrier1_rgr","H_Booniehat_mcamo","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles","optic_SOS"
        };
    };

    class front_rifleman_at : front_rifleman {
        displayName = "AT Specialist";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\corporal_gs.paa";
        backpack = "B_Carryall_mcamo";
        weapons[] = {"arifle_MX_F","launch_NLAW_F","hgun_P07_F","Binocular","Throw","Put"};
        magazines[] = {
            "NLAW_F","NLAW_F",
            "30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag",
            "16Rnd_9x21_Mag","SmokeShell","SmokeShell","HandGrenade"
        };
    };

    class front_ammo_bearer : front_rifleman {
        displayName = "Ammo Bearer";
        backpack = "B_Carryall_mcamo";
        magazines[] = {
            "30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag",
            "100Rnd_65x39_caseless_mag","100Rnd_65x39_caseless_mag","100Rnd_65x39_caseless_mag",
            "16Rnd_9x21_Mag","16Rnd_9x21_Mag","SmokeShell","SmokeShell","HandGrenade","HandGrenade"
        };
    };

    class front_medic : front_rifleman {
        displayName = "Combat Medic";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\private_gs.paa";
        role = "roleSupport";
        backpack = "B_AssaultPack_rgr_Medic";
        weapons[] = {"arifle_MXC_F","hgun_P07_F","Binocular","Throw","Put"};
        magazines[] = {
            "30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag",
            "16Rnd_9x21_Mag","SmokeShell","SmokeShell","SmokeShell","SmokeShell"
        };
        items[] = {"Medikit","FirstAidKit","FirstAidKit","FirstAidKit"};
        linkedItems[] = {"V_PlateCarrierSpec_rgr","H_HelmetSpecB","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles"};
    };

    class front_engineer : front_rifleman {
        displayName = "Engineer";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\private_gs.paa";
        role = "roleSupport";
        backpack = "B_Carryall_mcamo_Eng";
        weapons[] = {"arifle_MX_F","hgun_P07_F","MineDetector","Binocular","Throw","Put"};
        magazines[] = {
            "30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag",
            "16Rnd_9x21_Mag","HandGrenade","HandGrenade","APERSBoundingMine_Range_Mag","DemoCharge_Remote_Mag","SmokeShell"
        };
        items[] = {"ToolKit","FirstAidKit"};
        linkedItems[] = {"V_PlateCarrier1_rgr","H_HelmetB_sand","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles"};
    };

    class front_eod : front_rifleman {
        displayName = "EOD";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\private_gs.paa";
        role = "roleSupport";
        backpack = "B_Carryall_mcamo";
        weapons[] = {"arifle_MX_F","hgun_P07_F","MineDetector","Binocular","Throw","Put"};
        magazines[] = {
            "30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag",
            "16Rnd_9x21_Mag","SmokeShell","SmokeShell","DemoCharge_Remote_Mag","DemoCharge_Remote_Mag"
        };
        items[] = {"FirstAidKit","FirstAidKit","ToolKit"};
        linkedItems[] = {"V_EOD_coyote_F","H_HelmetB","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles"};
    };

    class front_squadlead : front_rifleman {
        displayName = "Squad Leader";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\sergeant_gs.paa";
        role = "roleCommand";
        weapons[] = {"arifle_MX_GL_F","hgun_P07_F","Rangefinder","Throw","Put"};
        magazines[] = {
            "30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag",
            "1Rnd_HE_Grenade_shell","1Rnd_HE_Grenade_shell","1Rnd_Smoke_Grenade_shell","1Rnd_Smoke_Grenade_shell",
            "16Rnd_9x21_Mag","SmokeShell","SmokeShell"
        };
        linkedItems[] = {
            "V_PlateCarrierGL_rgr","H_HelmetSpecB_paint2","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles",
            "acc_pointer_IR","optic_Hamr"
        };
    };

    class front_teamlead : front_squadlead {
        displayName = "Team Leader";
    };

    class front_jtac : front_rifleman {
        displayName = "JTAC";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\sergeant_gs.paa";
        role = "roleCommand";
        backpack = "B_Kitbag_mcamo";
        weapons[] = {"arifle_MX_F","hgun_P07_F","Laserdesignator","Binocular","Throw","Put"};
        magazines[] = {
            "30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag","30Rnd_65x39_caseless_mag",
            "16Rnd_9x21_Mag","SmokeShell","SmokeShell","Laserbatteries"
        };
        linkedItems[] = {
            "V_PlateCarrier2_rgr","H_HelmetB_light_grass","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles",
            "acc_pointer_IR","optic_MRCO"
        };
    };

    class front_pilot {
        displayName = "Pilot";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\lieutenant_gs.paa";
        role = "roleAviation";
        uniformClass = "U_B_HeliPilotCoveralls";
        backpack = "B_Parachute";
        weapons[] = {"SMG_01_F","hgun_P07_F","Throw","Put"};
        magazines[] = {
            "30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01",
            "16Rnd_9x21_Mag","SmokeShell","SmokeShellGreen","SmokeShellOrange"
        };
        items[] = {"FirstAidKit"};
        linkedItems[] = {"V_TacVest_oli","H_PilotHelmetHeli_B","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles"};
    };

    class front_cas_pilot : front_pilot {
        displayName = "CAS Pilot";
    };

    class front_transport_pilot : front_pilot {
        displayName = "Transport Pilot";
    };

    class front_crew : front_pilot {
        displayName = "Crewman";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\sergeant_gs.paa";
        role = "roleLogistics";
        uniformClass = "U_B_CombatUniform_mcam_vest";
        backpack = "B_AssaultPack_mcamo";
        weapons[] = {"SMG_01_F","hgun_P07_F","Throw","Put"};
        magazines[] = {"30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01","30Rnd_45ACP_Mag_SMG_01","16Rnd_9x21_Mag","SmokeShell","SmokeShell","SmokeShell"};
        linkedItems[] = {"V_BandollierB_rgr","H_HelmetCrew_B","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles"};
    };

    class front_crew_chief : front_crew {
        displayName = "Crew Chief";
        items[] = {"ToolKit","FirstAidKit"};
    };

    class front_tank_commander : front_crew {
        displayName = "Tank Commander";
        role = "roleArmor";
        linkedItems[] = {"V_PlateCarrier1_rgr","H_HelmetCrew_B","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles"};
    };

    class front_tank_gunner : front_crew {
        displayName = "Tank Gunner";
        role = "roleArmor";
    };

    class front_tank_driver : front_crew {
        displayName = "Tank Driver";
        role = "roleArmor";
        items[] = {"ToolKit","FirstAidKit"};
    };

    class front_logistics : front_rifleman {
        displayName = "Logistics Specialist";
        role = "roleLogistics";
        backpack = "B_Carryall_mcamo";
        items[] = {"ToolKit","FirstAidKit","FirstAidKit"};
        linkedItems[] = {"V_PlateCarrierGL_rgr","H_HelmetB_light","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles"};
    };

    class front_platoon_leader : front_squadlead {
        displayName = "Platoon Leader";
        role = "roleCommand";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\captain_gs.paa";
    };

    class front_platoon_sergeant : front_squadlead {
        displayName = "Platoon Sergeant";
        role = "roleCommand";
        icon = "\\A3\\ui_f\\data\\GUI\\Cfg\\Ranks\\lieutenant_gs.paa";
    };

    // Alpha squad
    class front_alpha_squadlead : front_squadlead { displayName = "Alpha Squad Leader"; role = "roleAlpha"; };
    class front_alpha_grenadier : front_grenadier { displayName = "Alpha Grenadier"; role = "roleAlpha"; };
    class front_alpha_autorifleman : front_autorifleman { displayName = "Alpha Automatic Rifleman"; role = "roleAlpha"; };
    class front_alpha_medic : front_medic { displayName = "Alpha Combat Medic"; role = "roleAlpha"; };
    class front_alpha_rifleman : front_rifleman { displayName = "Alpha Rifleman"; role = "roleAlpha"; };

    // Bravo squad
    class front_bravo_squadlead : front_squadlead { displayName = "Bravo Squad Leader"; role = "roleBravo"; };
    class front_bravo_grenadier : front_grenadier { displayName = "Bravo Grenadier"; role = "roleBravo"; };
    class front_bravo_autorifleman : front_autorifleman { displayName = "Bravo Automatic Rifleman"; role = "roleBravo"; };
    class front_bravo_medic : front_medic { displayName = "Bravo Combat Medic"; role = "roleBravo"; };
    class front_bravo_rifleman : front_rifleman { displayName = "Bravo Rifleman"; role = "roleBravo"; };

    // Charlie squad
    class front_charlie_squadlead : front_squadlead { displayName = "Charlie Squad Leader"; role = "roleCharlie"; };
    class front_charlie_grenadier : front_grenadier { displayName = "Charlie Grenadier"; role = "roleCharlie"; };
    class front_charlie_autorifleman : front_autorifleman { displayName = "Charlie Automatic Rifleman"; role = "roleCharlie"; };
    class front_charlie_medic : front_medic { displayName = "Charlie Combat Medic"; role = "roleCharlie"; };
    class front_charlie_rifleman : front_rifleman { displayName = "Charlie Rifleman"; role = "roleCharlie"; };

    // Weapons squad
    class front_weapons_lead : front_teamlead { displayName = "Weapons Squad Leader"; role = "roleWeapons"; };
    class front_weapons_gunner : front_machinegunner { displayName = "Weapons Machine Gunner"; role = "roleWeapons"; };
    class front_weapons_at : front_rifleman_at { displayName = "Weapons AT Specialist"; role = "roleWeapons"; };
    class front_weapons_bearer : front_ammo_bearer { displayName = "Weapons Ammo Bearer"; role = "roleWeapons"; };

    // Recon
    class front_recon_lead : front_teamlead {
        displayName = "Recon Team Leader";
        role = "roleRecon";
        weapons[] = {"arifle_MXC_F","hgun_P07_F","Rangefinder","Throw","Put"};
        linkedItems[] = {"V_TacVest_khk","H_Booniehat_khk_hs","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles","optic_Hamr"};
    };
    class front_recon_scout : front_rifleman {
        displayName = "Recon Scout";
        role = "roleRecon";
        weapons[] = {"arifle_MXC_F","hgun_P07_F","Binocular","Throw","Put"};
        linkedItems[] = {"V_Chestrig_khk","H_Booniehat_khk_hs","ItemMap","ItemCompass","ItemWatch","ItemRadio","NVGoggles","optic_MRCO"};
    };
    class front_recon_marksman : front_marksman { displayName = "Recon Marksman"; role = "roleRecon"; };
    class front_recon_medic : front_medic { displayName = "Recon Medic"; role = "roleRecon"; };

    // Armor crew
    class front_armor_commander : front_tank_commander { displayName = "Armor Commander"; role = "roleArmor"; };
    class front_armor_gunner : front_tank_gunner { displayName = "Armor Gunner"; role = "roleArmor"; };
    class front_armor_driver : front_tank_driver { displayName = "Armor Driver"; role = "roleArmor"; };

    // Aviation
    class front_aviation_cas : front_cas_pilot { displayName = "CAS Pilot"; role = "roleAviation"; };
    class front_aviation_transport : front_transport_pilot { displayName = "Transport Pilot"; role = "roleAviation"; };
    class front_aviation_chief : front_crew_chief { displayName = "Aviation Crew Chief"; role = "roleAviation"; };

    // Support and logistics
    class front_support_engineer : front_engineer { displayName = "Combat Engineer"; role = "roleSupport"; };
    class front_support_eod : front_eod { displayName = "EOD Technician"; role = "roleSupport"; };
    class front_support_jtac : front_jtac { displayName = "JTAC"; role = "roleCommand"; };
    class front_support_logistics : front_logistics { displayName = "Logistics Coordinator"; role = "roleLogistics"; };
};
