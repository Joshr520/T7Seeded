detour zm_island<scripts\zm\zm_island.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_island<scripts\zm\zm_island.gsc>::check_player_available()
{
	self endon("death");
	while (IS_TRUE(self.b_zombie_path_bad)) {
		wait SRandomFloatRange("zm_castle_bad_path", 0.2, 0.5);
		if (self [[@zm_island<scripts\zm\zm_island.gsc>::can_zombie_see_any_player]]()) {
			self.b_zombie_path_bad = undefined;
			self notify("reaquire_player");
			return;
		}
	}
}

detour zm_island<scripts\zm\zm_island.gsc>::assign_lowest_unused_character_index()
{
	charindexarray = [];
	charindexarray[0] = 0;
	charindexarray[1] = 1;
	charindexarray[2] = 2;
	charindexarray[3] = 3;
	a_players = GetPlayers();
	if (a_players.size == 1) {
		charindexarray = SArrayRandomize(charindexarray, "character");
		if (charindexarray[0] == 2) {
			level.var_c7ffdf5 = 1;
		}
		return charindexarray[0];
	}
	n_characters_defined = 0;
	foreach (player in a_players) {
		if (IsDefined(player.characterindex)) {
			ArrayRemoveValue(charindexarray, player.characterindex, 0);
			n_characters_defined++;
		}
	}
	if (charindexarray.size > 0) {
		if (n_characters_defined == (a_players.size - 1)) {
			if (!IS_TRUE(level.var_c7ffdf5)) {
				level.var_c7ffdf5 = 1;
				return 2;
			}
		}
		charindexarray = SArrayRandomize(charindexarray, "character");
		if (charindexarray[0] == 2) {
			level.var_c7ffdf5 = 1;
		}
		return charindexarray[0];
	}
	return 0;
}

detour zm_island<scripts\zm\zm_island.gsc>::placed_powerups()
{
	array::thread_all(GetEntArray("power_up_web", "targetname"), @zm_island<scripts\zm\zm_island.gsc>::function_726351cf);
	zm_powerups::powerup_round_start();
	a_bonus_types = [];
	array::add(a_bonus_types, "double_points");
	array::add(a_bonus_types, "insta_kill");
	array::add(a_bonus_types, "full_ammo");
	a_bonus = struct::get_array("placed_powerup", "targetname");
	foreach (s_bonus in a_bonus) {
		str_type = SArrayRandom(a_bonus_types, "zm_island_infinite_powerups");
		[[@zm_island<scripts\zm\zm_island.gsc>::spawn_infinite_powerup_drop]](s_bonus.origin, str_type);
	}
}