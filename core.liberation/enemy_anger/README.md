# Enemy anger tuning

This folder centralizes the alert level settings that drive enemy reaction intensity. The `scalars.sqf` file contains three numbers in an array `[base, min, max]` that are loaded by `front_fnc_enemyAnger` when the mission starts. Sabotage missions reduce the anger score while offensive missions raise it; persistence writes the current score on autosave.
