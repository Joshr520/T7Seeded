detour zm_moon_ai_astro<scripts\zm\zm_moon_ai_astro.gsc>::moon_astro_get_spawn_struct()
{
	keys = GetArrayKeys(level.zones);
	for (i = 0; i < level.zones.size; i++) {
		if (keys[i] == "nml_zone") {
			continue;
		}
		if (level.zones[keys[i]].is_occupied) {
			locs = struct::get_array(level.zones[keys[i]].volumes[0].target + "_astro", "targetname");
			if (IsDefined(locs) && locs.size > 0) {
				locs = SArrayRandomize(locs, "zm_moon_ai_astro_spawn");
				return locs[0];
			}
		}
	}
	for (i = 0; i < level.zones.size; i++) {
		if (keys[i] == "nml_zone") {
			continue;
		}
		if (level.zones[keys[i]].is_active) {
			locs = struct::get_array(level.zones[keys[i]].volumes[0].target + "_astro", "targetname");
			if (IsDefined(locs) && locs.size > 0) {
				locs = SArrayRandomize(locs, "zm_moon_ai_astro_spawn");
				return locs[0];
			}
		}
	}
	return undefined;
}