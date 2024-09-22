detour zm_bgb_anywhere_but_here<scripts\zm\bgbs\_zm_bgb_anywhere_but_here.gsc>::function_728dfe3()
{
	var_a6abcc5d = zm_zonemgr::get_zone_from_position(self.origin + VectorScale((0, 0, 1), 32), 0);
	if (!IsDefined(var_a6abcc5d)) {
		var_a6abcc5d = self.zone_name;
	}
	if (IsDefined(var_a6abcc5d)) {
		var_c30975d2 = level.zones[var_a6abcc5d];
	}
	var_97786609 = struct::get_array("player_respawn_point", "targetname");
	var_bbf77908 = [];
	foreach (s_respawn_point in var_97786609) {
		if (zm_utility::is_point_inside_enabled_zone(s_respawn_point.origin, var_c30975d2)) {
			if (!IsDefined(var_bbf77908)) {
				var_bbf77908 = [];
			}
			else if (!IsArray(var_bbf77908)) {
				var_bbf77908 = array(var_bbf77908);
			}
			var_bbf77908[var_bbf77908.size] = s_respawn_point;
		}
	}
	if (IsDefined(level.var_2d4e3645)) {
		var_bbf77908 = [[level.var_2d4e3645]](var_bbf77908);
	}
	s_player_respawn = undefined;
	if (var_bbf77908.size > 0) {
		var_90551969 = SArrayRandom(var_bbf77908, "zm_bgb_anywhere_but_here_teleport");
		var_46b9bbf8 = struct::get_array(var_90551969.target, "targetname");
		foreach (var_dbd59eb2 in var_46b9bbf8) {
			n_script_int = self GetEntityNumber() + 1;
			if (var_dbd59eb2.script_int === n_script_int) {
				s_player_respawn = var_dbd59eb2;
			}
		}
	}
	return s_player_respawn;
}