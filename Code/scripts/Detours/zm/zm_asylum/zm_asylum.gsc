detour zm_asylum<scripts\zm\zm_asylum.gsc>::function_659c2324(a_keys)
{
	if (a_keys[0] === level.weaponzmteslagun) {
		level.var_12d3a848 = 0;
		return a_keys;
	}
	n_chance = 0;
	if (zm_weapons::limited_weapon_below_quota(level.weaponzmteslagun)) {
		level.var_12d3a848++;
		if (level.var_12d3a848 <= 12) {
			n_chance = 5;
		}
		else {
			if (level.var_12d3a848 > 12 && level.var_12d3a848 <= 17) {
				n_chance = 8;
			}
			else if (level.var_12d3a848 > 17) {
				n_chance = 12;
			}
		}
	}
	else {
		level.var_12d3a848 = 0;
	}
	if (SRandomInt("zm_magicbox", 100) <= n_chance && zm_magicbox::treasure_chest_canplayerreceiveweapon(self, level.weaponzmteslagun) && !self HasWeapon(level.weaponzmteslagunupgraded)) {
		ArrayInsert(a_keys, level.weaponzmteslagun, 0);
		level.var_12d3a848 = 0;
	}
	return a_keys;
}

detour zm_asylum<scripts\zm\zm_asylum.gsc>::assign_lowest_unused_character_index()
{
	charindexarray = [];
	charindexarray[0] = 0;
	charindexarray[1] = 1;
	charindexarray[2] = 2;
	charindexarray[3] = 3;
	if (level.players.size == 1) {
		charindexarray = SArrayRandomize(charindexarray, "character");
		return charindexarray[0];
	}
	foreach (player in level.players) {
		if (IsDefined(player.characterindex)) {
			ArrayRemoveValue(charindexarray, player.characterindex, 0);
		}
	}
	if (charindexarray.size > 0) {
		return charindexarray[0];
	}
	return 0;
}

detour zm_asylum<scripts\zm\zm_asylum.gsc>::function_54da140a()
{
	var_6af221a2 = [];
	a_s_spots = SArrayRandomize(level.zm_loc_types["zombie_location"], "zm_asylum_spawn_location");
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
			sp_zombie = SArrayRandom(var_c15b2128, "zm_asylum_custom_spawn_location");
			return sp_zombie;
		}
	}
}