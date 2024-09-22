detour zm_weap_quantum_bomb<scripts\zm\_zm_weap_quantum_bomb.gsc>::quantum_bomb_random_weapon_starburst_result(position)
{
	self thread zm_audio::create_and_play_dialog("kill", "quant_good");
	a_weapons_list = [];
	var_dd341085 = GetArrayKeys(level.zombie_weapons);
	foreach (var_134a15b0 in var_dd341085) {
		if (!var_134a15b0.ismeleeweapon && !var_134a15b0.isgrenadeweapon && !var_134a15b0.islauncher && ![[@zm_weap_quantum_bomb<scripts\zm\_zm_weap_quantum_bomb.gsc>::function_29e8b3fc]](var_134a15b0)) {
			array::add(a_weapons_list, var_134a15b0, 0);
		}
	}
	weapon = SArrayRandom(a_weapons_list, "zm_weap_quantum_bomb_weapons");
	var_46d0740e = zm_weapons::get_upgrade_weapon(weapon);
	if (![[@zm_weap_quantum_bomb<scripts\zm\_zm_weap_quantum_bomb.gsc>::function_29e8b3fc]](var_46d0740e)) {
		weapon = var_46d0740e;
	}
	[[@zm_weap_quantum_bomb<scripts\zm\_zm_weap_quantum_bomb.gsc>::quantum_bomb_play_player_effect_at_position]](position);
	base_pos = position + VectorScale((0, 0, 1), 40);
	start_yaw = VectorToAngles(base_pos - self.origin);
	start_yaw = (0, start_yaw[1], 0);
	weapon_model = zm_utility::spawn_weapon_model(weapon, undefined, position, start_yaw);
	weapon_model MoveTo(base_pos, 1, 0.25, 0.25);
	weapon_model waittill("movedone");
	for (i = 0; i < 36; i++) {
		yaw = start_yaw + (RandomIntRange(-3, 3), i * 10, 0);
		weapon_model.angles = yaw;
		flash_pos = weapon_model GetTagOrigin("tag_flash");
		target_pos = flash_pos + VectorScale(AnglesToForward(yaw), 40);
		MagicBullet(weapon, flash_pos, target_pos, undefined);
		util::wait_network_frame();
	}
	weapon_model Delete();
}

detour zm_weap_quantum_bomb<scripts\zm\_zm_weap_quantum_bomb.gsc>::quantum_bomb_player_teleport_result(position)
{
	[[@zm_weap_quantum_bomb<scripts\zm\_zm_weap_quantum_bomb.gsc>::quantum_bomb_play_mystery_effect]](position);
	players = GetPlayers();
	players_to_teleport = [];
	for (i = 0; i < players.size; i++) {
		player = players[i];
		if (player.sessionstate == "spectator" || player laststand::player_is_in_laststand()) {
			continue;
		}
		if (IsDefined(level.quantum_bomb_prevent_player_getting_teleported) && player [[level.quantum_bomb_prevent_player_getting_teleported]](position)) {
			continue;
		}
		players_to_teleport[players_to_teleport.size] = player;
	}
	players_to_teleport = SArrayRandomize(players_to_teleport, "zm_weap_quantum_bomb_players");
	for (i = 0; i < players_to_teleport.size; i++) {
		player = players_to_teleport[i];
		if (i && SRandomInt(5)) {
			continue;
		}
		level thread quantum_bomb_teleport_player(player);
	}
}

detour zm_weap_quantum_bomb<scripts\zm\_zm_weap_quantum_bomb.gsc>::quantum_bomb_teleport_player(player)
{
    return quantum_bomb_teleport_player(player);
}

quantum_bomb_teleport_player(player)
{
	black_hole_teleport_structs = struct::get_array("struct_black_hole_teleport", "targetname");
	chosen_spot = undefined;
	if (IsDefined(level._special_blackhole_bomb_structs)) {
		black_hole_teleport_structs = [[level._special_blackhole_bomb_structs]]();
	}
	player_current_zone = player zm_utility::get_current_zone();
	if (!IsDefined(black_hole_teleport_structs) || black_hole_teleport_structs.size == 0 || !IsDefined(player_current_zone)) {
		return;
	}
	black_hole_teleport_structs = SArrayRandomize(black_hole_teleport_structs, "zm_weap_quantum_bomb_teleport");
	if (IsDefined(level._override_blackhole_destination_logic)) {
		chosen_spot = [[level._override_blackhole_destination_logic]](black_hole_teleport_structs, player);
	}
	else {
		for (i = 0; i < black_hole_teleport_structs.size; i++) {
			if (black_hole_teleport_structs[i] zm_zonemgr::entity_in_active_zone() && player_current_zone != black_hole_teleport_structs[i].script_string) {
				chosen_spot = black_hole_teleport_structs[i];
				break;
			}
		}
	}
	if (IsDefined(chosen_spot)) {
		player thread [[@zm_weap_quantum_bomb<scripts\zm\_zm_weap_quantum_bomb.gsc>::quantum_bomb_teleport]](chosen_spot);
	}
}