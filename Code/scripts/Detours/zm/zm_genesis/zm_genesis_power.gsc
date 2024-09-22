detour zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::function_e467fa8d(s_spawn_pos)
{
	return function_e467fa8d(s_spawn_pos);
}

function_e467fa8d(s_spawn_pos)
{
	self endon("death");
	str_name = "power_soul" + self.script_int;
	s_struct = struct::get(str_name, "targetname");
	var_bb194a8c = 1;
	level thread [[@zm_genesis_apothicon_fury<scripts\zm\zm_genesis_apothicon_fury.gsc>::function_b55fb314]](var_bb194a8c, s_struct.origin, 128, s_spawn_pos.origin, s_spawn_pos.angles);
	switch (level.var_eada0345) {
		case 0: {
			[[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::function_779c1a49]](s_spawn_pos, s_struct.origin);
			break;
		}
		case 1: {
			if (SCoinToss("zm_genesis_power_spawn_enemy")) {
				[[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::function_779c1a49]](s_spawn_pos, s_struct.origin);
			}
			else {
				[[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::function_f55d851b]](s_spawn_pos, s_struct.origin);
			}
			break;
		}
		case 2: {
			n_random = SRandomInt("zm_genesis_power_spawn_enemy", 1000);
			if (n_random <= 333) {
				[[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::spawn_wasp]](s_spawn_pos, s_struct.origin);
			}
			else {
				[[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::function_f55d851b]](s_spawn_pos, s_struct.origin);
			}
			break;
		}
		case 3:
		default: {
			n_random = SRandomInt("zm_genesis_power_spawn_enemy", 1000);
			if (n_random <= 333) {
				[[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::function_779c1a49]](s_spawn_pos, s_struct.origin);
			}
			else if (n_random < 666) {
                [[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::spawn_wasp]](s_spawn_pos, s_struct.origin);
            }
            else {
            	[[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::function_f55d851b]](s_spawn_pos, s_struct.origin);
            }
			break;
		}
	}
}

detour zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::function_1d9b9b7b()
{
	self endon(self.str_kill_notify);
	self endon(self.var_3c42ad63);
	ai_index = 0;
	var_c00049d4 = "power_spawn" + self.script_int;
	var_8ef573c1 = struct::get_array(var_c00049d4, "targetname");
	var_8ef573c1 = SArrayRandomize(var_8ef573c1, "zm_genesis_power_ritual_spawn");
	self.var_b7d540e6 = GetTime();
	self.var_9437e3b6 = 0;
	var_f2882ed8 = 0;
	var_13b0b925 = GetTime();
	for (;;) {
		var_23e2425 = self [[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::function_d93f3a3f]]();
		n_percent = var_23e2425 / 15;
		level clientfield::set("corruption_tower" + self.script_int, n_percent);
		if (var_23e2425 >= 15) {
			break;
		}
		else if (var_23e2425 < 0) {
			self [[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::abort_ritual]]();
			wait 0.05;
			return;
		}
		n_alive = [[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::function_e793dedb]]();
		if (n_alive >= 12) {
			var_13b0b925 = var_13b0b925 + 100;
		}
		else if (GetTime() >= var_13b0b925) {
			s_spawn_pos = var_8ef573c1[var_f2882ed8];
			var_f2882ed8++;
			if (var_f2882ed8 >= var_8ef573c1.size)
			{
				var_f2882ed8 = 0;
			}
			self thread function_e467fa8d(s_spawn_pos);
			var_13b0b925 = GetTime() + ([[@zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::get_spawn_delay]]() * 1000);
		}
		util::wait_network_frame();
	}
}

detour zm_genesis_power<scripts\zm\zm_genesis_power.gsc>::get_favorite_enemy(v_origin)
{
	a_targets = GetPlayers();
	var_20a0668f = undefined;
	for (i = 0; i < a_targets.size; i++) {
		e_target = a_targets[i];
		dist = Distance(e_target.origin, v_origin);
		if (dist >= 1000) {
			continue;
		}
		if (!IsDefined(e_target.var_773a8dea)) {
			e_target.var_773a8dea = 0;
		}
		if (!zm_utility::is_player_valid(e_target)) {
			continue;
		}
		if (!IsDefined(var_20a0668f)) {
			var_20a0668f = e_target;
			continue;
		}
		if (e_target.var_773a8dea < var_20a0668f.var_773a8dea) {
			e_least_hunted = e_target;
		}
	}
	if (!IsDefined(e_least_hunted)) {
		e_least_hunted = SArrayRandom(a_targets, "zm_genesis_power_favorite_enemy");
	}
	return e_least_hunted;
}