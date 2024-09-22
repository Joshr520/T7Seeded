detour zm_castle_tram<scripts\zm\zm_castle_tram.gsc>::function_1d6e73d0(e_player, s_spawn_pos, var_f2c2f39)
{
	n_randy = SRandomInt("zm_castle_tram_reward", 100);
	a_bonus_types = [];
	if (n_randy == 1 && level.round_number >= 5) {
		var_929a8e9b = 1;
	}
	else {
		if (n_randy <= 20 && level.round_number >= 5) {
			array::add(a_bonus_types, "bonus_points_team");
			array::add(a_bonus_types, "fire_sale");
		}
		else {
			array::add(a_bonus_types, "double_points");
			array::add(a_bonus_types, "insta_kill");
			array::add(a_bonus_types, "full_ammo");
			if (level.round_number >= 5) {
				array::add(a_bonus_types, "nuke");
			}
			if (IS_TRUE(e_player.hasriotshield) && e_player GetAmmoCount(e_player.weaponriotshield) !== e_player.weaponriotshield.maxammo) {
				array::add(a_bonus_types, "shield_charge");
			}
		}
	}
	var_a11baa62 = array("fire_sale", "double_points", "insta_kill", "full_ammo", "nuke");
	if (IS_TRUE(var_f2c2f39)) {
		var_8b961b44 = function_b29057c7(e_player);
		var_bd4efc7d = s_spawn_pos [[@zm_castle_tram<scripts\zm\zm_castle_tram.gsc>::function_b21df67c]](e_player, var_8b961b44);
	}
	else if (IS_TRUE(var_929a8e9b)) {
        var_8b961b44 = GetWeapon("ray_gun");
        var_2fd9a02f = zm_pap_util::get_triggers();
        if (zm_magicbox::treasure_chest_canplayerreceiveweapon(e_player, var_8b961b44, var_2fd9a02f)) {
            var_bd4efc7d = s_spawn_pos [[@zm_castle_tram<scripts\zm\zm_castle_tram.gsc>::function_b21df67c]](e_player, var_8b961b44);
        }
        else {
            var_bd4efc7d = zm_powerups::specific_powerup_drop("full_ammo", s_spawn_pos.origin);
            var_bd4efc7d thread [[@zm_castle_tram<scripts\zm\zm_castle_tram.gsc>::function_bb44b161]]("full_ammo", var_a11baa62);
        }
        var_929a8e9b = undefined;
    }
	else  {
        str_type = SArrayRandom(a_bonus_types, "zm_castle_tram_reward");
        var_bd4efc7d = zm_powerups::specific_powerup_drop(str_type, s_spawn_pos.origin);
        var_bd4efc7d thread [[@zm_castle_tram<scripts\zm\zm_castle_tram.gsc>::function_bb44b161]](str_type, var_a11baa62);
    }
	if (n_randy >= 97) {
		var_f1c9d472 = struct::get("tram_enemy_spawn_pos", "targetname");
		var_88af999e = zombie_utility::spawn_zombie(level.zombie_spawners[0], "tram_car_zombie", var_f1c9d472);
		PlayFX(level._effect["lightning_dog_spawn"], var_88af999e.origin);
	}
	var_bd4efc7d util::waittill_either("powerup_grabbed", "powerup_timedout");
}

detour zm_castle_tram<scripts\zm\zm_castle_tram.gsc>::function_b29057c7(player)
{
	return function_b29057c7(player);
}

function_b29057c7(player)
{
	var_fdd157a7 = [];
	array::add(var_fdd157a7, GetWeapon("cymbal_monkey"));
	array::add(var_fdd157a7, GetWeapon("shotgun_fullauto_upgraded"));
	array::add(var_fdd157a7, GetWeapon("ar_damage_upgraded"));
	var_fdd157a7 = SArrayRandomize(var_fdd157a7, "zm_castle_tram_weapon");
	return var_fdd157a7[0];
}