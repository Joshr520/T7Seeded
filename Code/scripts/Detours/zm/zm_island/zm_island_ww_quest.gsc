detour zm_island_ww_quest<scripts\zm\zm_island_ww_quest.gsc>::function_659c2324(a_keys)
{
	var_b45fbf8c = zm_pap_util::get_triggers();
	if (level flag::get("players_lost_ww")) {
		level.var_2cb8e184++;
		switch (level.var_2cb8e184) {
			case 1: {
				n_chance = 10;
				break;
			}
			case 2: {
				n_chance = 10;
				break;
			}
			case 3: {
				n_chance = 30;
				break;
			}
			case 4: {
				n_chance = 60;
				break;
			}
			default: {
				n_chance = 10;
				break;
			}
		}
		if (SRandomInt("zm_magicbox", 100) <= n_chance && zm_magicbox::treasure_chest_canplayerreceiveweapon(self, level.var_5e75629a, var_b45fbf8c) && !self HasWeapon(level.var_a4052592)) {
			ArrayInsert(a_keys, level.var_5e75629a, 0);
			self thread [[@zm_island_ww_quest<scripts\zm\zm_island_ww_quest.gsc>::function_97d5f905]]();
		}
		else {
			ArrayRemoveValue(a_keys, level.var_5e75629a);
		}
	}
	else if (self HasWeapon(level.var_5e75629a) || self HasWeapon(level.var_a4052592)) {
		ArrayRemoveValue(a_keys, level.var_5e75629a);
	}
	return a_keys;
}

detour zm_island_ww_quest<scripts\zm\zm_island_ww_quest.gsc>::function_6590511d()
{
	level flag::wait_till("power_on");
	level waittill("start_of_round");
	wait SRandomIntRange("zm_island_ww_quest_vial", 5, 8);
	for (;;) {
		ai_carrier = function_1c683357();
		if (IsAlive(ai_carrier)) {
			while (IsAlive(ai_carrier) && ai_carrier.completed_emerging_into_playable_area !== 1) {
				util::wait_network_frame();
			}
			if (IsAlive(ai_carrier) && zm_utility::check_point_in_playable_area(ai_carrier.origin)) {
				ai_carrier clientfield::set("play_carrier_fx", 1);
				ai_carrier.var_5017aabf = 1;
				ai_carrier.no_powerups = 1;
				var_1a0512ba = ai_carrier [[@zm_island_ww_quest<scripts\zm\zm_island_ww_quest.gsc>::function_f5d430d7]]();
				if (var_1a0512ba) {
					break;
				}
			}
		}
		wait 1;
	}
}

detour zm_island_ww_quest<scripts\zm\zm_island_ww_quest.gsc>::function_1c683357()
{
	return function_1c683357();
}

function_1c683357()
{
	a_ai_zombies = GetAITeamArray(level.zombie_team);
	var_2513c269 = [];
	foreach (ai_zombie in a_ai_zombies) {
		str_zone = ai_zombie zm_utility::get_current_zone();
		if (zm_zonemgr::any_player_in_zone("zone_meteor_site") || zm_zonemgr::any_player_in_zone("zone_meteor_site_2") || zm_zonemgr::any_player_in_zone("zone_swamp_lab_underneath") || zm_zonemgr::any_player_in_zone("zone_swamp_lab_underneath_2") || zm_zonemgr::any_player_in_zone("zone_swamp_lab")) {
			if (str_zone === "zone_meteor_site" || str_zone === "zone_meteor_site_2" || str_zone === "zone_swamp_lab_underneath" || str_zone === "zone_swamp_lab_underneath_2") {
				if (!IsDefined(ai_zombie.completed_emerging_into_playable_area) && !IS_TRUE(ai_zombie.b_is_spider) && !IS_TRUE(ai_zombie.var_61f7b3a0) && ai_zombie.archetype === "zombie") {
					array::add(var_2513c269, ai_zombie);
				}
			}
		}
	}
	ai_carrier = SArrayRandom(var_2513c269, "zm_island_ww_quest_vial");
	if (IsDefined(ai_carrier) && ![[@zm_island_util<scripts\zm\zm_island_util.gsc>::any_player_looking_at]](ai_carrier GetCentroid(), 0.5, 1, ai_carrier)) {
		ai_carrier SetModel("c_zom_dlc2_jpn_zombies3a");
		return ai_carrier;
	}
}