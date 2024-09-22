detour zm_genesis_spiders<scripts\zm\zm_genesis_spiders.gsc>::function_33aa4940()
{
	var_c0692329 = 0;
	if (IS_TRUE(level.var_7cba7005)) {
		if (SRandomInt("zm_genesis_spiders_spawn_spider", 100) < level.var_a3ad836b) {
			var_c0692329 = 1;
		}
	}
	else if (IS_TRUE(level.var_adca2f3c)) {
		if (zm_zonemgr::any_player_in_zone("apothicon_interior_zone")) {
			if (SRandomInt("zm_genesis_spiders_spawn_spider", 100) < level.var_a3ad836b) {
				var_c0692329 = 1;
				var_aa671dd4 = "apothicon_interior_zone_spawners";
			}
		}
	}
	if (var_c0692329) {
		s_spawn_point = function_99f6dbf1(var_aa671dd4);
		level.var_718361fb = [[@zm_genesis_spiders<scripts\zm\zm_genesis_spiders.gsc>::function_3f180afe]]();
		[[@zm_genesis_spiders<scripts\zm\_zm_genesis_spiders.gsc>::function_f4bd92a2]](1, s_spawn_point);
	}
	if (!var_c0692329) {
		var_c0692329 = function_fd8b24f5();
	}
	return var_c0692329;
}

detour zm_genesis_spiders<scripts\zm\zm_genesis_spiders.gsc>::function_99f6dbf1(var_aa671dd4)
{
	return function_99f6dbf1(var_aa671dd4);
}

function_99f6dbf1(var_aa671dd4)
{
	a_s_locs = SArrayRandomize(level.zm_loc_types["spider_location"], "zm_genesis_spiders_location");
	for (i = 0; i < a_s_locs.size; i++) {
		if (IsDefined(var_aa671dd4)) {
			if (a_s_locs[i].targetname === var_aa671dd4) {
				return a_s_locs[i];
			}
			continue;
		}
		return a_s_locs[i];
	}
	return undefined;
}