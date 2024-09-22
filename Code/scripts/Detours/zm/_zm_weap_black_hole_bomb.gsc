detour zm_weap_black_hole_bomb<scripts\zm\_zm_weap_black_hole_bomb.gsc>::black_hole_time_before_teleport(ent_player, str_endon)
{
	ent_player endon(str_endon);
	if (!BulletTracePassed(ent_player GetEye(), self.origin + VectorScale((0, 0, 1), 65), 0, ent_player)) {
		return;
	}
	black_hole_teleport_structs = struct::get_array("struct_black_hole_teleport", "targetname");
	chosen_spot = undefined;
	if (IsDefined(level._special_blackhole_bomb_structs)) {
		black_hole_teleport_structs = [[level._special_blackhole_bomb_structs]]();
	}
	if (!IsDefined(black_hole_teleport_structs) || black_hole_teleport_structs.size == 0) {
		return;
	}
	black_hole_teleport_structs = SArrayRandomize(black_hole_teleport_structs, "zm_weap_black_hole_bomb_teleport");
	if (IsDefined(level._override_blackhole_destination_logic)) {
		chosen_spot = [[level._override_blackhole_destination_logic]](black_hole_teleport_structs, ent_player);
	}
	else {
		for (i = 0; i < black_hole_teleport_structs.size; i++) {
			if (zm_utility::check_point_in_enabled_zone(black_hole_teleport_structs[i].origin) && ent_player zm_utility::get_current_zone() != black_hole_teleport_structs[i].script_string) {
				chosen_spot = black_hole_teleport_structs[i];
				break;
			}
		}
	}
	if (IsDefined(chosen_spot))
	{
		self PlaySound("zmb_gersh_teleporter_out");
		ent_player PlaySoundToPlayer("zmb_gersh_teleporter_out_plr", ent_player);
		ent_player thread [[@zm_weap_black_hole_bomb<scripts\zm\_zm_weap_black_hole_bomb.gsc>::black_hole_teleport]](chosen_spot);
	}
}