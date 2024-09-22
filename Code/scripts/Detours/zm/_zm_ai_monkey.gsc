detour zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::randomize_array(array)
{
	for (i = 0; i < array.size; i++) {
		j = SRandomInt("zm_ai_monkey_spawners", array.size);
		temp = array[i];
		array[i] = array[j];
		array[j] = temp;
	}
	return array;
}

detour zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::monkey_round_tracker()
{
	level flag::wait_till("power_on");
	level flag::wait_till("perk_bought");
	level.monkey_save_spawn_func = level.round_spawn_func;
	level.monkey_save_wait_func = level.round_wait_func;
	level.next_monkey_round = level.round_number + SRandomIntRange("zm_ai_monkey_round", 1, 4);
	level.prev_monkey_round = level.next_monkey_round;
	for (;;) {
		level waittill("between_round_over");
		if (level.round_number == level.next_monkey_round) {
			if (![[@zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::monkey_player_has_perk]]()) {
				level.next_monkey_round++;
				continue;
			}
			level.sndmusicspecialround = 1;
			level.monkey_save_spawn_func = level.round_spawn_func;
			level.monkey_save_wait_func = level.round_wait_func;
			level thread zm_audio::sndmusicsystem_playstate("monkey_round_start");
			[[@zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::monkey_round_start]]();
			level.round_spawn_func = @zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::monkey_round_spawning;
			level.round_wait_func = @zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::monkey_round_wait;
			level.prev_monkey_round = level.next_monkey_round;
			level.next_monkey_round = level.round_number + SRandomIntRange("zm_ai_monkey_round", 4, 6);
		}
		else if (level flag::get("monkey_round")) {
			[[@zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::monkey_round_stop]]();
		}
	}
}

detour zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::monkey_get_available_spawners()
{
	spawners = [];
	for (i = 0; i < level.monkey_zombie_spawners.size; i++) {
		if (level.zones[level.monkey_zombie_spawners[i].script_noteworthy].is_enabled) {
			spawners[spawners.size] = level.monkey_zombie_spawners[i];
		}
	}
	spawners = SArrayRandomize(spawners, "zm_ai_monkey_spawn_location");
	return spawners;
}

detour zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::monkey_pack_man_setup_perks()
{
	level.monkey_perks = [];
	vending_triggers = [[@zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::function_5b9c3e11]]();
	for (i = 0; i < vending_triggers.size; i++) {
		if (vending_triggers[i].targeted) {
			continue;
		}
		players = GetPlayers();
		for (j = 0; j < players.size; j++) {
			perk = vending_triggers[i].script_noteworthy;
			org = vending_triggers[i].origin;
			if (IsDefined(vending_triggers[i].realorigin)) {
				org = vending_triggers[i].realorigin;
			}
			zone_enabled = zm_zonemgr::get_zone_from_position(org, 0);
			if (players[j] HasPerk(perk) && IsDefined(zone_enabled)) {
				level.monkey_perks[level.monkey_perks.size] = vending_triggers[i];
				break;
			}
		}
	}
	if (level.monkey_perks.size > 1) {
		level.monkey_perks = SArrayRandomize(level.monkey_perks, "zm_ai_monkey_perks");
	}
	level.monkey_perk_idx = 0;
}

detour zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::monkey_pack_choose_enemy()
{
	monkey_enemy = [];
	players = GetPlayers();
	for (i = 0; i < players.size; i++) {
		if (!zombie_utility::is_player_valid(players[i])) {
			continue;
		}
		monkey_enemy[monkey_enemy.size] = players[i];
	}
	monkey_enemy = SArrayRandomize(monkey_enemy, "zm_ai_monkey_enemy");
	if (monkey_enemy.size > 0) {
		self.enemy = monkey_enemy[0];
	}
	else {
		self.enemy = players[0];
	}
}

detour zm_ai_monkey<scripts\zm\_zm_ai_monkey.gsc>::monkey_zombie_bhb_teleport()
{
	self endon("death");
	black_hole_teleport = struct::get_array("struct_black_hole_teleport", "targetname");
	zone_name = self zm_utility::get_current_zone();
	locations = [];
	for (i = 0; i < black_hole_teleport.size; i++) {
		bhb_zone_name = black_hole_teleport[i].script_string;
		if (!IsDefined(bhb_zone_name) || !IsDefined(zone_name)) {
			continue;
		}
		if (bhb_zone_name == zone_name) {
			continue;
		}
		if (!level.zones[bhb_zone_name].is_enabled) {
			continue;
		}
		locations[locations.size] = black_hole_teleport[i];
	}
	self StopAnimScripted();
	util::wait_network_frame();
	so = Spawn("script_origin", self.origin);
	so.angles = self.angles;
	self LinkTo(so);
	if (locations.size > 0) {
		locations = SArrayRandomize(locations, "zm_ai_monkey_teleport");
		so.origin = locations[0].origin;
		so.angles = locations[0].angles;
	}
	else {
		so.origin = self.spawn_origin;
		so.angles = self.spawn_angles;
	}
	util::wait_network_frame();
	self Unlink();
	so Delete();
}