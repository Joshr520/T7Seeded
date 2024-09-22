detour zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::init_shovel()
{
	callback::on_connect(@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::init_shovel_player);
	a_shovel_pos = struct::get_array("shovel_location", "targetname");
	a_shovel_zone = [];
	foreach (s_shovel_pos in a_shovel_pos) {
		if (!IsDefined(a_shovel_zone[s_shovel_pos.script_noteworthy])) {
			a_shovel_zone[s_shovel_pos.script_noteworthy] = [];
		}
		a_shovel_zone[s_shovel_pos.script_noteworthy][a_shovel_zone[s_shovel_pos.script_noteworthy].size] = s_shovel_pos;
	}
	foreach (a_zone in a_shovel_zone) {
		s_pos = a_zone[SRandomInt("zm_tomb_dig_spawn", a_zone.size)];
		m_shovel = Spawn("script_model", s_pos.origin);
		m_shovel.angles = s_pos.angles;
		m_shovel SetModel("p7_zm_ori_tool_shovel");
		[[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::generate_shovel_unitrigger]](m_shovel);
	}
	level.get_player_perk_purchase_limit = @zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::get_player_perk_purchase_limit;
	level.bonus_points_powerup_override = ::bonus_points_powerup_override;
	level thread [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_powerups_tracking]]();
	level thread [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_spots_init]]();
	clientfield::register("world", "player0hasItem", 15000, 2, "int");
	clientfield::register("world", "player1hasItem", 15000, 2, "int");
	clientfield::register("world", "player2hasItem", 15000, 2, "int");
	clientfield::register("world", "player3hasItem", 15000, 2, "int");
	clientfield::register("world", "player0wearableItem", 15000, 1, "int");
	clientfield::register("world", "player1wearableItem", 15000, 1, "int");
	clientfield::register("world", "player2wearableItem", 15000, 1, "int");
	clientfield::register("world", "player3wearableItem", 15000, 1, "int");
}

detour zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_spots_respawn(a_dig_spots)
{
	for (;;) {
		level waittill("end_of_round");
		wait 2;
		a_dig_spots = SArrayRandomize(level.a_dig_spots, "zm_tomb_dig_respawn");
		n_respawned = 0;
		n_respawned_max = 3;
		if (level.weather_snow > 0) {
			n_respawned_max = 0;
		}
		else if (level.weather_rain > 0) {
			n_respawned_max = 5;
		}
		if (level.weather_snow == 0) {
			n_respawned_max = n_respawned_max + SRandomInt("zm_tomb_dig_respawn", GetPlayers().size);
		}
		for (i = 0; i < a_dig_spots.size; i++) {
			if (IS_TRUE(a_dig_spots[i].dug) && n_respawned < n_respawned_max && level.n_dig_spots_cur <= level.n_dig_spots_max) {
				a_dig_spots[i].dug = undefined;
				a_dig_spots[i] thread [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_spot_spawn]]();
				util::wait_network_frame();
				n_respawned++;
			}
		}
		if (level.weather_snow > 0 && level.ice_staff_pieces.size > 0) {
			foreach (s_staff in level.ice_staff_pieces) {
				a_staff_spots = [];
				n_active_mounds = 0;
				foreach (s_dig_spot in level.a_dig_spots) {
					if (IsDefined(s_dig_spot.str_zone) && IsSubStr(s_dig_spot.str_zone, s_staff.zone_substr)) {
						if (!IS_TRUE(s_dig_spot.dug)) {
							n_active_mounds++;
							continue;
						}
						a_staff_spots[a_staff_spots.size] = s_dig_spot;
					}
				}
				if (n_active_mounds < 2 && a_staff_spots.size > 0 && level.n_dig_spots_cur <= level.n_dig_spots_max) {
					n_index = SRandomInt("zm_tomb_dig_respawn", a_staff_spots.size);
					a_staff_spots[n_index].dug = undefined;
					a_staff_spots[n_index] thread [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_spot_spawn]]();
					ArrayRemoveIndex(a_staff_spots, n_index);
					n_active_mounds++;
					util::wait_network_frame();
				}
			}
		}
	}
}

detour zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::waittill_dug(s_dig_spot)
{
	for (;;) {
		self waittill("trigger", player);
		if (IsDefined(player.dig_vars["has_shovel"]) && player.dig_vars["has_shovel"]) {
			player PlaySound("evt_dig");
			s_dig_spot.dug = 1;
			level.n_dig_spots_cur--;
			PlayFX(level._effect["digging"], self.origin);
			player clientfield::set_to_player("player_rumble_and_shake", 1);
			s_staff_piece = s_dig_spot dig_spot_get_staff_piece(player);
			if (IsDefined(s_staff_piece)) {
				s_staff_piece [[@zm_tomb_main_quest<scripts\zm\zm_tomb_main_quest.gsc>::show_ice_staff_piece]](self.origin);
				player [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_reward_dialog]]("dig_staff_part");
			}
			else {
				n_good_chance = 50;
				if (player.dig_vars["n_spots_dug"] == 0 || player.dig_vars["n_losing_streak"] == 3) {
					player.dig_vars["n_losing_streak"] = 0;
					n_good_chance = 100;
				}
				if (player.dig_vars["has_upgraded_shovel"]) {
					if (!player.dig_vars["has_helmet"]) {
						n_helmet_roll = SRandomInt("zm_tomb_dig_reward", 100);
						if (n_helmet_roll >= 95) {
							player.dig_vars["has_helmet"] = 1;
							level clientfield::set([[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::function_6e5f017f]](player GetEntityNumber()), 1);
							player PlaySoundToPlayer("zmb_squest_golden_anything", player);
							player thread [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::function_85eef9f2]]();
							return;
						}
					}
					n_good_chance = 70;
				}
				n_prize_roll = SRandomInt("zm_tomb_dig_reward", 100);
				if (n_prize_roll > n_good_chance) {
					if (SCoinToss("zm_tomb_dig_reward")) {
						player [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_reward_dialog]]("dig_grenade");
						self thread dig_up_grenade(player);
					}
					else {
						player [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_reward_dialog]]("dig_zombie");
						self thread [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_up_zombie]](player, s_dig_spot);
					}
					player.dig_vars["n_losing_streak"]++;
				}
				else if (SCoinToss("zm_tomb_dig_reward")) {
                    self thread dig_up_powerup(player);
                }
                else {
                    player [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_reward_dialog]]("dig_gun");
                    self thread dig_up_weapon(player);
                }
			}
			if (!player.dig_vars["has_upgraded_shovel"]) {
				player.dig_vars["n_spots_dug"]++;
				if (player.dig_vars["n_spots_dug"] >= 30) {
					player.dig_vars["has_upgraded_shovel"] = 1;
					player thread ee_zombie_blood_dig();
					level clientfield::set([[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::function_f4768ce9]](player GetEntityNumber()), 2);
					player PlaySoundToPlayer("zmb_squest_golden_anything", player);
				}
			}
			return;
		}
	}
}

detour zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_up_powerup(player)
{
	return dig_up_powerup(player);
}

dig_up_powerup(player)
{
	powerup = Spawn("script_model", self.origin);
	powerup endon("powerup_grabbed");
	powerup endon("powerup_timedout");
	a_rare_powerups = [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_get_rare_powerups]](player);
	powerup_item = undefined;
	if ((level.dig_n_powerups_spawned + level.powerup_drop_count) > 4 || level.dig_last_prize_rare || a_rare_powerups.size == 0 || SRandomInt("zm_tomb_dig_powerup", 100) < 80) {
		if (level.dig_n_zombie_bloods_spawned < 1 && SRandomInt("zm_tomb_dig_powerup", 100) > 70) {
			powerup_item = "bonus_points_player";
			player [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_reward_dialog]]("dig_cash");
		}
		else {
			powerup_item = "bonus_points_player";
			player [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_reward_dialog]]("dig_cash");
		}
		level.dig_last_prize_rare = 0;
	}
	else {
		powerup_item = a_rare_powerups[SRandomInt("zm_tomb_dig_powerup", a_rare_powerups.size)];
		level.dig_last_prize_rare = 1;
		level.dig_n_powerups_spawned++;
		player [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_reward_dialog]]("dig_powerup");
		[[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_set_powerup_spawned]](powerup_item);
	}
	powerup zm_powerups::powerup_setup(powerup_item);
	powerup MoveZ(40, 0.6);
	powerup waittill("movedone");
	powerup thread zm_powerups::powerup_timeout();
	powerup thread zm_powerups::powerup_wobble();
	powerup thread zm_powerups::powerup_grab();
}

detour zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_up_weapon(player)
{
	return dig_up_weapon(player);
}

dig_up_weapon(digger)
{
	var_43f586fe = array(GetWeapon("pistol_c96"), GetWeapon("ar_marksman"), GetWeapon("shotgun_pump"));
	var_63eba41d = array(GetWeapon("sniper_fastsemi"), GetWeapon("shotgun_fullauto"));
	if (digger.dig_vars["has_upgraded_shovel"]) {
		var_63eba41d = ArrayCombine(var_63eba41d, array(GetWeapon("bouncingbetty"), GetWeapon("ar_stg44"), GetWeapon("smg_standard"), GetWeapon("smg_mp40_1940"), GetWeapon("shotgun_precision")), 0, 0);
	}
	var_59d5868d = undefined;
	if (SRandomInt("zm_tomb_dig_weapon", 100) < 90) {
		var_59d5868d = var_43f586fe[GetArrayKeys(var_43f586fe)[SRandomInt("zm_tomb_dig_weapon", GetArrayKeys(var_43f586fe).size)]];
	}
	else {
		var_59d5868d = var_63eba41d[GetArrayKeys(var_63eba41d)[SRandomInt("zm_tomb_dig_weapon", GetArrayKeys(var_63eba41d).size)]];
	}
	v_spawnpt = self.origin + (0, 0, 40);
	v_spawnang = (0, 0, 0);
	v_angles = digger GetPlayerAngles();
	v_angles = (0, v_angles[1], 0) + VectorScale((0, 1, 0), 90) + v_spawnang;
	m_weapon = zm_utility::spawn_buildkit_weapon_model(digger, var_59d5868d, undefined, v_spawnpt, v_angles);
	m_weapon.angles = v_angles;
	m_weapon PlayLoopSound("evt_weapon_digup");
	m_weapon thread [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::timer_til_despawn]](v_spawnpt, 40 * -1);
	m_weapon endon("dig_up_weapon_timed_out");
	PlayFXOnTag(level._effect["powerup_on_solo"], m_weapon, "tag_origin");
	m_weapon.trigger = [[@zm_tomb_utility<scripts\zm\zm_tomb_utility.gsc>::tomb_spawn_trigger_radius]](v_spawnpt, 100, 1, undefined, @zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::weapon_trigger_update_prompt);
	m_weapon.trigger.cursor_hint = "HINT_WEAPON";
	m_weapon.trigger.cursor_hint_weapon = var_59d5868d;
	m_weapon.trigger waittill("trigger", player);
	m_weapon.trigger notify("weapon_grabbed");
	m_weapon.trigger thread [[@zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::swap_weapon]](var_59d5868d, player);
	if (IsDefined(m_weapon.trigger)) {
		zm_unitrigger::unregister_unitrigger(m_weapon.trigger);
		m_weapon.trigger = undefined;
	}
	if (IsDefined(m_weapon)) {
		m_weapon Delete();
	}
	if (player != digger) {
		digger notify("dig_up_weapon_shared");
	}
}

detour zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::dig_up_grenade(player)
{
	return dig_up_grenade(player);
}

dig_up_grenade(player)
{
	player endon("disconnect");
	v_spawnpt = self.origin;
	w_grenade = GetWeapon("frag_grenade");
	n_rand = SRandomIntRange("zm_tomb_dig_grenade", 0, 4);
	player MagicGrenadeType(w_grenade, v_spawnpt, VectorScale((0, 0, 1), 300), 3);
	player PlaySound("evt_grenade_digup");
	if (n_rand) {
		wait 0.3;
		if (SCoinToss("zm_tomb_dig_grenade")) {
			player MagicGrenadeType(w_grenade, v_spawnpt, (50, 50, 300), 3);
		}
	}
}

detour zm_tomb_dig<scripts\zm\zm_tomb_dig.gsc>::bonus_points_powerup_override()
{
	return bonus_points_powerup_override();
}

bonus_points_powerup_override()
{
	points = SRandomIntRange("zm_tomb_dig_points", 1, 6) * 50;
	return points;
}