detour zm_genesis_zombie<scripts\zm\zm_genesis_zombie.gsc>::set_gravity(gravity)
{
	if (gravity == "low") {
		self.low_gravity = 1;
		if (IS_TRUE(self.missinglegs)) {
			self.low_gravity_variant = SRandomInt("zm_genesis_zombie_gravity", level.var_4fb25bb9["crawl"]);
		}
		else {
			self.low_gravity_variant = SRandomInt("zm_genesis_zombie_gravity", level.var_4fb25bb9[self.zombie_move_speed]);
		}
	}
	else if (gravity == "normal") {
		self.low_gravity = 0;
	}
}

detour zm_genesis_zombie<scripts\zm\zm_genesis_zombie.gsc>::genesis_custom_spawn_location_selection(a_spots)
{
	if (SCoinToss("zm_genesis_zombie_spawn_location")) {
		if (!IsDefined(level.n_player_spawn_selection_index)) {
			level.n_player_spawn_selection_index = 0;
		}
		e_player = level.players[level.n_player_spawn_selection_index];
		level.n_player_spawn_selection_index++;
		if (level.n_player_spawn_selection_index > (level.players.size - 1)) {
			level.n_player_spawn_selection_index = 0;
		}
		if (!zm_utility::is_player_valid(e_player)) {
			s_spot = SArrayRandom(a_spots, "zm_genesis_zombie_spawn_location");
			return s_spot;
		}
		var_e8c67fc0 = array::get_all_closest(e_player.origin, a_spots, undefined, 5);
		var_b008ef9a = [];
		v_player_dir = AnglesToForward(e_player.angles);
		for (i = 0; i < var_e8c67fc0.size; i++) {
			v_dir = var_e8c67fc0[i].origin - e_player.origin;
			n_dp = VectorDot(v_player_dir, v_dir);
			if (n_dp >= 0) {
				var_b008ef9a[var_b008ef9a.size] = var_e8c67fc0[i];
			}
		}
		if (var_b008ef9a.size) {
			s_spot = SArrayRandom(var_b008ef9a, "zm_genesis_zombie_spawn_location");
		}
		else if (var_e8c67fc0.size) {
			s_spot = SArrayRandom(var_e8c67fc0, "zm_genesis_zombie_spawn_location");
		}
		else {
			s_spot = SArrayRandom(a_spots, "zm_genesis_zombie_spawn_location");
		}
	}
	else {
		s_spot = SArrayRandom(a_spots, "zm_genesis_zombie_spawn_location");
	}
	return s_spot;
}