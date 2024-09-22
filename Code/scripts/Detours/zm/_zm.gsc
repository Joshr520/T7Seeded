detour zm<scripts\zm\_zm.gsc>::getfreespawnpoint(spawnpoints, player)
{
	if (!IsDefined(spawnpoints)) {
		return undefined;
	}
	if (!IsDefined(game["spawns_randomized"])) {
		game["spawns_randomized"] = 1;
		spawnpoints = SArrayRandomize(spawnpoints, "player_spawn");
		random_chance = SRandomInt("player_spawn", 100);
		if (random_chance > 50)
		{
			zm_utility::set_game_var("side_selection", 1);
		}
		else
		{
			zm_utility::set_game_var("side_selection", 2);
		}
	}
	side_selection = zm_utility::get_game_var("side_selection");
	if (zm_utility::get_game_var("switchedsides")) {
		if (side_selection == 2) {
			side_selection = 1;
		}
		else if (side_selection == 1) {
			side_selection = 2;
		}
	}
	if (IsDefined(player) && IsDefined(player.team)) {
		i = 0;
		while (IsDefined(spawnpoints) && i < spawnpoints.size) {
			if (side_selection == 1) {
				if (player.team != "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 1)) {
					ArrayRemoveValue(spawnpoints, spawnpoints[i]);
					i = 0;
				}
				else if (player.team == "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 2)) {
                    ArrayRemoveValue(spawnpoints, spawnpoints[i]);
                    i = 0;
                }
                else {
                    i++;
                }
			}
			else if (player.team == "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 1)) {
                ArrayRemoveValue(spawnpoints, spawnpoints[i]);
                i = 0;
            }
            else if (player.team != "allies" && (IsDefined(spawnpoints[i].script_int) && spawnpoints[i].script_int == 2)) {
                ArrayRemoveValue(spawnpoints, spawnpoints[i]);
                i = 0;
            }
            else {
                i++;
            }
		}
	}
	zm::updateplayernum(player);
	for (j = 0; j < spawnpoints.size; j++) {
		if (!IsDefined(spawnpoints[j].en_num)) {
			for (m = 0; m < spawnpoints.size; m++) {
				spawnpoints[m].en_num = m;
			}
		}
		if (spawnpoints[j].en_num == player.playernum) {
			return spawnpoints[j];
		}
	}
	return spawnpoints[0];
}

detour zm<scripts\zm\_zm.gsc>::laststand_giveback_player_perks()
{
	if (IsDefined(self.laststand_perks)) {
		lost_perk_index = -1;
		if (self.laststand_perks.size > 1) {
			lost_perk_index = SRandomInt("zm_laststand_perk", self.laststand_perks.size - 1);
		}
		for (i = 0; i < self.laststand_perks.size; i++) {
			if (self HasPerk(self.laststand_perks[i])) {
				continue;
			}
			if (i == lost_perk_index) {
				continue;
			}
			zm_perks::give_perk(self.laststand_perks[i]);
		}
	}
}

detour zm<scripts\zm\_zm.gsc>::round_spawning()
{
	level endon("intermission");
	level endon("end_of_round");
	level endon("restart_round");
	if (level.intermission) {
		return;
	}
	if (zm::cheat_enabled(2)) {
		return;
	}
	if (level.zm_loc_types["zombie_location"].size < 1)
	{
		return;
	}
	zombie_utility::ai_calculate_health(level.round_number);
	count = 0;
	players = GetPlayers();
	for (i = 0; i < players.size; i++) {
		players[i].zombification_time = 0;
	}
	if (!(IsDefined(level.kill_counter_hud) && level.zombie_total > 0)) {
		level.zombie_total = zm::get_zombie_count_for_round(level.round_number, level.players.size);
		level.zombie_respawns = 0;
		level notify("zombie_total_set");
	}
	if (IsDefined(level.zombie_total_set_func)) {
		level thread [[level.zombie_total_set_func]]();
	}
	if (level.round_number < 10 || level.speed_change_max > 0) {
		level thread zombie_utility::zombie_speed_up();
	}
	old_spawn = undefined;
	for (;;) {
		while (zombie_utility::get_current_zombie_count() >= level.zombie_ai_limit || level.zombie_total <= 0) {
			wait 0.1;
		}
		while (zombie_utility::get_current_actor_count() >= level.zombie_actor_limit) {
			zombie_utility::clear_all_corpses();
			wait 0.1;
		}
		if (flag::exists("world_is_paused")) {
			level flag::wait_till_clear("world_is_paused");
		}
		level flag::wait_till("spawn_zombies");
		while (level.zm_loc_types["zombie_location"].size <= 0) {
			wait 0.1;
		}
		zm::run_custom_ai_spawn_checks();
		if (IS_TRUE(level.hostmigrationtimer)) {
			util::wait_network_frame();
			continue;
		}
		if (IsDefined(level.fn_custom_round_ai_spawn)) {
			if ([[level.fn_custom_round_ai_spawn]]())
			{
				util::wait_network_frame();
				continue;
			}
		}
		if (IsDefined(level.zombie_spawners)) {
			if (IsDefined(level.fn_custom_zombie_spawner_selection)) {
				spawner = [[level.fn_custom_zombie_spawner_selection]]();
			}
			else {
				str_seed = level.zombie_respawns > 0 ? "zm_respawn_location" : "zm_spawn_location";
				if (IS_TRUE(level.use_multiple_spawns) && level.use_multiple_spawns) {
					if (IsDefined(level.spawner_int) && (IsDefined(level.zombie_spawn[level.spawner_int].size) && level.zombie_spawn[level.spawner_int].size)) {
						spawner = SArrayRandom(level.zombie_spawn[level.spawner_int], str_seed);
					}
					else {
						spawner = SArrayRandom(level.zombie_spawners, str_seed);
					}
				}
				else {
					spawner = SArrayRandom(level.zombie_spawners, str_seed);
				}
			}
			ai = zombie_utility::spawn_zombie(spawner, spawner.targetname);
		}
		if (IsDefined(ai)) {
			level.zombie_total--;
			if (level.zombie_respawns > 0) {
				level.zombie_respawns--;
			}
			ai thread zombie_utility::round_spawn_failsafe();
			count++;
			if (ai ai::has_behavior_attribute("can_juke")) {
				ai ai::set_behavior_attribute("can_juke", 0);
			}
			if (level.zombie_respawns > 0) {
				wait 0.1;
			}
			else {
				wait level.zombie_vars["zombie_spawn_delay"];
			}
		}
		util::wait_network_frame();
	}
}

detour zm<scripts\zm\_zm.gsc>::default_find_exit_point()
{
	self endon("death");
	player = getplayers()[0];
	dist_zombie = 0;
	dist_player = 0;
	dest = 0;
	away = vectornormalize(self.origin - player.origin);
	endpos = self.origin + vectorscale(away, 600);
	if (IsDefined(level.zm_loc_types["wait_location"]) && level.zm_loc_types["wait_location"].size > 0) {
		locs = SArrayRandomize(level.zm_loc_types["wait_location"], "zm_exit_point");
	}
	else {
		locs = SArrayRandomize(level.zm_loc_types["dog_location"], "zm_exit_point");
	}
	for (i = 0; i < locs.size; i++) {
		dist_zombie = DistanceSquared(locs[i].origin, endpos);
		dist_player = DistanceSquared(locs[i].origin, player.origin);
		if (dist_zombie < dist_player) {
			dest = i;
			break;
		}
	}
	self notify("stop_find_flesh");
	self notify("zombie_acquire_enemy");
	if (IsDefined(locs[dest])) {
		self SetGoal(locs[dest].origin);
	}
	for (;;) {
		b_passed_override = 1;
		if (IsDefined(level.default_find_exit_position_override)) {
			b_passed_override = [[level.default_find_exit_position_override]]();
		}
		if (!level flag::get("wait_and_revive") && b_passed_override) {
			break;
		}
		wait 0.1;
	}
}