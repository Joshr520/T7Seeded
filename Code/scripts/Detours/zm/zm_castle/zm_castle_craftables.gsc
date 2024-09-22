detour zm_castle_craftables<scripts\zm\zm_castle_craftables.gsc>::function_1b872af(str_zone)
{
	a_e_volumes = GetEntArray(str_zone, "targetname");
	a_s_pos = [];
	a_s_spots = struct::get_array(a_e_volumes[0].target, "targetname");
	for (i = 0; i < a_s_spots.size; i++) {
		if (a_s_spots[i].script_noteworthy === "spawn_location" || a_s_spots[i].script_noteworthy === "riser_location") {
			array::add(a_s_pos, a_s_spots[i], 0);
		}
	}
	if (a_s_pos.size > 0) {
		return SArrayRandom(a_s_pos, "zm_castle_craftables_spawn");
	}
}