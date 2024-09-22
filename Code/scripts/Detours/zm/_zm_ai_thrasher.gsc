detour zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_8aac3fe()
{
	level.var_175273f2 = 1;
	level.var_e51f5b82 = 0;
	level.var_ebc4830 = level.round_number + SRandomIntRange("zm_ai_thrasher_round", 4, 7);
	for (;;) {
		level waittill("between_round_over");
		level.var_e51f5b82 = 0;
		if (IsDefined(level.var_3013498) && level.round_number == level.var_3013498) {
			level.var_ebc4830 = level.var_ebc4830 + 1;
			continue;
		}
		if (level flag::exists("connect_bunker_exterior_to_bunker_interior")) {
			if (level.round_number === level.var_ebc4830 && !level flag::get("connect_bunker_exterior_to_bunker_interior")) {
				level.var_ebc4830 = level.var_ebc4830 + 1;
				continue;
			}
		}
		if (level.round_number === level.var_ebc4830 && (level.round_number - level.var_1f0937ce) <= 3) {
			level.var_ebc4830 = level.var_ebc4830 + 1;
			continue;
		}
		if (level.round_number == level.var_ebc4830) {
			level.var_ebc4830 = level.round_number + 3;
			level thread [[@zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_8b7e4b15]]();
			level flag::set("thrasher_round");
			level waittill("end_of_round");
			level flag::clear("thrasher_round");
			level.var_175273f2++;
		}
	}
}

detour zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_bf8a850e(v_origin, weapon, e_attacker)
{
	if (IsDefined(level.var_d6539691)) {
		self thread [[level.var_d6539691]](v_origin, weapon, e_attacker);
	}
	else {
		var_d454b8fe = 0;
		var_29d3165e = gettime();
		var_94f86cd2 = 60 * 60;
		var_5ce805c5 = 36;
		while ((var_29d3165e + 5000) > gettime()) {
			if (level.var_e51f5b82 < 2) {
				zombies = GetAIArchetypeArray("zombie", "axis");
				foreach (zombie in zombies) {
					if (IsDefined(zombie) && IsAlive(zombie)) {
						var_c494d994 = (zombie.origin[0], zombie.origin[1], zombie.origin[2] + var_5ce805c5);
						if (DistanceSquared(var_c494d994, v_origin) <= var_94f86cd2) {
							if (0.2 >= SRandomFloat("zm_ai_thrasher_transform", 1) && [[@zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_cb4aac76]](zombie)) {
								level.var_e51f5b82++;
								var_d454b8fe++;
								[[@zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_8b323113]](zombie);
							}
						}
						if (var_d454b8fe >= 2) {
							return;
						}
					}
				}
			}
			wait 0.5;
		}
	}
}

detour zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::spawn_thrasher(var_42fbb5b1 = 1)
{
	if (![[@zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_6d24956b]]() && var_42fbb5b1) {
		return;
	}
	s_loc = [[@zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_22338aad]]();
	var_e3372b59 = zombie_utility::spawn_zombie(level.var_feebf312[0], "thrasher", s_loc);
	if (IsDefined(var_e3372b59) && IsDefined(s_loc)) {
		var_e3372b59 ForceTeleport(s_loc.origin, s_loc.angles);
		PlaySoundAtPosition("zmb_vocals_thrash_spawn", var_e3372b59.origin);
		if (!var_e3372b59 zm_utility::in_playable_area()) {
			player = SArrayRandom(level.players, "zm_ai_thrasher_spawn_player");
			if (zm_utility::is_player_valid(player, 0, 1)) {
				var_e3372b59 thread [[@zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_89976d94]](player.origin);
			}
		}
		return var_e3372b59;
	}
}