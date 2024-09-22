detour zm_factory<scripts\zm\zm_factory.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_factory<scripts\zm\zm_factory.gsc>::powerup_special_drop_override()
{
	if (level.round_number <= 10) {
		powerup = zm_powerups::get_valid_powerup();
	}
	else {
		powerup = level.zombie_special_drop_array[SRandomInt("zm_factory_special_powerup", level.zombie_special_drop_array.size)];
		if (level.round_number > 15 && SRandomInt("zm_factory_special_powerup", 100) < ((level.round_number - 15) * 5)) {
			powerup = "nothing";
		}
	}
	switch (powerup) {
		case "full_ammo": {
			if (level.round_number > 10 && SRandomInt("zm_factory_special_powerup", 100) < ((level.round_number - 10) * 5)) {
				powerup = level.zombie_powerup_array[SRandomInt("zm_factory_special_powerup", level.zombie_powerup_array.size)];
			}
			break;
		}
		case "dog": {
			if (level.round_number >= 15) {
				dog_spawners = GetEntArray("special_dog_spawner", "targetname");
				thread zm_utility::play_sound_2d("vox_sam_nospawn");
				powerup = undefined;
			}
			else {
				powerup = zm_powerups::get_valid_powerup();
			}
			break;
		}
		case "free_perk":
		case "nothing": {
			if (IsDefined(level._zombiemode_special_drop_setup)) {
				is_powerup = [[level._zombiemode_special_drop_setup]](powerup);
			}
			else {
				PlayFX(level._effect["lightning_dog_spawn"], self.origin);
				PlaySoundAtPosition("zmb_hellhound_prespawn", self.origin);
				wait 1.5;
				PlaySoundAtPosition("zmb_hellhound_bolt", self.origin);
				Earthquake(0.5, 0.75, self.origin, 1000);
				PlaySoundAtPosition("zmb_hellhound_spawn", self.origin);
				wait 1;
				thread zm_utility::play_sound_2d("vox_sam_nospawn");
				self Delete();
			}
			powerup = undefined;
			break;
		}
	}
	return powerup;
}

detour zm_factory<scripts\zm\zm_factory.gsc>::function_33aa4940()
{
	var_88369d66 = 0;
	if (level.round_number > 30) {
		if (SRandomFloat("zm_factory_custom_spawn", 100) < 4) {
			var_88369d66 = 1;
		}
	}
	else if (level.round_number > 25) {
		if (SRandomFloat("zm_factory_custom_spawn", 100) < 3) {
			var_88369d66 = 1;
		}
	}
	else if (level.round_number > 20) {
		if (SRandomFloat("zm_factory_custom_spawn", 100) < 2) {
			var_88369d66 = 1;
		}
	}
	else if (level.round_number > 15) {
		if (SRandomFloat("zm_factory_custom_spawn", 100) < 1) {
			var_88369d66 = 1;
		}
	}
	if (var_88369d66) {
		special_dog_spawn(1);
		level.zombie_total--;
	}
	return var_88369d66;
}

detour zm_factory<scripts\zm\zm_factory.gsc>::assign_lowest_unused_character_index()
{
	charindexarray = [];
	charindexarray[0] = 0;
	charindexarray[1] = 1;
	charindexarray[2] = 2;
	charindexarray[3] = 3;
	players = GetPlayers();
	if (players.size == 1) {
		charindexarray = SArrayRandomize(charindexarray, "character");
		if (charindexarray[0] == 2) {
			level.has_richtofen = 1;
		}
		return charindexarray[0];
	}
	n_characters_defined = 0;
	foreach (player in players) {
		if (IsDefined(player.characterindex)) {
			ArrayRemoveValue(charindexarray, player.characterindex, 0);
			n_characters_defined++;
		}
	}
	if (charindexarray.size > 0) {
		if (n_characters_defined == (players.size - 1)) {
			if (!IS_TRUE(level.has_richtofen)) {
				level.has_richtofen = 1;
				return 2;
			}
		}
		charindexarray = SArrayRandomize(charindexarray, "character");
		if (charindexarray[0] == 2) {
			level.has_richtofen = 1;
		}
		return charindexarray[0];
	}
	return 0;
}

detour zm_factory<scripts\zm\zm_factory.gsc>::no_target_override(zombie)
{
	if (IsDefined(zombie.has_exit_point)) {
		return;
	}
	players = level.players;
	dist_zombie = 0;
	dist_player = 0;
	dest = 0;
	if (IsDefined(level.zm_loc_types["dog_location"])) {
		locs = SArrayRandomize(level.zm_loc_types["dog_location"], "zm_factory_no_target");
		for (i = 0; i < locs.size; i++) {
			found_point = 0;
			foreach (player in players) {
				if (player laststand::player_is_in_laststand()) {
					continue;
				}
				away = VectorNormalize(self.origin - player.origin);
				endpos = self.origin + VectorScale(away, 600);
				dist_zombie = DistanceSquared(locs[i].origin, endpos);
				dist_player = DistanceSquared(locs[i].origin, player.origin);
				if (dist_zombie < dist_player) {
					dest = i;
					found_point = 1;
					continue;
				}
				found_point = 0;
			}
			if (found_point) {
				if (zombie [[@zm_factory<scripts\zm\zm_factory.gsc>::validate_and_set_no_target_position]](locs[i])) {
					return;
				}
			}
		}
	}
	escape_position = zombie [[@factory_cleanup<scripts\zm\zm_factory_cleanup_mgr.gsc>::get_escape_position_in_current_zone]]();
	if (zombie [[@zm_factory<scripts\zm\zm_factory.gsc>::validate_and_set_no_target_position]](escape_position)) {
		return;
	}
	escape_position = zombie [[@factory_cleanup<scripts\zm\zm_factory_cleanup_mgr.gsc>::get_escape_position]]();
	if (zombie [[@zm_factory<scripts\zm\zm_factory.gsc>::validate_and_set_no_target_position]](escape_position)) {
		return;
	}
	zombie.has_exit_point = 1;
	zombie SetGoal(zombie.origin);
}

detour zm_factory<scripts\zm\zm_factory.gsc>::factory_find_exit_point()
{
	self endon("death");
	player = GetPlayers()[0];
	dist_zombie = 0;
	dist_player = 0;
	dest = 0;
	away = VectorNormalize(self.origin - player.origin);
	endpos = self.origin + VectorScale(away, 600);
	locs = SArrayRandomize(level.zm_loc_types["dog_location"], "zm_factory_find_exit");
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
	self SetGoal(locs[dest].origin);
	for (;;) {
		if (!level flag::get("wait_and_revive")) {
			break;
		}
		util::wait_network_frame();
	}
}

detour zm_factory<scripts\zm\zm_factory.gsc>::getrandomnotrichtofen()
{
	array = level.players;
	SArrayRandomize(array, "zm_factory_character");
	foreach (guy in array) {
		if (guy.characterindex != 2) {
			return guy;
		}
	}
	return undefined;
}

detour zm_factory<scripts\zm\zm_factory.gsc>::factory_custom_spawn_location_selection(a_spots)
{
	if (level.zombie_respawns > 0) {
		if (!IsDefined(level.n_player_spawn_selection_index)) {
			level.n_player_spawn_selection_index = 0;
		}
		a_players = GetPlayers();
		level.n_player_spawn_selection_index++;
		if (level.n_player_spawn_selection_index >= a_players.size) {
			level.n_player_spawn_selection_index = 0;
		}
		e_player = a_players[level.n_player_spawn_selection_index];
		ArraySortClosest(a_spots, e_player.origin);
		a_candidates = [];
		v_player_dir = AnglesToForward(e_player.angles);
		for (i = 0; i < a_spots.size; i++) {
			v_dir = a_spots[i].origin - e_player.origin;
			dp = VectorDot(v_player_dir, v_dir);
			if (dp >= 0) {
				a_candidates[a_candidates.size] = a_spots[i];
				if (a_candidates.size > 10) {
					break;
				}
			}
		}
		if (a_candidates.size) {
			s_spot = SArrayRandom(a_candidates, "zm_factory_respawn");
		}
		else {
			s_spot = SArrayRandom(a_spots, "zm_factory_respawn");
		}
	}
	else {
		s_spot = SArrayRandom(a_spots, "zm_factory_respawn");
	}
	return s_spot;
}

detour zm_factory<scripts\zm\zm_factory.gsc>::function_e0f73644()
{
	if (SCoinToss("zm_factory_remove_perk")) {
		level._custom_perks["specialty_staminup"].perk_machine_power_override_thread = @zm_factory<scripts\zm\zm_factory.gsc>::function_384be1c4;
		level._custom_perks["specialty_deadshot"].perk_machine_power_override_thread = @zm_factory<scripts\zm\zm_factory.gsc>::function_49e223a9;
	}
	else {
		level._custom_perks["specialty_deadshot"].perk_machine_power_override_thread = @zm_factory<scripts\zm\zm_factory.gsc>::function_16d38a15;
		level._custom_perks["specialty_staminup"].perk_machine_power_override_thread = @zm_factory<scripts\zm\zm_factory.gsc>::function_6000324c;
	}
}