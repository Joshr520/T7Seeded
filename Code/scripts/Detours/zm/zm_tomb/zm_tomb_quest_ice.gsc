detour zm_tomb_quest_ice<scripts\zm\zm_tomb_quest_ice.gsc>::ice_tiles_randomize()
{
	a_original_tiles = GetEntArray("ice_tile_original", "targetname");
	a_original_tiles = array::sort_by_script_int(a_original_tiles, 1);
	a_original_positions = [];
	foreach (e_tile in a_original_tiles) {
		a_original_positions[a_original_positions.size] = e_tile.origin;
	}
	a_unused_tiles = GetEntArray("ice_ceiling_tile", "script_noteworthy");
	n_total_tiles = a_unused_tiles.size;
	n_index = 0;
	foreach (v_pos in a_original_positions) {
		e_tile = SArrayRandom(a_unused_tiles, "zm_tomb_quest_ice_tiles");
		ArrayRemoveValue(a_unused_tiles, e_tile, 0);
		e_tile MoveTo(v_pos, 0.5);
		e_tile waittill("movedone");
		str_model_name = "ice_ceiling_tile_model_" + n_index;
		var_fa4117e3 = GetEnt(str_model_name, "targetname");
		var_fa4117e3 LinkTo(e_tile);
		n_index++;
	}
	array::delete_all(a_unused_tiles);
}

detour zm_tomb_quest_ice<scripts\zm\zm_tomb_quest_ice.gsc>::change_ice_gem_value()
{
	ice_gem = GetEnt("ice_chamber_gem", "targetname");
	if (level.unsolved_tiles.size != 0) {
		correct_tile = SArrayRandom(level.unsolved_tiles, "zm_tomb_quest_ice_value");
		ice_gem.value = correct_tile.value;
		level notify("update_ice_chamber_digits", ice_gem.value);
	}
	else {
		level notify("update_ice_chamber_digits", -1);
	}
}