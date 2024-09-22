detour zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::recapture_round_tracker()
{
	n_next_recapture_round = 10;
	for (;;) {
		level util::waittill_any("between_round_over", "force_recapture_start");
		if (level.round_number >= n_next_recapture_round && !level flag::get("zone_capture_in_progress") && [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_captured_zone_count]]() >= [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_player_controlled_zone_count_for_recapture]]()) {
			n_next_recapture_round = level.round_number + SRandomIntRange("zm_tomb_capture_zones_round", 3, 6);
			level thread [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::recapture_round_start]]();
		}
	}
}

detour zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_zombie_to_delete()
{
	ai_zombie = undefined;
	a_zombies = zombie_utility::get_round_enemy_array();
	if (a_zombies.size > 0) {
		ai_zombie = SArrayRandom(a_zombies, "zm_tomb_capture_zones_delete");
	}
	return ai_zombie;
}

detour zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_unused_emergence_hole_spawn_point()
{
	a_valid_spawn_points = [];
	b_all_points_used = 0;
	while (!a_valid_spawn_points.size) {
		foreach (s_emergence_hole in self.a_emergence_hole_structs) {
			if (!IsDefined(s_emergence_hole.spawned_zombie) || b_all_points_used) {
				s_emergence_hole.spawned_zombie = 0;
			}
			if (!s_emergence_hole.spawned_zombie) {
				if (!IsDefined(a_valid_spawn_points)) {
					a_valid_spawn_points = [];
				}
				else if (!IsArray(a_valid_spawn_points)) {
					a_valid_spawn_points = array(a_valid_spawn_points);
				}
				a_valid_spawn_points[a_valid_spawn_points.size] = s_emergence_hole;
			}
		}
		if (!a_valid_spawn_points.size) {
			b_all_points_used = 1;
		}
	}
	s_spawn_point = SArrayRandom(a_valid_spawn_points, "zm_tomb_capture_zones_spawn");
	return s_spawn_point;
}

detour zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_unclaimed_attack_point(s_zone)
{
	s_zone [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::clean_up_unused_attack_points]]();
	n_claimed_center = s_zone [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_claimed_attack_points_between_indicies]](0, 3);
	n_claimed_left = s_zone [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_claimed_attack_points_between_indicies]](4, 7);
	n_claimed_right = s_zone [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_claimed_attack_points_between_indicies]](8, 11);
	b_use_center_pillar = n_claimed_center < 3;
	b_use_left_pillar = n_claimed_left < 1;
	b_use_right_pillar = n_claimed_right < 1;
	if (b_use_center_pillar) {
		a_valid_attack_points = s_zone [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_unclaimed_attack_points_between_indicies]](0, 3);
	}
	else if (b_use_left_pillar) {
		a_valid_attack_points = s_zone [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_unclaimed_attack_points_between_indicies]](4, 7);
	}
	else if (b_use_right_pillar) {
		a_valid_attack_points = s_zone [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_unclaimed_attack_points_between_indicies]](8, 11);
	}
	else {
		a_valid_attack_points = s_zone [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_unclaimed_attack_points_between_indicies]](0, 11);
	}
	if (a_valid_attack_points.size == 0) {
		a_valid_attack_points = s_zone [[@zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_unclaimed_attack_points_between_indicies]](0, 11);
	}
	s_attack_point = SArrayRandom(a_valid_attack_points, "zm_tomb_capture_zones_attack_point");
	s_attack_point.is_claimed = 1;
	s_attack_point.claimed_by = self;
	return s_attack_point;
}

detour zm_tomb_capture_zones<scripts\zm\zm_tomb_capture_zones.gsc>::get_recapture_zone(s_last_recapture_zone)
{
	a_s_player_zones = [];
	foreach (str_key, s_zone in level.zone_capture.zones) {
		if (s_zone flag::get("player_controlled")) {
			a_s_player_zones[str_key] = s_zone;
		}
	}
	s_recapture_zone = undefined;
	if (a_s_player_zones.size) {
		if (IsDefined(s_last_recapture_zone)) {
			n_distance_closest = undefined;
			foreach (s_zone in a_s_player_zones) {
				n_distance = DistanceSquared(s_zone.origin, s_last_recapture_zone.origin);
				if (!IsDefined(n_distance_closest) || n_distance < n_distance_closest) {
					s_recapture_zone = s_zone;
					n_distance_closest = n_distance;
				}
			}
		}
		else {
			s_recapture_zone = SArrayRandom(a_s_player_zones, "zm_tomb_capture_zones_get_gen");
		}
	}
	return s_recapture_zone;
}