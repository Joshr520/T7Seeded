detour zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::player_teleporting(index)
{
	var_1bea176e = [];
	self thread [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_pad_player_fx]](undefined);
	self thread [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_2d_audio]]();
	self thread [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_nuke]](undefined, 300);
	wait level.teleport_delay;
	exploder::exploder("fxexp_202");
	self notify("fx_done");
	var_1bea176e = self [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_players]](var_1bea176e, "projroom");
	if (!IsDefined(var_1bea176e) || (IsDefined(var_1bea176e) && var_1bea176e.size < 1))
	{
		return;
	}
	var_1bea176e = array::filter(var_1bea176e, 0, @zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::function_1488cf91);
	foreach (e_player in var_1bea176e) {
		e_player.var_35c3d096 = 1;
	}
	wait 30;
	var_1bea176e = array::filter(var_1bea176e, 0, @zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::function_1488cf91);
	level.extracam_screen clientfield::set("extra_screen", 0);
	if (SRandomInt("zm_theater_teleporter_ee_room", 100) > 24 && !IsDefined(level.eeroomsinuse)) {
		loc = "eerooms";
		level.eeroomsinuse = 1;
		if (SRandomInt("zm_theater_teleporter_ee_room", 100) > 65) {
			level thread eeroom_powerup_drop();
		}
	}
	else {
		loc = "theater";
		exploder::exploder(301);
	}
	self thread [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_pad_player_fx]](var_1bea176e);
	self thread [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_2d_audio_specialroom_start]](var_1bea176e);
	wait level.teleport_delay;
	var_1bea176e = array::filter(var_1bea176e, 0, @zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::function_1488cf91);
	self notify("fx_done");
	self thread [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_2d_audio_specialroom_go]](var_1bea176e);
	self [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_players]](var_1bea176e, loc);
	if (IsDefined(loc) && loc == "eerooms") {
		loc = "theater";
		wait 4;
		var_1bea176e = array::filter(var_1bea176e, 0, @zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::function_1488cf91);
		self thread [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_2d_audio_specialroom_start]](var_1bea176e);
		exploder::exploder(301);
		self thread [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_pad_player_fx]](var_1bea176e);
		wait level.teleport_delay;
		var_1bea176e = array::filter(var_1bea176e, 0, @zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::function_1488cf91);
		self notify("fx_done");
		self thread [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_2d_audio_specialroom_go]](var_1bea176e);
		self [[@zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::teleport_players]](var_1bea176e, loc);
	}
}

detour zm_theater_teleporter<scripts\zm\zm_theater_teleporter.gsc>::eeroom_powerup_drop()
{
	return eeroom_powerup_drop();
}

eeroom_powerup_drop()
{
	struct_array = struct::get_array("struct_random_powerup_post_teleport", "targetname");
	powerup_array = [];
	powerup_array[powerup_array.size] = "nuke";
	powerup_array[powerup_array.size] = "insta_kill";
	powerup_array[powerup_array.size] = "double_points";
	powerup_array[powerup_array.size] = "carpenter";
	powerup_array[powerup_array.size] = "fire_sale";
	powerup_array[powerup_array.size] = "full_ammo";
	powerup_array[powerup_array.size] = "minigun";
	struct_array = SArrayRandomize(struct_array, "zm_theater_teleporter_powerup");
	powerup_array = SArrayRandomize(powerup_array, "zm_theater_teleporter_powerup");
	level thread zm_powerups::specific_powerup_drop(powerup_array[0], struct_array[0].origin);
}