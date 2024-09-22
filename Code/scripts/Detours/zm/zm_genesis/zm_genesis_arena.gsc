detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_e499e553()
{
	level endon("arena_challenge_ended");
	level endon("fire_challenge_ended");
	for (;;) {
		var_98176bbc = SRandomInt("zm_genesis_arena_fire_challenge", 5);
		level thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_e462dab8]](1, var_98176bbc);
		wait 5;
		var_98176bbc = SRandomIntRange("zm_genesis_arena_fire_challenge", 5, 8);
		level thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_e462dab8]](1, var_98176bbc);
		wait 5;
	}
}

detour namespace_d90687be<scripts\zm\zm_genesis_arena.gsc>::function_531007c0(e_player)
{
	return function_531007c0(e_player);
}

function_531007c0(e_player)
{
	queryresult = PositionQuery_Source_Navigation(e_player.origin + (0, 0, SRandomIntRange("zm_genesis_arena_spawn_wasp", 40, 100)), 300, 600, 10, 10, "navvolume_small");
	a_points = SArrayRandomize(queryresult.data, "zm_genesis_arena_spawn_wasp");
	foreach (point in a_points) {
		if (BulletTracePassed(point.origin, e_player.origin, 0, e_player)) {
			return point;
		}
	}
	return a_points[0];
}

detour namespace_d90687be<scripts\zm\zm_genesis_arena.gsc>::function_352c3c15()
{
	if (level.var_42e19a0b == 1) {
		var_72214acc = SRandomIntRange("zm_genesis_arena_elemental_zombie", 0, 4);
		if (var_72214acc == 0) {
			self thread [[@zm_elemental_zombie<scripts\zm\_zm_elemental_zombies.gsc>::function_1b1bb1b]]();
		}
		else if (var_72214acc == 1) {
			self thread [[@zm_elemental_zombie<scripts\zm\_zm_elemental_zombies.gsc>::function_f4defbc2]]();
		}
	}
	else if (level.var_42e19a0b == 2) {
		if (SRandomIntRange("zm_genesis_arena_elemental_zombie", 0, 4) > 0) {
			var_72214acc = SRandomIntRange("zm_genesis_arena_elemental_zombie", 0, 4);
			if (var_72214acc == 0) {
				self thread [[@zm_elemental_zombie<scripts\zm\_zm_elemental_zombies.gsc>::function_1b1bb1b]]();
			}
			else if (var_72214acc == 1) {
				self thread [[@zm_elemental_zombie<scripts\zm\_zm_elemental_zombies.gsc>::function_f4defbc2]]();
			}
			else if (var_72214acc == 2) {
				self thread [[@zm_light_zombie<scripts\zm\_zm_light_zombie.gsc>::function_a35db70f]]();
			}
			else if (var_72214acc == 3) {
				self thread [[@zm_shadow_zombie<scripts\zm\_zm_shadow_zombie.gsc>::function_1b2b62b]]();
			}
		}
	}
	else if (level.var_42e19a0b == 3) {
		var_72214acc = SRandomIntRange("zm_genesis_arena_elemental_zombie", 0, 4);
		if (var_72214acc == 0) {
			self thread [[@zm_elemental_zombie<scripts\zm\_zm_elemental_zombies.gsc>::function_1b1bb1b]]();
		}
		else if (var_72214acc == 1) {
			self thread [[@zm_elemental_zombie<scripts\zm\_zm_elemental_zombies.gsc>::function_1b1bb1b]]();
		}
		else if (var_72214acc == 2) {
			self thread [[@zm_light_zombie<scripts\zm\_zm_light_zombie.gsc>::function_a35db70f]]();
		}
		else if (var_72214acc == 3) {
			self thread [[@zm_shadow_zombie<scripts\zm\_zm_shadow_zombie.gsc>::function_1b2b62b]]();
		}
	}
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_e06bfc41()
{
	level endon("arena_challenge_ended");
	level endon("fire_challenge_ended");
	var_44ed020 = SRandomIntRange("zm_genesis_arena_pillar", 0, 4);
	for (;;) {
		level thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_a0aeb892]](var_44ed020);
		wait 31;
		var_44ed020 = [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_320bc09]](4, var_44ed020);
	}
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_c0d6adb6()
{
	level endon(#"hash_c0d6adb6");
	level endon("arena_challenge_ended");
	level endon("electricity_challenge_ended");
	var_4054c946 = 4;
	var_665743af = 4;
	var_5c856d1f = SRandomIntRange("zm_genesis_arena_walls", 0, 4);
	switch (var_5c856d1f) {
		case 0: {
			var_665743af = var_665743af - 1;
			break;
		}
		case 1: {
			var_665743af = var_665743af + 1;
			break;
		}
		case 2: {
			var_4054c946 = var_4054c946 - 1;
			break;
		}
		case 3: {
			var_4054c946 = var_4054c946 + 1;
			break;
		}
	}
	for (;;) {
		b_reverse_dir = 0;
		if (var_5c856d1f == 2 || var_5c856d1f == 1) {
			b_reverse_dir = 1;
		}
		str_name = (("arena_fence_" + var_4054c946) + "_") + var_665743af;
		var_44622ece = struct::get(str_name, "targetname");
		level thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_cc9c82c8]](var_44622ece, 3, undefined, b_reverse_dir, 1);
		wait 0.75;
		switch (var_5c856d1f) {
			case 0: {
				var_665743af = var_665743af + 1;
				break;
			}
			case 1: {
				var_665743af = var_665743af - 1;
				break;
			}
			case 2: {
				var_4054c946 = var_4054c946 - 1;
				break;
			}
			case 3: {
				var_4054c946 = var_4054c946 + 1;
				break;
			}
		}
		var_5c856d1f = function_1bd87d75(var_4054c946, var_665743af, var_5c856d1f);
		switch (var_5c856d1f) {
			case 0: {
				var_665743af = var_665743af + 1;
				break;
			}
			case 1: {
				var_665743af = var_665743af - 1;
				break;
			}
			case 2: {
				var_4054c946 = var_4054c946 - 1;
				break;
			}
			case 3: {
				var_4054c946 = var_4054c946 + 1;
				break;
			}
		}
	}
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_d9624751()
{
	level notify(#"hash_d9624751");
	level endon(#"hash_d9624751");
	level endon(#"hash_e59686ee");
	if (!IsDefined(level.var_eb7b7914)) {
		level.var_eb7b7914 = 0;
	}
	for (;;) {
		if (level.var_eb7b7914 < level.var_a0135c54) {
			var_ea9e640b = SRandomIntRange("zm_genesis_arena_fury_spawn", 0, 8);
			s_spawnpoint = struct::get("arena_fury_" + var_ea9e640b, "targetname");
			level thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_e6146239]](s_spawnpoint, 1);
			wait 3;
		}
		else {
			util::wait_network_frame();
		}
	}
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_47c38473()
{
	level notify(#"hash_47c38473");
	level endon(#"hash_47c38473");
	level endon("final_boss_defeated");
	level.var_3ba63921 = 0;
	var_90530d3 = 0;
	for (;;) {
		self.health = 1000000;
		self waittill("damage", amount, attacker, direction_vec, point, type, tagname, modelname, partname, weapon);
		if (!level flag::get("final_boss_vulnerable")) {
			continue;
		}
		if (IsPlayer(attacker)) {
			attacker [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::show_hit_marker]]();
		}
		PlayFX(level._effect["shadowman_impact_fx"], point);
		var_90530d3 = var_90530d3 + amount;
		n_player_count = level.activeplayers.size;
		var_d6a1b83c = 0.5 + (0.5 * ((n_player_count - 1) / 3));
		var_9bd75db5 = 2000 * var_d6a1b83c;
		if (var_90530d3 >= var_9bd75db5) {
			[[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_2de2733c]]();
			var_90530d3 = 0;
			level.var_3ba63921 = level.var_3ba63921 + SRandomIntRange("zm_genesis_arena_shadowman_move", 1, 3);
			if (level flag::get("hope_done")) {
				level.var_3ba63921++;
			}
			if (level.var_3ba63921 >= 11) {
				level thread [[@zm_genesis_sound<scripts\zm\zm_genesis_sound.gsc>::function_ecd49d9c]]();
			}
			if (level.var_3ba63921 >= 12) {
				level.var_3ba63921 = 12;
				if (level flag::get("hope_done")) {
					level.var_5b08e991 clientfield::set("hope_spark", 1);
				}
				level flag::set("final_boss_at_deaths_door");
			}
			self [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_284b1884]](level.var_d7e8c63e[level.var_3ba63921], 0.1);
			level.var_5b08e991 clientfield::set("boss_clone_fx", 1);
			level.var_5b08e991 thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_d3b47fbf]]();
		}
	}
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_5c0b3137()
{
	level notify(#"hash_5c0b3137");
	level endon(#"hash_5c0b3137");
	level endon("final_boss_defeated");
	if (!IsDefined(level.var_eb7b7914)) {
		level.var_eb7b7914 = 0;
	}
	for (;;) {
		if (level.var_eb7b7914 < level.var_a0135c54) {
			var_ea9e640b = SRandomIntRange("zm_genesis_arena_fury_spawn", 0, 8);
			s_spawnpoint = struct::get("arena_fury_" + var_ea9e640b, "targetname");
			level thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_e6146239]](s_spawnpoint);
			wait SRandomIntRange("zm_genesis_arena_fury_spawn", 5, 8);
		}
		else {
			util::wait_network_frame();
		}
	}
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_f71c240d()
{
	level notify(#"hash_f71c240d");
	level endon(#"hash_f71c240d");
	level endon("final_boss_defeated");
	if (!IsDefined(level.var_338630d6)) {
		level.var_338630d6 = 0;
	}
	for (;;) {
		if (level.var_338630d6 < level.var_dba75e2a) {
			var_bac4e70 = SRandomIntRange("zm_genesis_arena_keeper_spawn", 0, 4);
			s_spawnpoint = struct::get("arena_keeper_" + var_bac4e70, "targetname");
			level thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_ff611187]](s_spawnpoint);
			wait 3;
		}
		else {
			util::wait_network_frame();
		}
	}
}

detour namespace_d90687be<scripts\zm\zm_genesis_arena.gsc>::get_unused_spawn_point(var_b852cbf7)
{
	a_valid_spawn_points = [];
	b_all_points_used = 0;
	while (!a_valid_spawn_points.size)
	{
		foreach (s_spawn_point in self.var_4ff05dea)
		{
			if (!IsDefined(s_spawn_point.spawned_zombie) || b_all_points_used)
			{
				s_spawn_point.spawned_zombie = 0;
			}
			var_ce040708 = !var_b852cbf7 || (IsDefined(s_spawn_point.var_4ef230e4) && s_spawn_point.var_4ef230e4);
			if (!s_spawn_point.spawned_zombie && var_ce040708)
			{
				array::add(a_valid_spawn_points, s_spawn_point, 0);
			}
		}
		if (!a_valid_spawn_points.size)
		{
			b_all_points_used = 1;
		}
		wait 0.1;
	}
	s_spawn_point = SArrayRandom(a_valid_spawn_points, "zm_genesis_arena_spawn_location");
	s_spawn_point.spawned_zombie = 1;
	return s_spawn_point;
}

detour namespace_d90687be<scripts\zm\zm_genesis_arena.gsc>::function_17f3b496()
{
	level endon("arena_challenge_ended");
	var_eeb77e19 = [];
	while (level clientfield::get("circle_state") == 3) {
		var_eeb77e19 = array::remove_dead(var_eeb77e19, 0);
		var_16d0ce4b = 16;
		if (level.var_f98b3213 < 4) {
			var_16d0ce4b = 8;
		}
		else if (level.var_f98b3213 < 6) {
			var_16d0ce4b = 12;
		}
		e_player = SArrayRandom([[@namespace_d90687be<scripts\zm\zm_genesis_arena.gsc>::function_e33fa65f]](), "zm_genesis_arena_spawn_wasp");
		if (!IsDefined(e_player)) {
			continue;
		}
		spawn_point = function_531007c0(e_player);
		if (var_eeb77e19.size < var_16d0ce4b) {
			if (IsDefined(spawn_point)) {
				v_spawn_origin = spawn_point.origin;
				v_ground = BulletTrace(spawn_point.origin + VectorScale((0, 0, 1), 40), (spawn_point.origin + VectorScale((0, 0, 1), 40)) + (VectorScale((0, 0, -1), 100000)), 0, undefined)["position"];
				if (DistanceSquared(v_ground, spawn_point.origin) < 1600) {
					v_spawn_origin = v_ground + VectorScale((0, 0, 1), 40);
				}
				queryresult = PositionQuery_Source_Navigation(v_spawn_origin, 0, 80, 80, 15, "navvolume_small");
				a_points = SArrayRandomize(queryresult.data, "zm_genesis_arena_spawn_wasp");
				a_spawn_origins = [];
				n_points_found = 0;
				foreach (point in a_points) {
					str_zone = zm_zonemgr::get_zone_from_position(point.origin, 1);
					if (IsDefined(str_zone) && (str_zone == "dark_arena_zone" || str_zone == "dark_arena2_zone")) {
						if (BulletTracePassed(point.origin, spawn_point.origin, 0, e_player)) {
							if (!IsDefined(a_spawn_origins)) {
								a_spawn_origins = [];
							}
							else if (!IsArray(a_spawn_origins)) {
								a_spawn_origins = array(a_spawn_origins);
							}
							a_spawn_origins[a_spawn_origins.size] = point.origin;
							n_points_found++;
							if (n_points_found >= 1) {
								break;
							}
						}
					}
				}
				if (a_spawn_origins.size >= 1) {
					n_spawn = 0;
					while (n_spawn < 1) {
						for (i = a_spawn_origins.size - 1; i >= 0; i--) {
							v_origin = a_spawn_origins[i];
							level.wasp_spawners[0].origin = v_origin;
							ai = zombie_utility::spawn_zombie(level.wasp_spawners[0]);
							if (IsDefined(ai)) {
								array::add(var_eeb77e19, ai, 0);
								ai [[@parasite<scripts\shared\vehicles\_parasite.gsc>::set_parasite_enemy]](e_player);
								level thread [[@zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::wasp_spawn_init]](ai, v_origin);
								ArrayRemoveIndex(a_spawn_origins, i);
								ai.ignore_enemy_count = 1;
								ai.var_bdb9d21d = 1;
								ai.no_damage_points = 1;
								ai.deathpoints_already_given = 1;
								if (IsDefined(level.zm_wasp_spawn_callback)) {
									ai thread [[level.zm_wasp_spawn_callback]]();
								}
								n_spawn++;
								wait SRandomFloatRange("zm_genesis_arena_spawn_wasp", 0.06666666, 0.1333333);
								break;
							}
							wait SRandomFloatRange("zm_genesis_arena_spawn_wasp", 0.06666666, 0.1333333);
						}
					}
					b_swarm_spawned = 1;
				}
				util::wait_network_frame();
			}
		}
		wait level.zombie_vars["zombie_spawn_delay"];
	}
}

detour namespace_d90687be<scripts\zm\zm_genesis_arena.gsc>::function_7ebc257e()
{
	var_8c5f9971 = [];
	var_d12aa484 = struct::get_array("arena_spider_spawner", "targetname");
	while (level clientfield::get("circle_state") == 3) {
		var_8c5f9971 = array::remove_dead(var_8c5f9971, 0);
		var_9e20b46f = 12;
		if (var_8c5f9971.size < var_9e20b46f) {
			s_spawn_point = SArrayRandom(var_d12aa484, "zm_genesis_arena_spider_spawn");
			level.var_718361fb = [[@zm_genesis_spiders<scripts\zm\zm_genesis_spiders.gsc>::function_3f180afe]]();
			ai = [[@zm_ai_spiders<scripts\zm\_zm_genesis_spiders.gsc>::function_f4bd92a2]](1, s_spawn_point);
			array::add(var_8c5f9971, ai, 0);
		}
		wait 1;
	}
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_73ff31ff()
{
	var_b687ed6e = [];
	for (x = 1; x < 4; x++) {
		for (y = 0; y < 5; y++) {
			var_495730fe = [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_7d8f4dd0]](x, y);
			if (!IS_TRUE(var_495730fe.var_9391fde5)) {
				if (!IsDefined(var_b687ed6e)) {
					var_b687ed6e = [];
				}
				else if (!IsArray(var_b687ed6e)) {
					var_b687ed6e = array(var_b687ed6e);
				}
				var_b687ed6e[var_b687ed6e.size] = var_495730fe;
			}
		}
	}
	return SArrayRandom(var_b687ed6e, "zm_genesis_arena_light");
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_c5938cab(b_on)
{
	var_c3f79192 = [];
	if (!IsDefined(var_c3f79192)) {
		var_c3f79192 = [];
	}
	else if (!IsArray(var_c3f79192)) {
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_left";
	if (!IsDefined(var_c3f79192)) {
		var_c3f79192 = [];
	}
	else if (!IsArray(var_c3f79192)) {
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_right";
	if (!IsDefined(var_c3f79192)) {
		var_c3f79192 = [];
	}
	else if (!IsArray(var_c3f79192)) {
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_front";
	if (!IsDefined(var_c3f79192)) {
		var_c3f79192 = [];
	}
	else if (!IsArray(var_c3f79192)) {
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_back";
	if (!IsDefined(var_c3f79192)) {
		var_c3f79192 = [];
	}
	else if (!IsArray(var_c3f79192)) {
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_center_left";
	if (!IsDefined(var_c3f79192)) {
		var_c3f79192 = [];
	}
	else if (!IsArray(var_c3f79192)) {
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_center_right";
	if (!IsDefined(var_c3f79192)) {
		var_c3f79192 = [];
	}
	else if (!IsArray(var_c3f79192)) {
		var_c3f79192 = array(var_c3f79192);
	}
	var_c3f79192[var_c3f79192.size] = "arena_smoke_center_back";
	foreach (var_36655503 in var_c3f79192) {
		[[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_7c229e48]](var_36655503);
	}
	if (b_on) {
		for (i = 0; i < 3; i++) {
			[[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_c3266652]](SArrayRandom(var_c3f79192, "zm_genesis_arena_smoke"), undefined, 0.5);
		}
	}
	else {
		[[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_7c229e48]]("arena_smoke_left");
		[[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_7c229e48]]("arena_smoke_right");
		[[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_7c229e48]]("arena_smoke_front");
		[[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_7c229e48]]("arena_smoke_back");
		[[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_7c229e48]]("arena_smoke_center_left");
		[[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_7c229e48]]("arena_smoke_center_right");
		[[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::function_7c229e48]]("arena_smoke_center_back");
	}
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_ffce63a9()
{
	level endon("arena_challenge_ended");
	level endon("electricity_challenge_ended");
	a_indexes = array(0, 1, 2, 3, 4, 5);
	for (;;) {
		a_indexes = SArrayRandomize(a_indexes, "zm_genesis_arena_fence");
		for (i = 0; i < 3; i++) {
			str_name = "arena_fence_ext_high_" + a_indexes[i];
			level thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_5e9f49d2]](str_name, 7, VectorScale((0, 0, -1), 192), 0, 3);
		}
		wait 5;
	}
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_1bd87d75(var_4054c946, var_665743af, var_5c856d1f)
{
	return function_1bd87d75(var_4054c946, var_665743af, var_5c856d1f);
}

function_1bd87d75(var_4054c946, var_665743af, var_5c856d1f)
{
	if (var_4054c946 == 0 && var_665743af == 0) {
		if (var_5c856d1f == 1) {
			return 3;
		}
		return 0;
	}
	if (var_4054c946 == 8 && var_665743af == 0) {
		if (var_5c856d1f == 1) {
			return 2;
		}
		return 0;
	}
	if (var_4054c946 == 0 && var_665743af == 8) {
		if (var_5c856d1f == 0) {
			return 3;
		}
		return 1;
	}
	if (var_4054c946 == 8 && var_665743af == 8) {
		if (var_5c856d1f == 0) {
			return 2;
		}
		return 1;
	}
	var_47c6b9e2 = [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_c3557b99]](var_5c856d1f);
	if ([[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_401ee1f7]](var_4054c946, var_665743af)) {
		if (var_4054c946 == 4 && var_665743af == 0) {
			var_6af9e605 = array(2, 0, 3);
		}
		if (var_4054c946 == 0 && var_665743af == 4) {
			var_6af9e605 = array(1, 0, 3);
		}
		if (var_4054c946 == 4 && var_665743af == 8) {
			var_6af9e605 = array(2, 1, 3);
		}
		if (var_4054c946 == 8 && var_665743af == 4) {
			var_6af9e605 = array(2, 0, 1);
		}
		var_6af9e605 = [[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::array_remove]](var_6af9e605, var_47c6b9e2);
		return SArrayRandom(var_6af9e605, "zm_genesis_arena_fence");
	}
	if (var_4054c946 == 4 && var_665743af == 4) {
		var_6af9e605 = array(2, 0, 3, 1);
		var_6af9e605 = [[@zm_genesis_util<scripts\zm\zm_genesis_util.gsc>::array_remove]](var_6af9e605, var_47c6b9e2);
		return SArrayRandom(var_6af9e605, "zm_genesis_arena_fence");
	}
	return var_5c856d1f;
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_320bc09(n_max, var_b1f69aca)
{
	return function_320bc09(n_max, var_b1f69aca);
}

function_320bc09(n_max, var_b1f69aca)
{
	a_numbers = [];
	for (i = 0; i < n_max; i++) {
		if (i != var_b1f69aca) {
			if (!IsDefined(a_numbers)) {
				a_numbers = [];
			}
			else if (!IsArray(a_numbers)) {
				a_numbers = array(a_numbers);
			}
			a_numbers[a_numbers.size] = i;
		}
	}
	return SArrayRandom(a_numbers, "zm_genesis_arena_lava");
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_5a4ec2e2(var_87c8152d = 0)
{
	if (!IsDefined(level.var_beccbadb)) {
		level.var_beccbadb = 0;
	}
	if (!IsDefined(level.var_359cfe42)) {
		level.var_359cfe42 = 0;
	}
	var_fae0d733 = struct::get_array("arena_boss_spawnpoint", "targetname");
	if (IsDefined(level.var_a0e9e53)) {
		ArrayRemoveValue(var_fae0d733, level.var_a0e9e53);
	}
	s_loc = SArrayRandom(var_fae0d733, "zm_genesis_arena_margwa_spawn");
	level.var_a0e9e53 = s_loc;
	if (var_87c8152d == 2) {
		e_ai = [[@zm_ai_margwa_elemental<scripts\zm\_zm_ai_margwa_elemental.gsc>::function_75b161ab]](undefined, s_loc);
	}
	else if (var_87c8152d == 1) {
		e_ai = [[@zm_ai_margwa_elemental<scripts\zm\_zm_ai_margwa_elemental.gsc>::function_26efbc37]](undefined, s_loc);
	}
	else {
		e_ai = [[@zm_ai_margwa<scripts\zm\_zm_ai_margwa_no_idgun.gsc>::function_8a0708c2]](s_loc);
		e_ai clientfield::set("arena_margwa_init", 1);
	}
	if (IsDefined(e_ai)) {
		level.var_beccbadb = level.var_beccbadb + 1;
		level.var_359cfe42 = level.var_359cfe42 + 1;
		level.var_95981590 = e_ai;
		level notify(#"hash_c484afcb");
		e_ai.b_ignore_cleanup = 1;
		e_ai.no_powerups = 1;
		n_health = (level.round_number * 100) + 100;
		e_ai [[@margwaserverutils<scripts\shared\ai\margwa.gsc>::margwasetheadhealth]](n_health);
		e_ai thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_730e8210]](var_87c8152d);
	}
	return e_ai;
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_2ed620e8(var_87c8152d = 0)
{
	var_fae0d733 = struct::get_array("arena_boss_spawnpoint", "targetname");
	s_loc = SArrayRandom(var_fae0d733, "zm_genesis_arena_boss_spawn");
	e_ai = [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::spawn_mechz]](s_loc, 0);
	if (IsDefined(e_ai)) {
		level.var_435967f3 = level.var_435967f3 + 1;
		level.var_359cfe42 = level.var_359cfe42 + 1;
		e_ai.no_powerups = 1;
		e_ai thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_ebe65636]]();
		util::wait_network_frame();
		e_ai.b_ignore_cleanup = 1;
		level notify(#"hash_b4c3cb33");
		e_ai thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_77127ffa]](var_87c8152d);
		return e_ai;
	}
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::final_boss_shadowman_attack_thread()
{
	level notify("final_boss_shadowman_attack_thread");
	level endon("final_boss_shadowman_attack_thread");
	level endon("final_boss_defeated");
	var_7de627cf = 5;
	var_97562c6c = 30;
	var_84b1a277 = array(0, 1, 2, 3);
	var_84b1a277 = SArrayRandomize(var_84b1a277, "zm_genesis_arena_shadowman_attack");
	while (!level flag::get("final_boss_defeated")) {
		if (level flag::get("final_boss_vulnerable")) {
			flag::wait_till_clear("final_boss_vulnerable");
			continue;
		}
		level.var_5b08e991 [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_1a4e2d94]](var_7de627cf, undefined);
		if (level flag::get("final_boss_vulnerable")) {
			flag::wait_till_clear("final_boss_vulnerable");
			continue;
		}
		var_e7d6a3ca = var_84b1a277[level.var_74f93a5e];
		level.var_74f93a5e = level.var_74f93a5e + 1;
		if (level.var_74f93a5e > var_84b1a277.size) {
			level.var_74f93a5e = 0;
			var_84b1a277 = SArrayRandomize(var_84b1a277, "zm_genesis_arena_shadowman_attack");
			var_e7d6a3ca = var_84b1a277[level.var_74f93a5e];
			if (var_84b1a277[0] == var_e7d6a3ca) {
				var_84b1a277 = array::reverse(var_84b1a277);
			}
			[[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_9faf5035]]();
		}
		[[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_60c23a57]](var_e7d6a3ca);
		level util::waittill_any_timeout(var_97562c6c, "final_boss_defeated", "final_boss_shadowman_attack_thread");
		[[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_2de2733c]]();
		wait 15;
	}
}

detour zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_47e5fca7()
{
	var_fae0d733 = struct::get_array("arena_boss_spawnpoint", "targetname");
	s_loc = SArrayRandom(var_fae0d733, "zm_genesis_arena_mechz");
	e_ai = [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::spawn_mechz]](s_loc, 0);
	util::wait_network_frame();
	if (IsDefined(e_ai)) {
		e_ai.b_ignore_cleanup = 1;
		level notify(#"hash_b4c3cb33");
		level.var_435967f3 = level.var_435967f3 + 1;
		level.var_359cfe42 = level.var_359cfe42 + 1;
		e_ai thread [[@zm_genesis_arena<scripts\zm\zm_genesis_arena.gsc>::function_ebe65636]]();
	}
	return e_ai;
}