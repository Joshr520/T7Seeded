detour zm_powerups<scripts\zm\_zm_powerups.gsc>::powerup_drop(drop_point)
{
	if (IsDefined(level.custom_zombie_powerup_drop)) {
		b_outcome = [[level.custom_zombie_powerup_drop]](drop_point);
		if (IS_TRUE(b_outcome)) {
			return;
		}
	}
	if (level.powerup_drop_count >= level.zombie_vars["zombie_powerup_drop_max_per_round"]) {
		return;
	}
	if (!IsDefined(level.zombie_include_powerups) || level.zombie_include_powerups.size == 0) {
		return;
	}
	rand_drop = SRandomInt("zm_powerups_drop", 100);
	if (bgb::is_team_enabled("zm_bgb_power_vacuum") && rand_drop < 20) {
		debug = "zm_bgb_power_vacuum";
	}
	else if (rand_drop > 2) {
        if (!level.zombie_vars["zombie_drop_item"]) {
            return;
        }
        debug = "score";
    }
    else {
        debug = "random";
    }
	playable_area = GetEntArray("player_volume", "script_noteworthy");
	level.powerup_drop_count++;
	powerup = zm_net::network_safe_spawn("powerup", 1, "script_model", drop_point + VectorScale((0, 0, 1), 40));
	valid_drop = 0;
	for (i = 0; i < playable_area.size; i++) {
		if (powerup IsTouching(playable_area[i])) {
			valid_drop = 1;
			break;
		}
	}
	if (valid_drop && level.rare_powerups_active) {
		pos = (drop_point[0], drop_point[1], drop_point[2] + 42);
		if (zm_powerups::check_for_rare_drop_override(pos)) {
			level.zombie_vars["zombie_drop_item"] = 0;
			valid_drop = 0;
		}
	}
	if (!valid_drop) {
		level.powerup_drop_count--;
		powerup Delete();
		return;
	}
	powerup zm_powerups::powerup_setup();
	zm_powerups::print_powerup_drop(powerup.powerup_name, debug);
	powerup thread zm_powerups::powerup_timeout();
	powerup thread zm_powerups::powerup_wobble();
	powerup thread zm_powerups::powerup_grab();
	powerup thread zm_powerups::powerup_move();
	powerup thread zm_powerups::powerup_emp();
	level.zombie_vars["zombie_drop_item"] = 0;
	level notify("powerup_dropped", powerup);
}

detour zm_powerups<scripts\zm\_zm_powerups.gsc>::randomize_powerups()
{
	if (!IsDefined(level.zombie_powerup_array)) {
		level.zombie_powerup_array = [];
	}
	else {
		level.zombie_powerup_array = SArrayRandomize(level.zombie_powerup_array, "zm_powerups_order");
	}
}

detour zm_powerups<scripts\zm\_zm_powerups.gsc>::get_random_powerup_name()
{
	powerup_keys = GetArrayKeys(level.zombie_powerups);
	powerup_keys = SArrayRandomize(powerup_keys, "zm_powerups_name");
	return powerup_keys[0];
}

detour zm_powerups<scripts\zm\_zm_powerups.gsc>::get_regular_random_powerup_name()
{
	powerup_keys = GetArrayKeys(level.zombie_powerups);
	powerup_keys = SArrayRandomize(powerup_keys, "zm_powerups_regular_name");
	for (i = 0; i < powerup_keys.size; i++) {
		if ([[level.zombie_powerups[powerup_keys[i]].func_should_drop_with_regular_powerups]]()) {
			return powerup_keys[i];
		}
	}
	return powerup_keys[0];
}
