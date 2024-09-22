detour zm_tomb_main_quest<scripts\zm\zm_tomb_main_quest.gsc>::dig_spot_get_staff_piece(e_player)
{
	return dig_spot_get_staff_piece(e_player);
}

dig_spot_get_staff_piece(e_player)
{
	level notify("sam_clue_dig", e_player);
	str_zone = self.str_zone;
	foreach (s_staff in level.ice_staff_pieces) {
		if (!IsDefined(s_staff.num_misses)) {
			s_staff.num_misses = 0;
		}
		if (IsSubStr(str_zone, s_staff.zone_substr)) {
			miss_chance = 100 / (s_staff.num_misses + 1);
			if (level.weather_snow <= 0) {
				miss_chance = 101;
			}
			if (SRandomInt("zm_tomb_main_quest_dig_ice", 100) > miss_chance || (s_staff.num_misses > 3 && miss_chance < 100)) {
				return s_staff;
			}
			s_staff.num_misses++;
			break;
		}
	}
	return undefined;
}