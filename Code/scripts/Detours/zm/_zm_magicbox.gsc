detour zm_magicbox<scripts\zm\_zm_magicbox.gsc>::treasure_chest_should_move(chest, player)
{
	if (GetDvarString("magic_chest_movable") == "1" && !IS_TRUE(chest._box_opened_by_fire_sale) && !zm_magicbox::treasure_chest_firesale_active() && self [[level._zombiemode_check_firesale_loc_valid_func]]()) {
		random = SRandomInt("zm_magicbox", 100);
		if (!IsDefined(level.chest_min_move_usage)) {
			level.chest_min_move_usage = 4;
		}
		if (level.chest_accessed < level.chest_min_move_usage) {
			chance_of_joker = -1;
		}
		else {
			chance_of_joker = level.chest_accessed + 20;
			if (level.chest_moves == 0 && level.chest_accessed >= 8) {
				chance_of_joker = 100;
			}
			if (level.chest_accessed >= 4 && level.chest_accessed < 8) {
				if (random < 15) {
					chance_of_joker = 100;
				}
				else {
					chance_of_joker = -1;
				}
			}
			if (level.chest_moves > 0) {
				if (level.chest_accessed >= 8 && level.chest_accessed < 13) {
					if (random < 30) {
						chance_of_joker = 100;
					}
					else {
						chance_of_joker = -1;
					}
				}
				if (level.chest_accessed >= 13) {
					if (random < 50) {
						chance_of_joker = 100;
					}
					else {
						chance_of_joker = -1;
					}
				}
			}
		}
		if (IsDefined(chest.no_fly_away)) {
			chance_of_joker = -1;
		}
		if (IsDefined(level._zombiemode_chest_joker_chance_override_func)) {
			chance_of_joker = [[level._zombiemode_chest_joker_chance_override_func]](chance_of_joker);
		}
		if (chance_of_joker > random) {
			return true;
		}
	}
	return false;
}

detour zm_magicbox<scripts\zm\_zm_magicbox.gsc>::treasure_chest_init(start_chest_name)
{
	level flag::init("moving_chest_enabled");
	level flag::init("moving_chest_now");
	level flag::init("chest_has_been_used");
	level.chest_moves = 0;
	level.chest_level = 0;
	if (level.chests.size == 0) {
		return;
	}
	for (i = 0; i < level.chests.size; i++) {
		level.chests[i].box_hacks = [];
		level.chests[i].orig_origin = level.chests[i].origin;
		level.chests[i] zm_magicbox::get_chest_pieces();
		if (IsDefined(level.chests[i].zombie_cost)) {
			level.chests[i].old_cost = level.chests[i].zombie_cost;
			continue;
		}
		level.chests[i].old_cost = 950;
	}
	if (!level.enable_magic) {
		foreach (chest in level.chests) {
			chest zm_magicbox::hide_chest();
		}
		return;
	}
	level.chest_accessed = 0;
	if (level.chests.size > 1) {
		level flag::set("moving_chest_enabled");
		level.chests = SArrayRandomize(level.chests, "zm_magicbox_init");
	}
	else {
		level.chest_index = 0;
		level.chests[0].no_fly_away = 1;
	}
	zm_magicbox::init_starting_chest_location(start_chest_name);
	array::thread_all(level.chests, zm_magicbox::treasure_chest_think);
}

detour zm_magicbox<scripts\zm\_zm_magicbox.gsc>::default_box_move_logic()
{
	index = -1;
	for (i = 0; i < level.chests.size; i++) {
		if (IsSubStr(level.chests[i].script_noteworthy, "move" + (level.chest_moves + 1)) && i != level.chest_index) {
			index = i;
			break;
		}
	}
	if (index != -1) {
		level.chest_index = index;
	}
	else {
		level.chest_index++;
	}
	if (level.chest_index >= level.chests.size) {
		temp_chest_name = level.chests[level.chest_index - 1].script_noteworthy;
		level.chest_index = 0;
		level.chests = SArrayRandomize(level.chests, "zm_magicbox_move");
		if (temp_chest_name == level.chests[level.chest_index].script_noteworthy) {
			level.chest_index++;
		}
	}
}

detour zm_magicbox<scripts\zm\_zm_magicbox.gsc>::treasure_chest_chooseweightedrandomweapon(player)
{
	keys = SArrayRandomize(GetArrayKeys(level.zombie_weapons), "magicbox");
	if (IsDefined(level.customrandomweaponweights)) {
		keys = player [[level.customrandomweaponweights]](keys);
	}
	pap_triggers = zm_pap_util::get_triggers();
	for (i = 0; i < keys.size; i++) {
		if (zm_magicbox::treasure_chest_canplayerreceiveweapon(player, keys[i], pap_triggers)) {
			return keys[i];
		}
	}
	return keys[0];
}