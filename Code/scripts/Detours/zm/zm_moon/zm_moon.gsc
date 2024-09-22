detour zm_moon<scripts\zm\zm_moon.gsc>::function_ff7d3b7()
{
	var_1acd84fb = SRandomInt("zm_moon_astro_name", level.var_6225e4bb) + 1;
	while (level.var_2c6ea600 === var_1acd84fb) {
        var_1acd84fb = SRandomInt("zm_moon_astro_name", level.var_6225e4bb) + 1;
    }
	level.var_2c6ea600 = var_1acd84fb;
	self clientfield::set("astro_name_index", var_1acd84fb);
	foreach (player in level.players) {
		if (zombie_utility::is_player_valid(player)) {
			owner = player;
			break;
		}
	}
	if (!IsDefined(owner)) {
		owner = level.players[0];
	}
	self SetEntityOwner(owner);
	self SetClone();
}

detour zm_moon<scripts\zm\zm_moon.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_moon<scripts\zm\zm_moon.gsc>::function_54da140a()
{
	var_6af221a2 = [];
	a_s_spots = level.zm_loc_types["zombie_location"];
	if (IsDefined(level.zm_loc_types["quad_location"])) {
		a_s_spots = ArrayCombine(a_s_spots, level.zm_loc_types["quad_location"], 0, 0);
	}
	a_s_spots = SArrayRandomize(a_s_spots, "zm_moon_custom_spawn");
	for (i = 0; i < a_s_spots.size; i++)
	{
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
			sp_zombie = SArrayRandom(var_c15b2128, "zm_moon_custom_spawn");
			return sp_zombie;
		}
	}
}