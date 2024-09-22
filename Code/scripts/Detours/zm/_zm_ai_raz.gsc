detour zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::function_45bace88()
{
	while (![[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::function_ea911683]]()) {
		wait 0.1;
	}
	s_spawn_loc = undefined;
	var_19764360 = [[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::get_favorite_enemy]]();
	if (!IsDefined(var_19764360)) {
		wait SRandomFloatRange("zm_ai_raz_spawn_wait", 0.3333333, 0.6666667);
		return;
	}
	if (IsDefined(level.var_e80c1065)) {
		s_spawn_loc = [[level.var_e80c1065]](var_19764360);
	}
	else {
		s_spawn_loc = SArrayRandom(level.zm_loc_types["raz_location"], "zm_ai_raz_spawn_location");
	}
	if (!IsDefined(s_spawn_loc)) {
		wait SRandomFloatRange("zm_ai_raz_spawn_wait", 0.3333333, 0.6666667);
		return;
	}
	ai = [[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::function_665a13cd]](level.var_6bca5baa[0]);
	if (IsDefined(ai)) {
		ai thread [[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::function_b8671cc0]](s_spawn_loc);
		ai ForceTeleport(s_spawn_loc.origin, s_spawn_loc.angles);
		if (IsDefined(var_19764360)) {
			ai.favoriteenemy = var_19764360;
			ai.favoriteenemy.hunted_by++;
		}
		level.zombie_total--;
		[[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::function_a74c2884]]();
	}
}

detour zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::function_7ed6c714(n_to_spawn = 1, var_e41e673a, b_force_spawn = 0, var_b7959229 = undefined)
{
    return function_7ed6c714(n_to_spawn, var_e41e673a, b_force_spawn, var_b7959229);
}

function_7ed6c714(n_to_spawn = 1, var_e41e673a, b_force_spawn = 0, var_b7959229 = undefined)
{
	n_spawned = 0;
	while (n_spawned < n_to_spawn) {
		if (!b_force_spawn && ![[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::function_ea911683]]()) {
			return n_spawned;
		}
		players = GetPlayers();
		var_19764360 = [[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::get_favorite_enemy]]();
		if (IsDefined(var_b7959229)) {
			s_spawn_loc = var_b7959229;
		}
		else if (IsDefined(level.var_a3559c05)) {
            s_spawn_loc = [[level.var_a3559c05]](level.var_6bca5baa, var_19764360);
        }
        else if (level.zm_loc_types["raz_location"].size > 0) {
            s_spawn_loc = SArrayRandom(level.zm_loc_types["raz_location"], "zm_ai_raz_spawn_location");
        }
		if (!IsDefined(s_spawn_loc)) {
			return 0;
		}
		ai = [[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::function_665a13cd]](level.var_6bca5baa[0]);
		if (IsDefined(ai)) {
			ai ForceTeleport(s_spawn_loc.origin, s_spawn_loc.angles);
			ai.script_string = s_spawn_loc.script_string;
			ai.find_flesh_struct_string = ai.script_string;
			if (IsDefined(var_19764360)) {
				ai.favoriteenemy = var_19764360;
				ai.favoriteenemy.hunted_by++;
			}
			n_spawned++;
			if (IsDefined(var_e41e673a)) {
				ai thread [[var_e41e673a]]();
			}
			PlaySoundAtPosition("zmb_raz_spawn", s_spawn_loc.origin);
		}
		[[@zm_ai_raz<scripts\zm\_zm_ai_raz.gsc>::function_a74c2884]]();
	}
	return 1;
}