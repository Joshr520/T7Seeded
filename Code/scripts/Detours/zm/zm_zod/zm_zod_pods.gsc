detour zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::harvest_fungus_pod(e_harvester)
{
	self.model clientfield::increment("pod_harvest");
	e_harvester thread zm_audio::create_and_play_dialog("sprayer", "use");
	wait 0.1;
	self.harvested_in_round = level.round_number;
	zm_unitrigger::unregister_unitrigger(self.trigger);
	self.trigger = undefined;
	self notify("harvested", e_harvester);
	var_785a5f87 = self.n_pod_level;
	self.n_pod_level = 0;
	self.model clientfield::set("update_fungus_pod_level", self.n_pod_level);
	wait (GetAnimLength(("p7_fxanim_zm_zod_fungus_pod_stage" + var_785a5f87) + "_death_bundle")) - 0.5;
	e_harvester RecordMapEvent(24, GetTime(), self.origin, level.round_number, var_785a5f87);
	level notify(("pod_" + self.script_int) + "_harvested");
	n_roll = SRandomInt("zm_zod_pods_reward", 100);
	n_cumulation = 0;
	var_68a89987 = 0;
	foreach (s_reward in level.fungus_pods.rewards[var_785a5f87]) {
		if (s_reward.type == "weapon") {
			s_reward.do_not_consider = [[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::function_b0138b1]](s_reward.item);
		}
		if (IS_TRUE(s_reward.do_not_consider)) {
			continue;
		}
		n_cumulation = n_cumulation + s_reward.chance;
		if (n_cumulation >= n_roll || IS_TRUE(self.s_reward_forced)) {
			var_68a89987 = 1;
			switch (s_reward.type) {
				case "craftable": {
					s_reward.do_not_consider = 1;
					[[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::normalize_reward_chances]]();
					PlaySoundAtPosition("evt_zod_pod_open_craftable", self.origin);
					drop_point = self.origin + VectorScale((0, 0, 1), 36);
					[[@zm_zod_idgun_quest<scripts\zm\zm_zod_idgun_quest.gsc>::special_craftable_spawn]](drop_point, "part_skeleton");
					if (level flag::get("part_skeleton" + "_found")) {
						break;
					}
					else {
						mdl_part = level zm_craftables::get_craftable_piece_model("idgun", "part_skeleton");
						var_55d0f940 = struct::get("safe_place_for_items", "targetname");
						mdl_part.origin = var_55d0f940.origin;
						s_reward.do_not_consider = 0;
						[[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::normalize_reward_chances]]();
					}
					break;
				}
				case "grenade": {
					v_spawnpt = self.origin;
					grenade = GetWeapon("frag_grenade");
					n_rand = SRandomIntRange("zm_zod_pods_reward", 0, 4);
					e_harvester MagicGrenadeType(grenade, v_spawnpt, VectorScale((0, 0, 1), 300), 3);
					PlaySoundAtPosition("evt_zod_pod_open_grenade", self.origin);
					if (n_rand)
					{
						wait 0.3;
						if (SCoinToss("zm_zod_pods_reward")) {
							e_harvester MagicGrenadeType(grenade, v_spawnpt, VectorScale((0, 0, 1), 300), 3);
						}
					}
					break;
				}
				case "parasite": {
					if (IsDefined(e_harvester)) {
						array::add(level.a_wasp_priority_targets, e_harvester);
					}
					s_temp = SpawnStruct();
					s_temp.origin = self.origin + VectorScale((0, 0, 1), 30);
					var_b20468d0 = zm_zod_special_wasp_spawn(1, s_temp, 32, 32, 1, 1, 1);
					if (!IsPointInNavVolume(var_b20468d0.origin, "navvolume_small")) {
						v_nearest_navmesh_point = var_b20468d0 GetClosestPointOnNavVolume(s_temp.origin, 100);
						if (IsDefined(v_nearest_navmesh_point)) {
							var_b20468d0.origin = v_nearest_navmesh_point;
						}
					}
					break;
				}
				case "powerup": {
					str_item = s_reward.item;
					while (!IsDefined(str_item) || (str_item === "full_ammo" && var_785a5f87 != 3)) {
						str_item = zm_powerups::get_valid_powerup();
					}
					if (IsDefined(s_reward.count) && str_item == "bonus_points_team") {
						level.fungus_pods.bonus_points_amount = s_reward.count;
					}
					zm_powerups::specific_powerup_drop(str_item, self.origin, undefined, undefined, 1);
					break;
				}
				case "weapon": {
					PlaySoundAtPosition("evt_zod_pod_open_weapon", self.origin);
					self thread [[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::dig_up_weapon]](e_harvester, s_reward.item);
					break;
				}
				case "zombie": {
					s_temp = SpawnStruct();
					s_temp.origin = [[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::function_c9466e61]](self.origin, 20);
					if (!IsDefined(s_temp.origin)) {
						s_temp.origin = self.origin;
					}
					s_temp.script_noteworthy = "riser_location";
					s_temp.script_string = "find_flesh";
					zombie_utility::spawn_zombie(level.zombie_spawners[0], "aether_zombie", s_temp);
					break;
				}
				case "shield_recharge": {
					v_origin = [[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::function_c9466e61]](self.origin, 20);
					var_7905adb2 = [[@rocketshield<scripts\zm\_zm_weap_rocketshield.gsc>::create_bottle_unitrigger]](v_origin, (0, 0, 0));
					var_7905adb2 thread [[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::function_92f587b4]]();
					break;
				}
				default: {
					break;
				}
			}
			break;
		}
	}
	if (!var_68a89987) {
		str_item = zm_powerups::get_valid_powerup();
		zm_powerups::specific_powerup_drop(str_item, self.origin, undefined, undefined, 1);
	}
	ArrayRemoveValue(level.fungus_pods.a_e_spawned, self);
	if (!IsDefined(level.fungus_pods.a_e_unspawned)) {
		level.fungus_pods.a_e_unspawned = [];
	}
	else if (!IsArray(level.fungus_pods.a_e_unspawned)) {
		level.fungus_pods.a_e_unspawned = array(level.fungus_pods.a_e_unspawned);
	}
	level.fungus_pods.a_e_unspawned[level.fungus_pods.a_e_unspawned.size] = self;
}

detour zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::respawn_fungus_pods()
{
	return respawn_fungus_pods();
}

respawn_fungus_pods()
{
	level flag::wait_till("start_zombie_round_logic");
	for (i = 0; i < level.fungus_pods.a_e_unspawned.size; i++) {
		e_pod = level.fungus_pods.a_e_unspawned[i];
		e_pod.zone = zm_zonemgr::get_zone_from_position(e_pod.origin + VectorScale((0, 0, 1), 20), 1);
		if (!IsDefined(e_pod.zone)) {
			ArrayRemoveValue(level.fungus_pods.a_e_unspawned, e_pod);
		}
	}
	n_pods = Int(0.4 * level.fungus_pods.a_e_unspawned.size);
	spawn_fungus_pods(n_pods);
	for (;;) {
		level util::waittill_any("between_round_over", "debug_pod_spawn");
		if (level.round_number < 4 && !level flag::get("any_player_has_pod_sprayer") && !IS_TRUE(level.debug_pod_spawn_all)) {
			continue;
		}
		n_pods = SRandomIntRange("zm_zod_pods_respawn", 3, 6);
		if (IS_TRUE(level.debug_pod_spawn_all)) {
			n_pods = 1000;
		}
		spawn_fungus_pods(n_pods);
	}
}

detour zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::fungus_pod_upgrade_think()
{
	self endon("harvested");
	rounds_since_upgrade = 0;
	if (IsDefined(self.zone)) {
		zm_zonemgr::zone_wait_till_enabled(self.zone);
	}
	if (level clientfield::get("bm_superbeast")) {
		self [[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::fungus_pod_upgrade]](3);
	}
	for (;;) {
		level util::waittill_any("between_round_over", "debug_pod_spawn");
		rounds_since_upgrade++;
		n_upgrade_odds = level.fungus_pods.upgrade_odds[rounds_since_upgrade];
		if (!IsDefined(n_upgrade_odds)) {
			n_upgrade_odds = 1;
		}
		else if (IS_TRUE(level.debug_pod_spawn_all)) {
			n_upgrade_odds = 1;
		}
		else if (n_upgrade_odds == 0) {
			continue;
		}
		if (SRandomFloat("zm_zod_pods_upgrade", 1) <= n_upgrade_odds) {
			self [[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::fungus_pod_upgrade]]();
			rounds_since_upgrade = 0;
			if (self.n_pod_level >= 3) {
				return;
			}
		}
	}
}

detour zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::__main__()
{
	level flag::wait_till("start_zombie_round_logic");
	if (GetDvarInt("splitscreen_playerCount") > 2) {
		return;
	}
	level.fungus_pods.a_e_unspawned = struct::get_array("fungus_pod", "targetname");
	level.fungus_pods.a_e_spawned = [];
	foreach (e_fungus_pod in level.fungus_pods.a_e_unspawned) {
		e_fungus_pod.model = util::spawn_model("tag_origin", e_fungus_pod.origin, e_fungus_pod.angles);
		if (IsDefined(e_fungus_pod.script_noteworthy) && e_fungus_pod.script_noteworthy == "active") {
			e_fungus_pod.n_pod_level = 1;
		}
		else {
			e_fungus_pod.n_pod_level = 0;
		}
		e_fungus_pod.model clientfield::set("update_fungus_pod_level", 4);
	}
	level.fungus_pods.sprayers = [];
	a_sprayers = struct::get_array("pod_sprayer_location", "targetname");
	a_sprayers = SArrayRandomize(a_sprayers, "zm_zod_pods_sprayers");
	a_chosen = [];
	foreach (s_sprayer in a_sprayers) {
		if (IsDefined(a_chosen[s_sprayer.script_int])) {
			continue;
		}
		a_chosen[s_sprayer.script_int] = s_sprayer;
	}
	foreach (s_sprayer in a_chosen) {
		s_sprayer thread [[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::pod_sprayer_think]]();
	}
	thread [[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::fungus_pod_clip_init]]();
	level thread respawn_fungus_pods();
}

detour zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::spawn_fungus_pods(n_pods)
{
	return spawn_fungus_pods(n_pods);
}

spawn_fungus_pods(n_pods)
{
	if (level flag::get("hide_pods_for_trailer")) {
		return;
	}
	a_available = [];
	foreach (e_pod in level.fungus_pods.a_e_unspawned) {
		if (IsDefined(e_pod.harvested_in_round)) {
			n_rounds_since_spawn = level.round_number - e_pod.harvested_in_round;
			if (n_rounds_since_spawn < 2 && !IS_TRUE(level.debug_pod_spawn_all)) {
				continue;
			}
		}
		b_skip_pod = 0;
		a_players = GetPlayers();
		foreach (player in a_players) {
			if (Distance(player.origin, e_pod.origin) < 200) {
				b_skip_pod = 1;
				break;
			}
		}
		if (b_skip_pod) {
			continue;
		}
		if (!IsDefined(a_available)) {
			a_available = [];
		}
		else if (!IsArray(a_available)) {
			a_available = array(a_available);
		}
		a_available[a_available.size] = e_pod;
	}
	a_available = SArrayRandomize(a_available, "zm_zod_pods_spawn_pods");
	a_spawned_zones = [];
	for (i = 0; i < n_pods && a_available.size > 0; i++) {
		n_index = a_available.size - 1;
		s_pod = a_available[n_index];
		if (n_pods <= 5 && IsDefined(s_pod.zone) && IsDefined(a_spawned_zones[s_pod.zone])) {
			continue;
		}
		ArrayRemoveValue(level.fungus_pods.a_e_unspawned, s_pod);
		ArrayRemoveIndex(a_available, n_index);
		if (!IsDefined(level.fungus_pods.a_e_spawned)) {
			level.fungus_pods.a_e_spawned = [];
		}
		else if (!IsArray(level.fungus_pods.a_e_spawned)) {
			level.fungus_pods.a_e_spawned = array(level.fungus_pods.a_e_spawned);
		}
		level.fungus_pods.a_e_spawned[level.fungus_pods.a_e_spawned.size] = s_pod;
		s_pod.n_pod_level = 1;
		level notify(("pod_" + s_pod.script_int) + "_hatched");
		s_pod.model clientfield::set("update_fungus_pod_level", s_pod.n_pod_level);
		s_pod thread [[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::function_e1065706]]();
		s_pod thread [[@zm_zod_pods<scripts\zm\zm_zod_pods.gsc>::fungus_pod_think]]();
		if (IsDefined(s_pod.zone)) {
			if (!IsDefined(a_spawned_zones[s_pod.zone])) {
				a_spawned_zones[s_pod.zone] = 0;
			}
			a_spawned_zones[s_pod.zone]++;
		}
	}
}