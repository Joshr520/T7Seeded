detour zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::special_wasp_spawn(n_to_spawn = 1, spawn_point, n_radius = 32, n_half_height = 32, b_non_round, spawn_fx = 1, b_return_ai = 0, spawner_override = undefined)
{
	wasp = GetEntArray("zombie_wasp", "targetname");
	if (IsDefined(wasp) && wasp.size >= 9) {
		return 0;
	}
	count = 0;
	while (count < n_to_spawn) {
		players = GetPlayers();
		favorite_enemy = [[@zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::get_favorite_enemy]]();
		spawn_enemy = favorite_enemy;
		if (!IsDefined(spawn_enemy)) {
			spawn_enemy = players[0];
		}
		if (IsDefined(level.wasp_spawn_func)) {
			spawn_point = [[level.wasp_spawn_func]](spawn_enemy);
		}
		while (!IsDefined(spawn_point)) {
			if (!IsDefined(spawn_point)) {
				spawn_point = zm_zod_wasp_spawn_logic(spawn_enemy);
			}
			if (IsDefined(spawn_point)) {
				break;
			}
			wait 0.05;
		}
		spawner = level.wasp_spawners[0];
		if (IsDefined(spawner_override)) {
			spawner = spawner_override;
		}
		ai = zombie_utility::spawn_zombie(spawner);
		v_spawn_origin = spawn_point.origin;
		if (IsDefined(ai)) {
			queryresult = PositionQuery_Source_Navigation(v_spawn_origin, 0, n_radius, n_half_height, 15, "navvolume_small");
			if (queryresult.data.size)
			{
				point = queryresult.data[SRandomInt("zm_ai_wasp_special_spawn", queryresult.data.size)];
				v_spawn_origin = point.origin;
			}
			ai [[@parasite<scripts\shared\vehicles\_parasite.gsc>::set_parasite_enemy]](favorite_enemy);
			ai.does_not_count_to_round = b_non_round;
			level thread [[@zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::wasp_spawn_init]](ai, v_spawn_origin, spawn_fx);
			count++;
		}
		wait level.zombie_vars["zombie_spawn_delay"];
	}
	if (b_return_ai) {
		return ai;
	}
	return 1;
}

detour zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::wasp_round_tracker()
{
	level.wasp_round_count = 1;
	level.next_wasp_round = level.round_number + SRandomIntRange("zm_ai_wasp_round", 4, 6);
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	for (;;) {
		level waittill("between_round_over");
		if (level.round_number == level.next_wasp_round) {
			level.sndmusicspecialround = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			[[@zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::wasp_round_start]]();
			level.round_spawn_func = @zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::wasp_round_spawning;
			level.round_wait_func = @zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::wasp_round_wait_func;
			if (IsDefined(level.zm_custom_get_next_wasp_round)) {
				level.next_wasp_round = [[level.zm_custom_get_next_wasp_round]]();
			}
			else {
				level.next_wasp_round = (5 + (level.wasp_round_count * 10)) + (SRandomIntRange("zm_ai_wasp_round", -1, 1));
			}
		}
		else if (level flag::get("wasp_round")) {
			[[@zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::wasp_round_stop]]();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
			level.wasp_round_count = level.wasp_round_count + 1;
		}
	}
}

detour zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::spawn_wasp()
{
	b_swarm_spawned = 0;
	while (!b_swarm_spawned) {
		while (![[@zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::ready_to_spawn_wasp]]()) {
			wait 1;
		}
		spawn_point = undefined;
		while (!IsDefined(spawn_point)) {
			favorite_enemy = [[@zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::get_favorite_enemy]]();
			spawn_enemy = favorite_enemy;
			if (!IsDefined(spawn_enemy)) {
				spawn_enemy = GetPlayers()[0];
			}
			if (IsDefined(level.wasp_spawn_func)) {
				spawn_point = [[level.wasp_spawn_func]](spawn_enemy);
			}
			else {
				spawn_point = zm_zod_wasp_spawn_logic(spawn_enemy);
			}
			if (!IsDefined(spawn_point)) {
				wait SRandomFloatRange("zm_ai_wasp_spawn_wasp", 0.6666666, 1.333333);
			}
		}
		v_spawn_origin = spawn_point.origin;
		v_ground = BulletTrace(spawn_point.origin + VectorScale((0, 0, 1), 60), (spawn_point.origin + VectorScale((0, 0, 1), 60)) + (VectorScale((0, 0, -1), 100000)), 0, undefined)["position"];
		if (DistanceSquared(v_ground, spawn_point.origin) < 3600) {
			v_spawn_origin = v_ground + VectorScale((0, 0, 1), 60);
		}
		queryresult = PositionQuery_Source_Navigation(v_spawn_origin, 0, 80, 80, 15, "navvolume_small");
		a_points = SArrayRandomize(queryresult.data, "zm_ai_wasp_spawn_wasp");
		a_spawn_origins = [];
		n_points_found = 0;
		foreach (point in a_points) {
			if (BulletTracePassed(point.origin, spawn_point.origin, 0, spawn_enemy)) {
				if (!IsDefined(a_spawn_origins)) {
					a_spawn_origins = [];
				}
				else if (!IsArray(a_spawn_origins))
				{
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
					level.wasp_spawners[0].origin = v_origin;
					ai = zombie_utility::spawn_zombie(level.wasp_spawners[0]);
					if (IsDefined(ai)) {
						ai [[@parasite<scripts\shared\vehicles\_parasite.gsc>::set_parasite_enemy]](favorite_enemy);
						level thread [[@zm_ai_wasp<scripts\zm\_zm_ai_wasp_no_idgun.gsc>::wasp_spawn_init]](ai, v_origin);
						ArrayRemoveIndex(a_spawn_origins, i);
						if (IsDefined(level.zm_wasp_spawn_callback)) {
							ai thread [[level.zm_wasp_spawn_callback]]();
						}
						n_spawn++;
						level.zombie_total--;
						wait SRandomFloatRange("zm_ai_wasp_spawn_wasp", 0.06666666, 0.1333333);
						break;
					}
					wait SRandomFloatRange("zm_ai_wasp_spawn_wasp", 0.06666666, 0.1333333);
				}
			}
			b_swarm_spawned = 1;
		}
		util::wait_network_frame();
	}
}