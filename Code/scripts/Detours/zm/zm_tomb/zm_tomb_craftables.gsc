detour zm_tomb_craftables<scripts\zm\zm_tomb_craftables.gsc>::randomize_craftable_spawns()
{
	a_randomized_craftables = array("gramophone_vinyl_ice", "gramophone_vinyl_air", "gramophone_vinyl_elec", "gramophone_vinyl_fire", "gramophone_vinyl_master", "gramophone_vinyl_player");
	foreach (str_craftable in a_randomized_craftables) {
		s_original_pos = struct::get(str_craftable, "targetname");
		a_alt_locations = struct::get_array(str_craftable + "_alt", "targetname");
		n_loc_index = SRandomIntRange("zm_tomb_craftables_spawn", 0, a_alt_locations.size + 1);
		if (n_loc_index == a_alt_locations.size) {
			continue;
		}
		s_original_pos.origin = a_alt_locations[n_loc_index].origin;
		s_original_pos.angles = a_alt_locations[n_loc_index].angles;
	}
}