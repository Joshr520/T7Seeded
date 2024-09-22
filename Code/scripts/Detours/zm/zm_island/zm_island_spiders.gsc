detour zm_island_spiders<scripts\zm\zm_island_spiders.gsc>::function_33aa4940()
{
	var_7ac5425b = 0;
	var_622d2c20 = 0;
	if (level.round_number > 35) {
		if (SRandomFloat("zm_island_spiders_custom_spawn", 100) < 10) {
			var_7ac5425b = 1;
		}
	}
	else if (level.round_number > 30) {
        if (SRandomFloat("zm_island_spiders_custom_spawn", 100) < 8) {
            var_7ac5425b = 1;
        }
    }
    else if (level.round_number > 25) {
        if (SRandomFloat("zm_island_spiders_custom_spawn", 100) < 7) {
            var_7ac5425b = 1;
        }
    }
    else if (level.round_number > 20) {
        if (SRandomFloat("zm_island_spiders_custom_spawn", 100) < 5) {
            var_7ac5425b = 1;
        }
    }
	if (level.round_number > level.var_5ccd3661 && level.round_number > 7) {
		if (zm_zonemgr::any_player_in_zone("zone_spider_lair") || (zm_zonemgr::any_player_in_zone("zone_jungle_lab") || zm_zonemgr::any_player_in_zone("zone_jungle_lab_upper") && level.var_90e478e7)) {
			if (SRandomFloat("zm_island_spiders_custom_spawn", 100) < 30 && level.var_ab7eb3d4 < 3) {
				var_7ac5425b = 1;
				var_622d2c20 = 1;
			}
		}
	}
	if (var_7ac5425b) {
		if (var_622d2c20) {
			var_a5f01313 = struct::get_array("zone_spider_lair_spawners", "targetname");
			var_901f5ace = [];
			foreach (s_spawner in var_a5f01313) {
				if (s_spawner.script_noteworthy == "spider_location") {
					if (!IsDefined(var_901f5ace)) {
						var_901f5ace = [];
					}
					else if (!IsArray(var_901f5ace)) {
						var_901f5ace = array(var_901f5ace);
					}
					var_901f5ace[var_901f5ace.size] = s_spawner;
				}
			}
			[[@zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_f4bd92a2]](1, SArrayRandom(var_901f5ace, "zm_island_spiders_custom_spawn"));
			level.var_ab7eb3d4++;
		}
		else {
			[[@zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::function_f4bd92a2]](1);
		}
		level.zombie_total--;
	}
	return var_7ac5425b;
}