detour zm_temple<scripts\zm\zm_temple.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_temple<scripts\zm\zm_temple.gsc>::assign_lowest_unused_character_index()
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

detour zm_temple<scripts\zm\zm_temple.gsc>::function_54da140a()
{
	var_6af221a2 = [];
	a_s_spots = SArrayRandomize(level.zm_loc_types["zombie_location"], "zm_temple_custom_location");
	for (i = 0; i < a_s_spots.size; i++) {
		if (!IsDefined(a_s_spots[i].script_int)) {
			var_343b1937 = 1;
		}
		else {
			var_343b1937 = a_s_spots[i].script_int;
		}
		var_c15b2128 = [];
		foreach (sp_zombie in level.zombie_spawners) {
			if (sp_zombie.script_int == var_343b1937) {
				if (!IsDefined(var_c15b2128)) {
					var_c15b2128 = [];
				}
				else if (!IsArray(var_c15b2128)) {
					var_c15b2128 = array(var_c15b2128);
				}
				var_c15b2128[var_c15b2128.size] = sp_zombie;
			}
		}
		if (var_c15b2128.size) {
			sp_zombie = SArrayRandom(var_c15b2128, "zm_temple_custom_location");
			return sp_zombie;
		}
	}
}

detour zm_temple<scripts\zm\zm_temple.gsc>::init_random_perk_machines()
{
	randmachines = [];
	randmachines = [[@zm_temple<scripts\zm\zm_temple.gsc>::_add_machine]](randmachines, "vending_jugg", "mus_perks_jugganog_sting", "specialty_armorvest", "mus_perks_jugganog_jingle", "jugg_perk", "p7_zm_vending_jugg");
	randmachines = [[@zm_temple<scripts\zm\zm_temple.gsc>::_add_machine]](randmachines, "vending_marathon", "mus_perks_stamin_sting", "specialty_staminup", "mus_perks_stamin_jingle", "marathon_perk", "p7_zm_vending_marathon");
	randmachines = [[@zm_temple<scripts\zm\zm_temple.gsc>::_add_machine]](randmachines, "vending_deadshot", "mus_perks_deadshot_sting", "specialty_deadshot", "mus_perks_deadshot_jingle", "deadshot_perk", "p7_zm_vending_three_gun");
	randmachines = [[@zm_temple<scripts\zm\zm_temple.gsc>::_add_machine]](randmachines, "vending_sleight", "mus_perks_speed_sting", "specialty_fastreload", "mus_perks_speed_jingle", "speedcola_perk", "p7_zm_vending_sleight");
	randmachines = [[@zm_temple<scripts\zm\zm_temple.gsc>::_add_machine]](randmachines, "vending_doubletap", "mus_perks_doubletap_sting", "specialty_doubletap2", "mus_perks_doubletap_jingle", "tap_perk", "p7_zm_vending_doubletap2");
	randmachines = [[@zm_temple<scripts\zm\zm_temple.gsc>::_add_machine]](randmachines, "vending_widowswine", "mus_perks_phd_sting", "specialty_widowswine", "mus_perks_phd_jingle", "widowswine_perk", "p7_zm_vending_widows_wine");
	machines = struct::get_array("zm_perk_machine", "targetname");
	for (i = machines.size - 1; i >= 0; i--) {
		if (IsDefined(machines[i].script_noteworthy)) {
			machines = [[@zm_temple<scripts\zm\zm_temple.gsc>::array_remove]](machines, machines[i]);
		}
	}
	for (i = 0; i < machines.size; i++) {
		machine = machines[i];
		machine.allowed = [];
		if (IsDefined(machine.script_parameters)) {
			machine.allowed = StrTok(machine.script_parameters, ",");
		}
		if (machine.allowed.size == 0) {
			machine.allowed = array("jugg_perk", "marathon_perk", "widowswine_perk", "deadshot_perk", "speedcola_perk", "tap_perk");
		}
		machine.allowed = SArrayRandomize(machine.allowed, "zm_temple_perk_locations");
	}
	machines = [[@zm_temple<scripts\zm\zm_temple.gsc>::mergesort]](machines, @zm_temple<scripts\zm\zm_temple.gsc>::perk_machines_compare_func);
	for (i = 0; i < machines.size; i++) {
		machine = machines[i];
		randmachine = undefined;
		for (j = 0; j < machine.allowed.size; j++) {
			index = [[@zm_temple<scripts\zm\zm_temple.gsc>::_rand_perk_index]](randmachines, machine.allowed[j]);
			if (IsDefined(index)) {
				randmachine = randmachines[index];
				randmachines = [[@zm_temple<scripts\zm\zm_temple.gsc>::array_remove]](randmachines, randmachine);
				break;
			}
		}
		machine.script_noteworthy = randmachine.script_noteworthy;
		machine.targetname = randmachine.targetname;
		machine.model = randmachine.model;
	}
}