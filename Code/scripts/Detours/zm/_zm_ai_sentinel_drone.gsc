detour zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_e38b964d()
{
	level.var_a78effc7 = SRandomIntRange("zm_ai_sentinel_drone_round", 9, 12);
	old_spawn_func = level.round_spawn_func;
	old_wait_func = level.round_wait_func;
	for (;;) {
		level waittill("between_round_over");
		if (level.round_number == level.var_a78effc7) {
			level.sndmusicspecialround = 1;
			old_spawn_func = level.round_spawn_func;
			old_wait_func = level.round_wait_func;
			[[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_71f8e359]]();
			level.round_spawn_func = @zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_7766fb04;
			level.round_wait_func = @zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_989acb59;
			if (IsDefined(level.var_a1ca5313)) {
				level.var_a78effc7 = [[level.var_a1ca5313]]();
			}
			else {
				level.var_a78effc7 = level.var_a78effc7 + SRandomIntRange("zm_ai_sentinel_drone_round", 7, 10);
			}
		}
		else if (level flag::get("sentinel_round")) {
			[[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_5cf4e163]]();
			level.round_spawn_func = old_spawn_func;
			level.round_wait_func = old_wait_func;
		}
	}
}

detour zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_f9c9e7e0()
{
	return function_f9c9e7e0();
}

function_f9c9e7e0()
{
	a_s_spawn_locs = [];
	s_spawn_loc = undefined;
	foreach (s_zone in level.zones) {
		if (s_zone.is_enabled && IsDefined(s_zone.a_loc_types["sentinel_location"]) && s_zone.a_loc_types["sentinel_location"].size) {
			foreach (s_loc in s_zone.a_loc_types["sentinel_location"]) {
				foreach (player in level.activeplayers) {
					n_dist_sq = DistanceSquared(player.origin, s_loc.origin);
					if (n_dist_sq > 65536 && n_dist_sq < 2250000) {
						if (!IsDefined(a_s_spawn_locs)) {
							a_s_spawn_locs = [];
						}
						else if (!IsArray(a_s_spawn_locs)) {
							a_s_spawn_locs = array(a_s_spawn_locs);
						}
						a_s_spawn_locs[a_s_spawn_locs.size] = s_loc;
						break;
					}
				}
			}
		}
	}
	s_spawn_loc = SArrayRandom(a_s_spawn_locs, "zm_ai_sentinel_drone_spawn_location");
	if (!IsDefined(s_spawn_loc)) {
		s_spawn_loc = SArrayRandom(level.zm_loc_types["sentinel_location"], "zm_ai_sentinel_drone_spawn_location");
	}
	return s_spawn_loc;
}

detour zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_d600cb9a()
{
	self endon(#"hash_d600cb9a");
	self endon("death");
	self thread [[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_caadf4b1]]();
	self flag::wait_till("completed_spawning");
	var_4b9c276c = [[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_5b91ab3a]]();
	for (;;) {
		level flag::wait_till_clear("sentinel_rez_in_progress");
		while (zombie_utility::get_current_zombie_count() >= var_4b9c276c)
		{
			wait 0.1;
		}
		if (zombie_utility::get_current_actor_count() >= level.zombie_actor_limit) {
			zombie_utility::clear_all_corpses();
			wait 0.1;
			continue;
		}
		v_spawn_pos = undefined;
		if (IS_TRUE(self.var_98bec529)) {
			query_result = PositionQuery_Source_Navigation(self.origin, 16, 768, 200, 40, 32);
			if (query_result.data.size) {
				a_s_locs = SArrayRandomize(query_result.data, "zm_ai_sentinel_drone_navigate");
				foreach (s_loc in a_s_locs) {
					var_caae2f83 = [[self.check_point_in_enabled_zone]](s_loc.origin, 1);
					if (var_caae2f83) {
						continue;
					}
					var_e31f585b = GetClosestPointOnNavMesh(s_loc.origin, 96, 32);
					if (IsDefined(var_e31f585b)) {
						var_c85c791d = 0;
						foreach (player in level.activeplayers) {
							n_dist_sq = DistanceSquared(self.origin, s_loc.origin);
							if (n_dist_sq < 250000) {
								var_c85c791d = 1;
								break;
							}
						}
						if (var_c85c791d) {
							continue;
						}
						s_spawn_loc = ArrayGetClosest(var_e31f585b, level.exterior_goals);
						if (IsDefined(s_spawn_loc.script_string)) {
							level.var_a657e360.script_string = s_spawn_loc.script_string;
						}
						a_ground_trace = GroundTrace(var_e31f585b + VectorScale((0, 0, 1), 64), var_e31f585b + (VectorScale((0, 0, -1), 128)), 0, undefined);
						v_spawn_pos = a_ground_trace["position"];
						break;
					}
				}
			}
		}
		else {
			player = zombie_utility::get_closest_valid_player(self.origin);
			if (!IsDefined(player)) {
				wait 3;
				continue;
			}
			query_result = PositionQuery_Source_Navigation(self.origin, 500, 768, 200, 40, 32);
			if (query_result.data.size) {
				a_s_locs = SArrayRandomize(query_result.data, "zm_ai_sentinel_drone_navigate");
				foreach (s_loc in a_s_locs) {
					var_caae2f83 = [[self.check_point_in_enabled_zone]](s_loc.origin, 1);
					if (var_caae2f83) {
						var_c85c791d = 0;
						foreach (player in level.activeplayers) {
							n_dist_sq = DistanceSquared(self.origin, s_loc.origin);
							if (n_dist_sq < 250000) {
								var_c85c791d = 1;
								break;
							}
						}
						if (var_c85c791d) {
							continue;
						}
						level.var_a657e360.script_string = "find_flesh";
						v_spawn_pos = s_loc.origin;
						break;
					}
				}
			}
		}
		if (IsDefined(v_spawn_pos)) {
			if (level flag::get("sentinel_rez_in_progress")) {
				return;
			}
			level flag::set("sentinel_rez_in_progress");
			self.var_7e04bb3 = 1;
			self thread [[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_b7a02494]]();
			self [[@sentinel_drone<scripts\shared\vehicles\_sentinel_drone.gsc>::sentinel_forcegoandstayinposition]](1, v_spawn_pos + VectorScale((0, 0, 1), 106));
			self waittill("goal");
			level.var_a657e360.origin = v_spawn_pos + VectorScale((0, 0, 1), 8);
			level.var_a657e360.angles = self.angles;
			self clientfield::set("necro_sentinel_fx", 1);
			self [[@zm_ai_sentinel_drone<scripts\zm\_zm_ai_sentinel_drone.gsc>::function_1a7787ed]]();
			self clientfield::set("necro_sentinel_fx", 0);
			self [[@sentinel_drone<scripts\shared\vehicles\_sentinel_drone.gsc>::sentinel_forcegoandstayinposition]](0);
			wait 5;
			self.var_7e04bb3 = 0;
			level flag::clear("sentinel_rez_in_progress");
		}
		wait 1;
	}
}