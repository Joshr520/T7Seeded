detour zm_temple_ai_monkey<scripts\zm\zm_temple_ai_monkey.gsc>::array_randomize_knuth(array)
{
	return array_randomize_knuth(array);
}

array_randomize_knuth(array)
{
	n = array.size;
	while (n > 0) {
		index = SRandomInt("zm_temple_ai_monkey_spawn", n);
		n = n - 1;
		temp = array[index];
		array[index] = array[n];
		array[n] = temp;
	}
	return array;
}

detour zm_temple_ai_monkey<scripts\zm\zm_temple_ai_monkey.gsc>::_powerup_randomize(monkey)
{
	self endon("stop_randomize");
	monkey endon("remove");
	powerup_cycle = array("carpenter", "fire_sale", "nuke", "double_points", "insta_kill");
	powerup_cycle = array_randomize_knuth(powerup_cycle);
	powerup_cycle[powerup_cycle.size] = "full_ammo";
	if (level.chest_moves < 1) {
		ArrayRemoveValue(powerup_cycle, "fire_sale");
	}
	if (level.round_number <= 1) {
		ArrayRemoveValue(powerup_cycle, "nuke");
	}
	currentpowerup = undefined;
	keys = GetArrayKeys(level.zombie_powerups);
	for (i = 0; i < keys.size; i++) {
		if (level.zombie_powerups[keys[i]].model_name == self.model) {
			currentpowerup = keys[i];
			break;
		}
	}
	if (IsDefined(currentpowerup)) {
		ArrayRemoveValue(powerup_cycle, currentpowerup);
		ArrayInsert(powerup_cycle, currentpowerup, 0);
	}
	if (currentpowerup == "full_ammo" && self.grab_count == 1) {
		index = SRandomIntRange("zm_temple_ai_monkey_powerup", 1, powerup_cycle.size - 1);
		ArrayInsert(powerup_cycle, "free_perk", index);
	}
	wait 1;
	index = 1;
	for (;;) {
		powerupname = powerup_cycle[index];
		index++;
		if (index >= powerup_cycle.size) {
			index = 0;
		}
		self zm_powerups::powerup_setup(powerupname, undefined, undefined, undefined, 0);
		self PlaySound("zmb_temple_powerup_switch");
		monkey [[@zm_temple_ai_monkey<scripts\zm\zm_temple_ai_monkey.gsc>::_monkey_bindpowerup]](self);
		if (powerupname == "free_perk") {
			wait 0.25;
		}
		else {
			wait 1;
		}
	}
}