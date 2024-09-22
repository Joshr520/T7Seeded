detour zm_genesis_round_bosses<scripts\zm\zm_genesis_round_bosses.gsc>::function_830cdf99()
{
	return function_830cdf99();
}

function_830cdf99()
{
	var_fffe05f0 = SArrayRandomize(level.margwa_locations, "zm_genesis_round_bosses_location");
	a_spawn_locs = [];
	for (i = 0; i < var_fffe05f0.size; i++) {
		s_loc = var_fffe05f0[i];
		str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
		if (IsDefined(str_zone) && level.zones[str_zone].is_occupied) {
			a_spawn_locs[a_spawn_locs.size] = s_loc;
		}
	}
	if (a_spawn_locs.size == 0) {
		for (i = 0; i < var_fffe05f0.size; i++) {
			s_loc = var_fffe05f0[i];
			str_zone = zm_zonemgr::get_zone_from_position(s_loc.origin, 1);
			if (IsDefined(str_zone) && level.zones[str_zone].is_active) {
				a_spawn_locs[a_spawn_locs.size] = s_loc;
			}
		}
	}
	if (a_spawn_locs.size > 0) {
		a_spawn_locs = SArrayRandomize(a_spawn_locs, "zm_genesis_round_bosses_location");
		return a_spawn_locs[0];
	}
	return var_fffe05f0[0];
}

detour zm_genesis_round_bosses<scripts\zm\zm_genesis_round_bosses.gsc>::function_c68599fd()
{
	level.var_b32a2aa0++;
	switch (level.var_b32a2aa0) {
		case 1: {
			level thread spawn_boss("margwa");
			break;
		}
		case 2: {
			level thread spawn_boss("mechz");
			break;
		}
		default: {
			if (SCoinToss("zm_genesis_round_bosses_boss_spawn")) {
				level thread spawn_boss("margwa");
			}
			else {
				level thread spawn_boss("mechz");
			}
			break;
		}
	}
	wait 1;
	a_players = GetPlayers();
	if (a_players.size == 1) {
		return;
	}
	switch (level.var_b32a2aa0) {
		case 1: {
			break;
		}
		case 2: {
			if (a_players.size == 3) {
				spawn_boss("margwa");
			}
			else if (a_players.size == 4) {
				spawn_boss("margwa");
			}
			break;
		}
		case 3: {
			if (a_players.size == 2) {
				spawn_boss("mechz");
			}
			else if (a_players.size == 3) {
				spawn_boss("mechz");
				wait 1;
				spawn_boss("margwa");
			}
			else if (a_players.size == 4) {
				spawn_boss("mechz");
				wait 1;
				spawn_boss("margwa");
				wait 1;
				spawn_boss("margwa");
			}
			break;
		}
		default: {
			if (a_players.size == 1) {
				var_b3c4bbcc = 1;
			}
			else if (a_players.size == 2) {
				var_b3c4bbcc = 1;
			}
			else if (a_players.size == 3) {
				var_b3c4bbcc = 2;
			}
			else {
				var_b3c4bbcc = 3;
			}
			for (i = 0; i < var_b3c4bbcc; i++) {
				if (SCoinToss("zm_genesis_round_bosses_boss_spawn")) {
					spawn_boss("margwa");
				}
				else {
					spawn_boss("mechz");
				}
				wait 1;
			}
			break;
		}
	}
}

detour zm_genesis_round_bosses<scripts\zm\zm_genesis_round_bosses.gsc>::spawn_boss(str_enemy, v_pos)
{
	return spawn_boss(str_enemy, v_pos);
}

spawn_boss(str_enemy, v_pos)
{
	s_loc = function_830cdf99();
	if (!IsDefined(s_loc)) {
		return;
	}
	level thread [[@zm_genesis_vo<scripts\zm\zm_genesis_vo.gsc>::function_79eeee03]](str_enemy);
	if (str_enemy == "margwa") {
		if (SCoinToss("zm_genesis_round_bosses_spawn_margwa")) {
			var_33504256 = [[@zm_ai_margwa_elemental<scripts\zm\_zm_ai_margwa_elemental.gsc>::function_75b161ab]](undefined, s_loc);
		}
		else {
			var_33504256 = [[@zm_ai_margwa_elemental<scripts\zm\_zm_ai_margwa_elemental.gsc>::function_26efbc37]](undefined, s_loc);
		}
		var_33504256.var_26f9f957 = @zm_genesis_round_bosses<scripts\zm\zm_genesis_round_bosses.gsc>::function_26f9f957;
		level.var_95981590 = var_33504256;
		level notify(#"hash_c484afcb");
		if (IsDefined(var_33504256)) {
			var_33504256.b_ignore_cleanup = 1;
			n_health = (level.round_number * 100) + 100;
			var_33504256 [[@margwaserverutils<scripts\shared\ai\margwa.gsc>::margwasetheadhealth]](n_health);
		}
	}
	else if (str_enemy == "mechz") {
		if (IsDefined(s_loc.script_string) && s_loc.script_string == "exterior") {
			var_33504256 = [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::spawn_mechz]](s_loc, 1);
		}
		else {
			var_33504256 = [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::spawn_mechz]](s_loc, 0);
		}
	}
	if (!IsDefined(var_33504256.maxhealth)) {
		var_33504256.maxhealth = var_33504256.health;
	}
	if (IsDefined(v_pos)) {
		var_33504256 ForceTeleport(v_pos, var_33504256.angles);
	}
	var_33504256.var_953b581c = 1;
	return var_33504256;
}