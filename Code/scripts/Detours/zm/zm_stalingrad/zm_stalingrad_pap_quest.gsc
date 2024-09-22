detour zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_809fbbff(var_db0ac3dc)
{
	if (level flag::get("drop_pod_active") || level flag::get("drop_pod_spawned")) {
		return;
	}
	level [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_3a92f7f]]();
	if (level.var_583e4a97.var_365bcb3c == 0) {
		var_1196aeee = [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_23b93c79]](var_db0ac3dc);
	}
	else {
		level.var_583e4a97.var_5d8406ed["fountain1"].b_available = 1;
		var_1196aeee = [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_a0a37968]](var_db0ac3dc);
	}
	var_e7a36389 = SArrayRandom(var_1196aeee, "zm_stalingrad_pap_groph_spawn");
	level.var_8cc024f2 = var_e7a36389;
	level thread [[@namespace_2e6e7fce<scripts\zm\zm_stalingrad_drop_pods.gsc>::function_d1a91c4f]](var_e7a36389);
}

detour zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_6236d848(var_e57afa84, var_7741a4b8, var_ed686791, var_2a448c91, var_16b2096, var_adb8dbea, var_2b71b5b4, var_15eb9a52, var_f92c3865, var_af22dd13, var_ed448d3b, var_e25e1ccc, str_flag1, str_flag2, str_notify_end, var_54939bf3 = 0)
{
	level.var_1dfcc9b2 = SpawnStruct();
	if (IsDefined(str_flag1)) {
		a_flags = [];
		if (!IsDefined(a_flags)) {
			a_flags = [];
		}
		else if (!IsArray(a_flags)) {
			a_flags = array(a_flags);
		}
		a_flags[a_flags.size] = str_flag1;
		if (IsDefined(str_flag2)) {
			if (!IsDefined(a_flags)) {
				a_flags = [];
			}
			else if (!IsArray(a_flags)) {
				a_flags = array(a_flags);
			}
			a_flags[a_flags.size] = str_flag2;
		}
		level flag::wait_till_all(a_flags);
	}
	if (IsDefined(str_notify_end)) {
		if (!level flag::exists(str_notify_end)) {
			level flag::init(str_notify_end);
		}
	}
	else {
		level thread [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_e4acaa37]]("vox_soph_controller_quest_lockdown_start_0");
	}
	level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_e7c75cf0]]();
	level flag::clear("zombie_drop_powerups");
	zm_spawner::deregister_zombie_death_event_callback(@namespace_2e6e7fce<scripts\zm\zm_stalingrad_drop_pods.gsc>::function_1389d425);
	level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_3804dbf1]]();
	level [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_adf4d1d0]]();
	level flag::clear("lockdown_complete");
	level flag::set("lockdown_active");
	level util::clientnotify("sndPD");
	level [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_451531f2]]();
	level.var_1dfcc9b2.var_9fa1b3e = [];
	var_8a56b631 = level.players.size;
	if (IsDefined(var_e57afa84)) {
		level.var_1dfcc9b2.var_9fa1b3e[0] = var_e57afa84 + (var_7741a4b8 * var_8a56b631);
		level.var_1dfcc9b2.var_9fa1b3e[1] = var_ed686791 + (var_2a448c91 * var_8a56b631);
		level.var_1dfcc9b2.var_9fa1b3e[2] = var_16b2096 + (var_adb8dbea * var_8a56b631);
	}
	level.var_1dfcc9b2.var_3eeb6c22[0] = 0;
	level.var_1dfcc9b2.var_3eeb6c22[1] = 1;
	level.var_1dfcc9b2.var_3eeb6c22[2] = 2;
	var_998322e5 = level.zombie_vars["zombie_spawn_delay"];
	if (var_998322e5 <= 0.1) {
		var_998322e5 = 0.1;
	}
	if (!IsDefined(level.var_1dfcc9b2.var_4560ec9a)) {
		level.var_1dfcc9b2.var_4560ec9a = [];
		level.var_1dfcc9b2.var_4560ec9a[0] = struct::get_array("lockdown_raz_spawner_east", "targetname");
		level.var_1dfcc9b2.var_4560ec9a[1] = struct::get_array("lockdown_raz_spawner_north", "targetname");
		level.var_1dfcc9b2.var_4560ec9a[2] = struct::get_array("lockdown_raz_spawner_west", "targetname");
	}
	level.var_1dfcc9b2.var_3eeb6c22 = SArrayRandomize(level.var_1dfcc9b2.var_3eeb6c22, "zm_stalingrad_pap_lockdown_location");
	[[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_188bdb42]]();
	[[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_d6ced80]](1);
	level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_2f621485]]();
	exploder::exploder("pavlov_" + 0);
	exploder::exploder("pavlov_" + 4);
	wait 2.5;
	var_ddb16ab3 = struct::get("lockdown_ammo_lower", "targetname");
	var_93eb638b = zm_powerups::specific_powerup_drop("full_ammo", var_ddb16ab3.origin + vectorscale((0, 0, 1), 48));
	var_93eb638b notify("powerup_reset");
	while (IsDefined(var_54939bf3) && var_54939bf3) {
        var_54939bf3 = function_6236d848_wave(var_54939bf3, var_e57afa84, var_7741a4b8, var_ed686791, var_2a448c91, var_16b2096, var_adb8dbea, var_2b71b5b4, var_15eb9a52, var_f92c3865, var_af22dd13, var_ed448d3b, var_e25e1ccc, str_flag1, str_flag2, str_notify_end, var_54939bf3, var_8a56b631);
    }
	level.var_1dfcc9b2.var_61126827 = undefined;
	level.var_a3559c05 = undefined;
	level flag::clear("lockdown_active");
	foreach (player in level.activeplayers) {
		player zm_score::add_to_player_score(500, 1);
		player notify(#"hash_1d89afbc");
	}
	level [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_2f621485]](0);
	[[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_d6ced80]](0);
	wait 2.5;
	[[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_f10ea3a8]]();
	exploder::exploder_stop("pavlov_" + 0);
	exploder::exploder_stop("pavlov_" + 4);
	zm_spawner::register_zombie_death_event_callback(@namespace_2e6e7fce<scripts\zm\zm_stalingrad_drop_pods.gsc>::function_1389d425);
	level flag::set("zombie_drop_powerups");
	level flag::set("lockdown_complete");
	level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_3804dbf1]](0);
	level util::clientnotify("sndPD");
	if (IsDefined(str_notify_end)) {
		level flag::clear(str_notify_end);
	}
	else
	{
		level thread [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_d2ea8c30]]();
		PlaySoundAtPosition("mus_stalingrad_underscore_pavlov_defend_end", (0, 0, 0));
	}
	if (IsDefined(var_93eb638b)) {
		var_93eb638b thread zm_powerups::powerup_timeout();
	}
}

function_6236d848_wave(var_54939bf3, var_e57afa84, var_7741a4b8, var_ed686791, var_2a448c91, var_16b2096, var_adb8dbea, var_2b71b5b4, var_15eb9a52, var_f92c3865, var_af22dd13, var_ed448d3b, var_e25e1ccc, str_flag1, str_flag2, str_notify_end, var_54939bf3, var_8a56b631)
{
	var_d98b610d = level.zombie_spawners[0];
    for (i = 0; i < 3; i++) {
        if (IsDefined(str_notify_end) && level flag::get(str_notify_end)) {
            level flag::clear("wave_event_raz_spawning_active");
        }
        else {
            var_879a13d6 = [];
            level.var_1dfcc9b2.var_22bf30b7 = level.var_1dfcc9b2.var_3eeb6c22[i];
            switch (level.var_1dfcc9b2.var_22bf30b7) {
                case 2: {
                    var_879a13d6 = ArrayCopy(level.var_1dfcc9b2.var_1865827a);
                    break;
                }
                case 1: {
                    var_879a13d6 = ArrayCopy(level.var_1dfcc9b2.var_3ec9c2c0);
                    break;
                }
                case 0: {
                    var_879a13d6 = ArrayCopy(level.var_1dfcc9b2.var_6c74b6c8);
                    break;
                }
            }
        }
        level thread [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_f4ceb3f8]]();
        level [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_3d5f2c8e]](level.var_1dfcc9b2.var_22bf30b7);
        if (i > 0) {
            level thread [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_e4acaa37]]("vox_soph_controller_quest_wave_start_2");
        }
        var_939defa4 = [];
        if (IsDefined(var_e57afa84)) {
            if (IsDefined(var_2b71b5b4)) {
                var_b4fcee85 = int((level.var_1dfcc9b2.var_9fa1b3e[i] / var_2b71b5b4) / 2);
                if (!IsDefined(var_939defa4)) {
                    var_939defa4 = [];
                }
                else if (!IsArray(var_939defa4)) {
                    var_939defa4 = array(var_939defa4);
                }
                var_939defa4[var_939defa4.size] = "wave_event_raz_spawning_active";
                level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_b55ebb81]](level.var_1dfcc9b2.var_4560ec9a[level.var_1dfcc9b2.var_22bf30b7], var_2b71b5b4, var_15eb9a52, var_f92c3865, var_b4fcee85, str_notify_end);
            }
            level function_f70dde0b(var_d98b610d, var_879a13d6, "lockdown_zombie", 22, var_998322e5, level.var_1dfcc9b2.var_9fa1b3e[i], undefined, 0);
        }
        else if (IsDefined(var_2b71b5b4)) {
            if (!IsDefined(var_939defa4)) {
                var_939defa4 = [];
            }
            else if (!IsArray(var_939defa4)) {
                var_939defa4 = array(var_939defa4);
            }
            var_939defa4[var_939defa4.size] = "wave_event_raz_spawning_active";
            level [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_b55ebb81]](level.var_1dfcc9b2.var_4560ec9a[level.var_1dfcc9b2.var_22bf30b7], var_2b71b5b4, var_15eb9a52, var_f92c3865, undefined);
        }
        if (var_939defa4.size > 0) {
            level flag::wait_till_clear_all(var_939defa4);
        }
        var_998322e5 = var_998322e5 - (0.1 * var_8a56b631);
        if (var_998322e5 < 0.1) {
            var_998322e5 = 0.1;
        }
        var_f92c3865 = var_f92c3865 - (0.1 * var_8a56b631);
        if (var_f92c3865 < 0.1) {
            var_f92c3865 = 0.1;
        }
        wait 0.5;
        [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_187a933f]](level.var_1dfcc9b2.var_22bf30b7);
        exploder::exploder("pavlov_" + 4);
        level notify(#"hash_d2eac5fe");
        level thread [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_e4acaa37]]("vox_soph_controller_quest_wave_end_1");
        wait 2.5;
        if (IsDefined(str_notify_end) && level flag::get(str_notify_end)) {
            break;
        }
    }
    if (!IsDefined(str_notify_end) || !level flag::get(str_notify_end)) {
        var_965b4c33 = ArrayCopy(level.var_1dfcc9b2.var_1865827a);
        var_965b4c33 = ArrayCombine(var_965b4c33, level.var_1dfcc9b2.var_3ec9c2c0, 0, 0);
        var_965b4c33 = ArrayCombine(var_965b4c33, level.var_1dfcc9b2.var_6c74b6c8, 0, 0);
        var_4a86a85 = ArrayCopy(level.var_1dfcc9b2.var_4560ec9a[0]);
        var_4a86a85 = ArrayCombine(var_4a86a85, level.var_1dfcc9b2.var_4560ec9a[1], 0, 0);
        var_4a86a85 = ArrayCombine(var_4a86a85, level.var_1dfcc9b2.var_4560ec9a[2], 0, 0);
        var_b4fcee85 = 3;
        level thread [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_f4ceb3f8]]();
        for (i = 0; i < 3; i++) {
            switch (i) {
                case 0: {
                    var_a48df19e = "east";
                    break;
                }
                case 1: {
                    var_a48df19e = "north";
                    break;
                }
                case 2: {
                    var_a48df19e = "west";
                    break;
                }
            }
            var_98782f9e = struct::get("lockdown_shutter_explosion_" + var_a48df19e, "targetname");
            level thread [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_1a7c9b89]](var_a48df19e);
            PlayRumbleOnPosition("zm_stalingrad_lockdown_shutter_destroyed", var_98782f9e.origin);
            util::wait_network_frame();
        }
        [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_f10ea3a8]]();
        exploder::exploder_stop("pavlov_" + 0);
        exploder::exploder_stop("pavlov_" + 4);
        util::wait_network_frame();
        level thread [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_e4acaa37]]("vox_soph_controller_quest_wave_start_2");
        var_939defa4 = [];
        if (IsDefined(var_e57afa84)) {
            if (IsDefined(var_2b71b5b4)) {
                if (!IsDefined(var_939defa4)) {
                    var_939defa4 = [];
                }
                else if (!IsArray(var_939defa4)) {
                    var_939defa4 = array(var_939defa4);
                }
                var_939defa4[var_939defa4.size] = "wave_event_raz_spawning_active";
                level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_b55ebb81]](var_4a86a85, var_2b71b5b4, var_15eb9a52, var_f92c3865, var_b4fcee85, str_notify_end);
                util::wait_network_frame();
            }
            if (IsDefined(var_af22dd13)) {
                if (!IsDefined(var_939defa4)) {
                    var_939defa4 = [];
                }
                else if (!IsArray(var_939defa4)) {
                    var_939defa4 = array(var_939defa4);
                }
                var_939defa4[var_939defa4.size] = "wave_event_sentinel_spawning_active";
                level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_923f7f72]](var_af22dd13, var_ed448d3b, var_e25e1ccc, undefined);
                util::wait_network_frame();
            }
            n_max_zombies = var_16b2096 + ((var_adb8dbea * var_8a56b631) * 2);
            level function_f70dde0b(var_d98b610d, var_965b4c33, "lockdown_zombie", 22, var_998322e5, n_max_zombies, undefined, 0);
        }
        else if (IsDefined(var_2b71b5b4)) {
            if (IsDefined(var_af22dd13)) {
                if (!IsDefined(var_939defa4)) {
                    var_939defa4 = [];
                }
                else if (!IsArray(var_939defa4)) {
                    var_939defa4 = array(var_939defa4);
                }
                var_939defa4[var_939defa4.size] = "wave_event_sentinel_spawning_active";
                level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_923f7f72]](var_af22dd13, var_ed448d3b, var_e25e1ccc, undefined);
                util::wait_network_frame();
            }
            if (!IsDefined(var_939defa4)) {
                var_939defa4 = [];
            }
            else if (!IsArray(var_939defa4)) {
                var_939defa4 = array(var_939defa4);
            }
            var_939defa4[var_939defa4.size] = "wave_event_raz_spawning_active";
            level [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_b55ebb81]](var_4a86a85, var_2b71b5b4, var_15eb9a52, var_f92c3865, undefined);
        }
        if (var_939defa4.size > 0) {
            level flag::wait_till_clear_all(var_939defa4);
        }
        [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_188bdb42]]();
        exploder::exploder("pavlov_" + 4);
    }
    level notify(#"hash_d2eac5fe");
    if (IsDefined(str_notify_end) && level flag::get(str_notify_end)) {
        var_54939bf3 = 0;
    }
    return var_54939bf3;
}

detour zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_2c6fd7(var_2b71b5b4, var_15eb9a52, var_f92c3865, var_13d1e831)
{
	[[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_d6ced80]](1);
	level.var_1dfcc9b2 = SpawnStruct();
	level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_e7c75cf0]]();
	level flag::clear("zombie_drop_powerups");
	zm_spawner::deregister_zombie_death_event_callback(@namespace_2e6e7fce<scripts\zm\zm_stalingrad_drop_pods.gsc>::function_1389d425);
	level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_3804dbf1]]();
	level [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_adf4d1d0]]();
	level flag::clear("lockdown_complete");
	level flag::set("lockdown_active");
	level util::clientnotify("sndEED");
	level [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_451531f2]]();
	level.var_1dfcc9b2.var_9fa1b3e = [];
	var_8a56b631 = level.players.size;
	level.var_1dfcc9b2.var_3eeb6c22[0] = 0;
	level.var_1dfcc9b2.var_3eeb6c22[1] = 1;
	level.var_1dfcc9b2.var_3eeb6c22[2] = 2;
	var_998322e5 = level.zombie_vars["zombie_spawn_delay"];
	if (var_998322e5 <= 0.1) {
		var_998322e5 = 0.1;
	}
	if (!IsDefined(level.var_1dfcc9b2.var_4560ec9a)) {
		level.var_1dfcc9b2.var_4560ec9a = [];
		level.var_1dfcc9b2.var_4560ec9a[0] = struct::get_array("lockdown_raz_spawner_east", "targetname");
		level.var_1dfcc9b2.var_4560ec9a[1] = struct::get_array("lockdown_raz_spawner_north", "targetname");
		level.var_1dfcc9b2.var_4560ec9a[2] = struct::get_array("lockdown_raz_spawner_west", "targetname");
	}
	level.var_1dfcc9b2.var_3eeb6c22 = SArrayRandomize(level.var_1dfcc9b2.var_3eeb6c22, "zm_stalingrad_pap_lockdown_location");
	[[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_188bdb42]]();
	level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_2f621485]]();
	exploder::exploder("pavlov_" + 0);
	exploder::exploder("pavlov_" + 4);
	wait 2.5;
	var_d98b610d = level.zombie_spawners[0];
	var_ddb16ab3 = struct::get("lockdown_ammo_lower", "targetname");
	var_93eb638b = zm_powerups::specific_powerup_drop("full_ammo", var_ddb16ab3.origin + vectorscale((0, 0, 1), 48));
	var_93eb638b notify("powerup_reset");
	for (i = 0; i < 3; i++) {
		if (level flag::get(var_13d1e831)) {
			level flag::clear("wave_event_raz_spawning_active");
		}
		else {
			var_879a13d6 = [];
			level.var_1dfcc9b2.var_22bf30b7 = level.var_1dfcc9b2.var_3eeb6c22[i];
			switch (level.var_1dfcc9b2.var_22bf30b7) {
				case 2: {
					var_879a13d6 = ArrayCopy(level.var_1dfcc9b2.var_1865827a);
					break;
				}
				case 1: {
					var_879a13d6 = ArrayCopy(level.var_1dfcc9b2.var_3ec9c2c0);
					break;
				}
				case 0: {
					var_879a13d6 = ArrayCopy(level.var_1dfcc9b2.var_6c74b6c8);
					break;
				}
			}
		}
		level thread [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_f4ceb3f8]]();
		level [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_3d5f2c8e]](level.var_1dfcc9b2.var_22bf30b7);
		if (i > 0) {
			level thread [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_e4acaa37]]("vox_soph_controller_quest_wave_start_2");
		}
		var_939defa4 = [];
		if (!IsDefined(var_939defa4))
		{
			var_939defa4 = [];
		}
		else if (!IsArray(var_939defa4)) {
			var_939defa4 = array(var_939defa4);
		}
		var_939defa4[var_939defa4.size] = "wave_event_raz_spawning_active";
		level [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_b55ebb81]](level.var_1dfcc9b2.var_4560ec9a[level.var_1dfcc9b2.var_22bf30b7], var_2b71b5b4, var_15eb9a52, var_f92c3865, undefined);
		if (var_939defa4.size > 0) {
			level flag::wait_till_clear_all(var_939defa4);
		}
		var_f92c3865 = var_f92c3865 - (0.1 * var_8a56b631);
		if (var_f92c3865 < 0.1) {
			var_f92c3865 = 0.1;
		}
		wait 0.5;
		[[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_187a933f]](level.var_1dfcc9b2.var_22bf30b7);
		exploder::exploder("pavlov_" + 4);
		level notify(#"hash_d2eac5fe");
		level thread [[@zm_stalingrad_vo<scripts\zm\zm_stalingrad_vo.gsc>::function_e4acaa37]]("vox_soph_controller_quest_wave_end_1");
		wait 2.5;
		if (level flag::get(var_13d1e831)) {
			break;
		}
	}
	if (!level flag::get(var_13d1e831)) {
		var_4a86a85 = ArrayCopy(level.var_1dfcc9b2.var_4560ec9a[0]);
		var_4a86a85 = ArrayCombine(var_4a86a85, level.var_1dfcc9b2.var_4560ec9a[1], 0, 0);
		var_4a86a85 = ArrayCombine(var_4a86a85, level.var_1dfcc9b2.var_4560ec9a[2], 0, 0);
		level thread [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_f4ceb3f8]]();
		for (i = 0; i < 3; i++) {
			switch (i) {
				case 0: {
					var_a48df19e = "east";
					break;
				}
				case 1: {
					var_a48df19e = "north";
					break;
				}
				case 2: {
					var_a48df19e = "west";
					break;
				}
			}
			var_98782f9e = struct::get("lockdown_shutter_explosion_" + var_a48df19e, "targetname");
			level thread [[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_1a7c9b89]](var_a48df19e);
			PlayRumbleOnPosition("zm_stalingrad_lockdown_shutter_destroyed", var_98782f9e.origin);
			util::wait_network_frame();
		}
		[[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_f10ea3a8]]();
		exploder::exploder_stop("pavlov_" + 0);
		exploder::exploder_stop("pavlov_" + 4);
		util::wait_network_frame();
		level [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_b55ebb81]](var_4a86a85, undefined, var_15eb9a52, var_f92c3865, undefined, var_13d1e831);
		[[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_188bdb42]]();
		exploder::exploder("pavlov_" + 4);
	}
	level notify(#"hash_d2eac5fe");
	level.var_1dfcc9b2.var_61126827 = undefined;
	level.var_a3559c05 = undefined;
	level flag::clear("lockdown_active");
	foreach (player in level.activeplayers) {
		player zm_score::add_to_player_score(500, 1);
		player notify(#"hash_1d89afbc");
	}
	level [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_2f621485]](0);
	[[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_d6ced80]](0);
	wait 2.5;
	[[@zm_stalingrad_pap<scripts\zm\zm_stalingrad_pap_quest.gsc>::function_f10ea3a8]]();
	exploder::exploder_stop("pavlov_" + 0);
	exploder::exploder_stop("pavlov_" + 4);
	zm_spawner::register_zombie_death_event_callback(@namespace_2e6e7fce<scripts\zm\zm_stalingrad_drop_pods.gsc>::function_1389d425);
	level flag::set("zombie_drop_powerups");
	level flag::set("lockdown_complete");
	level thread [[@zm_stalingrad_util<scripts\zm\zm_stalingrad_util.gsc>::function_3804dbf1]](0);
	level util::clientnotify("sndPD");
	level flag::clear(var_13d1e831);
	if (IsDefined(var_93eb638b)) {
		var_93eb638b thread zm_powerups::powerup_timeout();
	}
}