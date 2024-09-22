detour zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::special_wasp_spawn(n_to_spawn = 1, spawn_point, n_radius = 32, n_half_height = 32, b_non_round, spawn_fx = 1, b_return_ai = 0)
{
	wasp = GetEntArray("zombie_wasp", "targetname");
	if (IsDefined(wasp) && wasp.size >= 9) {
		return 0;
	}
	count = 0;
	while (count < n_to_spawn) {
		players = GetPlayers();
		favorite_enemy = [[@zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::get_favorite_enemy]]();
		spawn_enemy = favorite_enemy;
		if (!IsDefined(spawn_enemy)) {
			spawn_enemy = players[0];
		}
		if (IsDefined(level.wasp_spawn_func)) {
			spawn_point = [[level.wasp_spawn_func]](spawn_enemy);
		}
		while (!IsDefined(spawn_point)) {
			if (!IsDefined(spawn_point)) {
				spawn_point = zm_genesis_wasp_spawn_logic(spawn_enemy);
			}
			if (IsDefined(spawn_point)) {
				break;
			}
			wait 0.05;
		}
		ai = zombie_utility::spawn_zombie(level.wasp_spawners[0]);
		v_spawn_origin = spawn_point.origin;
		if (IsDefined(ai)) {
			queryresult = PositionQuery_Source_Navigation(v_spawn_origin, 0, n_radius, n_half_height, 15, "navvolume_small");
			if (queryresult.data.size) {
				point = queryresult.data[SRandomInt("zm_genesis_wasp_spawn_wasp", queryresult.data.size)];
				v_spawn_origin = point.origin;
			}
			ai [[@parasite<scripts\shared\vehicles\_parasite.gsc>::set_parasite_enemy]](favorite_enemy);
			ai.does_not_count_to_round = b_non_round;
			level thread [[@zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::wasp_spawn_init]](ai, v_spawn_origin, spawn_fx);
			count++;
		}
		wait level.zombie_vars["zombie_spawn_delay"];
	}
	if (b_return_ai) {
		return ai;
	}
	return 1;
}

detour zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::wasp_spawn_logic(favorite_enemy)
{
	return zm_genesis_wasp_spawn_logic(favorite_enemy);
}

zm_genesis_wasp_spawn_logic(favorite_enemy)
{
	if (!GetDvarInt("zm_wasp_open_spawning", 0)) {
		wasp_locs = level.zm_loc_types["wasp_location"];
		if (wasp_locs.size == 0) {
			[[@zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::create_global_wasp_spawn_locations_list]]();
			return [[@zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::wasp_find_closest_in_global_pool]](favorite_enemy);
		}
		if (IsDefined(level.old_wasp_spawn)) {
			dist_squared = DistanceSquared(level.old_wasp_spawn.origin, favorite_enemy.origin);
			if (dist_squared > 160000 && dist_squared < 360000) {
				return level.old_wasp_spawn;
			}
		}
		foreach (loc in wasp_locs) {
			dist_squared = DistanceSquared(loc.origin, favorite_enemy.origin);
			if (dist_squared > 160000 && dist_squared < 360000) {
				level.old_wasp_spawn = loc;
				return loc;
			}
		}
	}
	switch (level.players.size) {
		case 4: {
			spawn_dist_max = 600;
			break;
		}
		case 3: {
			spawn_dist_max = 700;
			break;
		}
		case 2: {
			spawn_dist_max = 900;
			break;
		}
		case 1:
		default: {
			spawn_dist_max = 1200;
			break;
		}
	}
	queryresult = PositionQuery_Source_Navigation(favorite_enemy.origin + (0, 0, SRandomIntRange("zm_genesis_wasp_spawn_logic", 40, 100)), 300, spawn_dist_max, 10, 10, "navvolume_small");
	a_points = SArrayRandomize(queryresult.data, "zm_genesis_wasp_spawn_logic");
	foreach (point in a_points) {
		if (BulletTracePassed(point.origin, favorite_enemy.origin, 0, favorite_enemy)) {
			level.old_wasp_spawn = point;
			return point;
		}
	}
	return a_points[0];
}

detour zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::spawn_wasp(var_6237035c, var_eecf48f9)
{
	b_swarm_spawned = 0;
	while (!b_swarm_spawned) {
		if (IS_TRUE(var_6237035c)) {
			while (![[@zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::ready_to_spawn_wasp]]()) {
				wait 1;
			}
		}
		spawn_point = undefined;
		while (!IsDefined(spawn_point))
		{
			favorite_enemy = [[@zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::get_favorite_enemy]]();
			spawn_enemy = favorite_enemy;
			if (!IsDefined(spawn_enemy)) {
				spawn_enemy = GetPlayers()[0];
			}
			if (IsDefined(level.wasp_spawn_func)) {
				spawn_point = [[level.wasp_spawn_func]](spawn_enemy);
			}
			else {
				spawn_point = zm_genesis_wasp_spawn_logic(spawn_enemy);
			}
			if (!IsDefined(spawn_point)) {
				wait SRandomFloatRange("zm_genesis_wasp_spawn", 0.6666666, 1.333333);
			}
		}
		v_spawn_origin = spawn_point.origin;
		v_ground = BulletTrace(spawn_point.origin + VectorScale((0, 0, 1), 60), (spawn_point.origin + VectorScale((0, 0, 1), 60)) + (VectorScale((0, 0, -1), 100000)), 0, undefined)["position"];
		if (DistanceSquared(v_ground, spawn_point.origin) < 3600) {
			v_spawn_origin = v_ground + VectorScale((0, 0, 1), 60);
		}
		queryresult = PositionQuery_Source_Navigation(v_spawn_origin, 0, 80, 80, 15, "navvolume_small");
		a_points = SArrayRandomize(queryresult.data, "zm_genesis_wasp_spawn");
		a_spawn_origins = [];
		n_points_found = 0;
		foreach (point in a_points) {
			if (BulletTracePassed(point.origin, spawn_point.origin, 0, spawn_enemy)) {
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
		if (a_spawn_origins.size >= 1) {
			n_spawn = 0;
			while (n_spawn < 1 && level.zombie_total > 0) {
				for (i = a_spawn_origins.size - 1; i >= 0; i--) {
					v_origin = a_spawn_origins[i];
					if (IS_TRUE(var_eecf48f9)) {
						sp_wasp = level.var_c200ab6[0];
					}
					else {
						sp_wasp = level.wasp_spawners[0];
					}
					sp_wasp.origin = v_origin;
					ai = zombie_utility::spawn_zombie(sp_wasp);
					if (IsDefined(ai)) {
						ai [[@parasite<scripts\shared\vehicles\_parasite.gsc>::set_parasite_enemy]](favorite_enemy);
						level thread [[@zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::wasp_spawn_init]](ai, v_origin);
						ArrayRemoveIndex(a_spawn_origins, i);
						if (IsDefined(level.zm_wasp_spawn_callback)) {
							ai thread [[level.zm_wasp_spawn_callback]]();
						}
						ai.ignore_nuke = 1;
						ai.heroweapon_kill_power = 2;
						n_spawn++;
						level.zombie_total--;
						wait SRandomFloatRange("zm_genesis_wasp_spawn", 0.06666666, 0.1333333);
						if (IsDefined(ai)) {
							ai.ignore_nuke = undefined;
						}
						break;
					}
					wait SRandomFloatRange("zm_genesis_wasp_spawn", 0.06666666, 0.1333333);
				}
			}
			b_swarm_spawned = 1;
		}
		util::wait_network_frame();
	}
}