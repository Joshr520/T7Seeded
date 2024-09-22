detour zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::main()
{
	level.var_b34be0cd = array(0, 1, 2, 0, 3);
	level.var_53df8575 = array(0, "p7_zm_isl_pedestal_battle", "p7_zm_isl_pedestal_blood", "p7_zm_isl_pedestal_chaos", "p7_zm_isl_pedestal_doom");
	level.var_8b0a8fa9 = &"ZM_ISLAND_SKULL_GET";
	level.var_983da0e6 = &"ZM_ISLAND_SKULL_PUT";
	level.var_8b418269 = &"ZM_ISLAND_SKULL_START";
	level.var_452c59e0 = 0;
	level.var_3846d9a8 = 0;
	level.var_55c48492 = GetEnt("mdl_skullgun", "targetname");
	level.var_55c48492.var_5cd7e450 = level.var_55c48492.origin;
	level.var_55c48492.var_d7778aba = level.var_55c48492.angles;
	level.var_b2152df5 = struct::get("s_utrig_get_skullgun", "targetname");
	var_cdbcb282 = GetEntArray("mdl_skull_s", "targetname");
	var_a7ba3819 = GetEntArray("mdl_skull_p", "targetname");
	var_45f27370 = GetEntArray("mdl_skulltar", "targetname");
	var_9d3ee5ea = struct::get_array("s_skulltar_skull_pos", "targetname");
	var_71b2b241 = struct::get_array("s_skulltar_attractor_src", "targetname");
	var_ca0fb49a = struct::get_array("s_skulltar_base_pos", "targetname");
	var_d76f80e0 = struct::get_array("s_utrig_pillar", "targetname");
	var_4b5bea8 = struct::get_array("s_utrig_skulltar", "targetname");
	level.var_cdbcb282 = [];
	level.var_d76f80e0 = [];
	level.var_a576e0b9 = [];
	for (i = 1; i <= 4; i++) {
		level.var_a576e0b9[i] = SpawnStruct();
		level.var_a576e0b9[i].targetname = "skullquest_" + i;
		level.var_a576e0b9[i].var_d38f69da = [];
		level.var_a576e0b9[i].var_41335b73 = [];
		level.var_a576e0b9[i].var_ed98dfad = [];
		level.var_a576e0b9[i] flag::init("skullquest_completed");
		level flag::init("skull_p_retrieved_for_ritual_" + i);
	}
	var_ed98dfad = struct::get_array("s_skulltar_attack_pos", "targetname");
	foreach (s_skulltar_attack_pos in var_ed98dfad) {
		array::add(level.var_a576e0b9[s_skulltar_attack_pos.script_special].var_ed98dfad, s_skulltar_attack_pos);
	}
	for (i = 0; i < 4; i++) {
		level.var_cdbcb282[var_cdbcb282[i].script_special] = var_cdbcb282[i];
		level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s = var_cdbcb282[i];
		level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s.var_5cd7e450 = var_cdbcb282[i].origin;
		level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s.var_d7778aba = var_cdbcb282[i].angles;
		level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s.var_afb64bf6 = undefined;
		level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s.var_f7d3c273 = level.var_a576e0b9[var_cdbcb282[i].script_special].mdl_skull_s.script_special;
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p = var_a7ba3819[i];
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p.var_5cd7e450 = var_a7ba3819[i].origin;
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p.var_d7778aba = var_a7ba3819[i].angles;
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p.var_afb64bf6 = undefined;
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p Ghost();
		level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p.var_f7d3c273 = level.var_a576e0b9[var_a7ba3819[i].script_special].mdl_skull_p.script_special;
		level.var_d76f80e0[var_d76f80e0[i].script_special] = var_d76f80e0[i];
		level.var_a576e0b9[var_d76f80e0[i].script_special].s_utrig_pillar = var_d76f80e0[i];
		level.var_a576e0b9[var_4b5bea8[i].script_special].s_utrig_skulltar = var_4b5bea8[i];
		level.var_a576e0b9[var_9d3ee5ea[i].script_special].s_skulltar_skull_pos = var_9d3ee5ea[i];
		level.var_a576e0b9[var_71b2b241[i].script_special].s_skulltar_attractor_src = var_71b2b241[i];
		level.var_a576e0b9[var_ca0fb49a[i].script_special].s_skulltar_base_pos = var_ca0fb49a[i];
		level.var_a576e0b9[var_45f27370[i].script_special].mdl_skulltar = var_45f27370[i];
	}
	level.var_21406c35 = [];
	for (i = 0; i < 4; i++) {
		level.var_21406c35[i] = i + 1;
	}
	level.var_21406c35 = SArrayRandomize(level.var_21406c35, "zm_island_skullweapon_quest_location");
	for (i = 3; i >= 0; i--) {
		level.var_21406c35[i + 1] = level.var_21406c35[i];
	}
	var_5bdf835e = [];
	array::add(var_5bdf835e, "zone_start_water");
	array::add(var_5bdf835e, "zone_start");
	array::add(var_5bdf835e, "zone_start_2");
	var_35dd08f5 = [];
	array::add(var_35dd08f5, "zone_crash_site");
	array::add(var_35dd08f5, "zone_crash_site_2");
	var_fda8e8c = [];
	array::add(var_fda8e8c, "zone_operating_rooms");
	var_80db60d2 = [];
	array::add(var_80db60d2, "zone_cliffside");
	var_aa15c945 = [];
	var_aa15c945[1] = var_5bdf835e;
	var_aa15c945[2] = var_35dd08f5;
	var_aa15c945[3] = var_fda8e8c;
	var_aa15c945[4] = var_80db60d2;
	level.var_e534ade = GetEntArray("dais_center", "targetname");
	level.var_9046e7b0 = level.var_e534ade[0];
	if (IsDefined(level.var_9046e7b0)) {
		for (i = 1; i < level.var_e534ade.size; i++) {
			level.var_e534ade[i] LinkTo(level.var_9046e7b0);
		}
	}
	level scene::init("p7_fxanim_zm_island_alter_stairs_bundle");
	level.var_1a9b1b91 = GetEnt("dais_altar", "targetname");
	level.var_9046e7b0.var_9c93e17 = level.var_9046e7b0.origin;
	level.var_1a9b1b91.var_9c93e17 = level.var_1a9b1b91.origin;
	level.var_9046e7b0.v_open_pos = level.var_9046e7b0.origin - VectorScale((0, 0, 1), 256);
	level.var_1a9b1b91.v_open_pos = level.var_1a9b1b91.origin + VectorScale((1, 0, 0), 24);
	level.var_b10ab148 = 0;
	level flag::init("skull_quest_complete");
	for (i = 1; i <= 4; i++) {
		level.var_a576e0b9[i].script_special = i;
		level.var_a576e0b9[i].var_ba133ee2 = ("skullquest_ritual_" + level.var_a576e0b9[i].script_special) + "_fx";
		level.var_a576e0b9[i].origin = level.var_a576e0b9[i].s_skulltar_skull_pos.origin;
		level.var_a576e0b9[i].angles = level.var_a576e0b9[i].s_skulltar_skull_pos.angles;
		var_8fb7dd10 = "skullquest_ritual_failed_" + i;
		level [[@zm_island_vo<scripts\zm\zm_island_vo.gsc>::function_65f8953a]](var_8fb7dd10, "response", "negative", 5, 0, 0.5, level.var_a576e0b9[i].origin);
		var_4a347901 = ("skulltar_" + i) + "_spawnpts";
		level.var_a576e0b9[i].a_s_spawnpts = struct::get_array(var_4a347901, "targetname");
		level.var_a576e0b9[i].var_aa15c945 = var_aa15c945[i];
		var_c0032031 = level.var_21406c35[i];
		level.var_a576e0b9[i].mdl_skull_s = level.var_cdbcb282[var_c0032031];
		level.var_a576e0b9[i].mdl_skull_s.var_5cd7e450 = level.var_cdbcb282[var_c0032031].origin;
		level.var_a576e0b9[i].mdl_skull_s.var_d7778aba = level.var_cdbcb282[var_c0032031].angles;
		level.var_a576e0b9[i].mdl_skull_s.var_afb64bf6 = undefined;
		level.var_a576e0b9[i].mdl_skull_s.script_special = i;
		level.var_a576e0b9[i].mdl_skull_s clientfield::set("do_fade_material", 1);
		level.var_a576e0b9[i].mdl_skull_p SetModel(level.var_a576e0b9[i].mdl_skull_s.model);
		level.var_a576e0b9[i].mdl_skull_p.var_f7d3c273 = level.var_a576e0b9[i].mdl_skull_s.var_f7d3c273;
		level.var_a576e0b9[i].mdl_skulltar SetModel(level.var_53df8575[level.var_a576e0b9[i].mdl_skull_s.var_f7d3c273]);
		level.var_a576e0b9[i].s_utrig_pillar = level.var_d76f80e0[var_c0032031];
		level.var_a576e0b9[i].s_utrig_pillar.script_special = i;
		level.var_a576e0b9[i].s_utrig_pillar.script_string = "s_utrig_pillar_" + i;
		[[@zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::function_38f8b6e3]](i);
	}
	level flag::init("skullquest_ritual_inprogress1");
	level flag::init("skullquest_ritual_inprogress2");
	level flag::init("skullquest_ritual_inprogress3");
	level flag::init("skullquest_ritual_inprogress4");
	level flag::init("skullquest_ritual_complete1");
	level flag::init("skullquest_ritual_complete2");
	level flag::init("skullquest_ritual_complete3");
	level flag::init("skullquest_ritual_complete4");
	var_93999912 = [];
	var_93999912[1] = GetEnt("reveal_keeper_mural_01", "targetname");
	var_93999912[2] = GetEnt("reveal_keeper_mural_02", "targetname");
	var_93999912[3] = GetEnt("reveal_keeper_mural_03", "targetname");
	foreach (var_d9516038 in var_93999912) {
		if (IsDefined(var_d9516038)) {
			var_d9516038 clientfield::set("do_emissive_material", 0);
		}
	}
	var_c9260a5 = array("", "p7_fxanim_zm_island_altar_skull_battle_bundle", "p7_fxanim_zm_island_altar_skull_blood_bundle", "p7_fxanim_zm_island_altar_skull_chaos_bundle", "p7_fxanim_zm_island_altar_skull_doom_bundle");
	foreach (var_e7e46205 in var_c9260a5) {
		level thread scene::init(var_c9260a5);
	}
	level.var_4ffafd2 = 0;
	level.var_69fe775a = 0;
}

detour zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::function_ff1550bd()
{
	self endon("skullquest_ritual_abandoned" + self.script_special);
	level endon("skullquest_ritual_ended" + self.script_special);
	var_f2e38849 = self.script_special;
	self.var_bd61ef5b = 0;
	self.var_d38f69da = [];
	self.var_41335b73 = [];
	var_19b19369 = ("skull" + var_f2e38849) + "_attacker";
	a_spawners = [];
	var_89f44116 = level.zombie_spawners;
	var_64cc2fa5 = level.var_feebf312;
	var_6469b451 = level.var_c38a4fee;
	if (level.var_4ffafd2 > 0) {
		var_90d3df61 = level.var_4ffafd2;
	}
	else {
		var_90d3df61 = 0;
		for (i = 1; i <= 4; i++) {
			if (level flag::get("skullquest_ritual_complete" + i) || level flag::get("skullquest_ritual_inprogress" + i)) {
				var_90d3df61++;
			}
		}
	}
	var_63ba0b02 = 0;
	switch (var_90d3df61) {
		case 1: {
			a_spawners = var_89f44116;
			var_63ba0b02 = 1;
			var_8f4e08a8 = array(0, 3, 4, 5, 6);
			var_419b220b = array(0, 3, 4, 5, 6);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 0;
			break;
		}
		case 2: {
			a_spawners = array(var_6469b451[0], var_6469b451[0], var_6469b451[0], var_6469b451[0]);
			var_8f4e08a8 = array(0, 6, 7, 8, 9);
			var_419b220b = array(0, 4, 5, 6, 7);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 0;
			break;
		}
		case 3: {
			a_spawners = array(var_64cc2fa5[0], var_64cc2fa5[0], var_64cc2fa5[0], var_64cc2fa5[0]);
			var_8f4e08a8 = array(0, 6, 7, 8, 9);
			var_419b220b = array(0, 4, 5, 6, 7);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 1;
			break;
		}
		case 4: {
			a_spawners = array(var_6469b451[0], var_6469b451[0], var_6469b451[0], var_64cc2fa5[0]);
			var_8f4e08a8 = array(0, 6, 7, 8, 9);
			var_419b220b = array(0, 4, 5, 6, 7);
			self.var_9543b4d3 = 2;
			self.var_7905a128 = 0;
			break;
		}
	}
	var_eca4fee1 = var_8f4e08a8[level.activeplayers.size];
	var_3be27b2b = var_419b220b[level.activeplayers.size];
	self.var_eca4fee1 = var_eca4fee1;
	level.zombie_ai_limit = level.zombie_ai_limit - self.var_eca4fee1;
	var_d94cc36a = array(0, 1, 1, 1, 1);
	var_44da5f74 = var_d94cc36a[level.activeplayers.size];
	self.a_s_spawnpts = SArrayRandomize(self.a_s_spawnpts, "zm_island_skullweapon_quest_spawn_location");
	self.var_d8cdf3a = 1;
	while (!level flag::get("skullquest_ritual_complete" + self.script_special)) {
		for (i = 0; i < self.a_s_spawnpts.size; i++) {
			level.var_a576e0b9[var_f2e38849].var_41335b73 = array::remove_undefined(level.var_a576e0b9[var_f2e38849].var_41335b73);
			level.var_a576e0b9[var_f2e38849].var_d38f69da = array::remove_undefined(level.var_a576e0b9[var_f2e38849].var_d38f69da);
			while (GetFreeActorCount() < 1) {
				wait 0.05;
			}
			while (level.var_a576e0b9[var_f2e38849].var_d38f69da.size >= var_eca4fee1) {
				wait 0.05;
			}
			if (IsDefined(self.var_7905a128) && self.var_7905a128 == 1 && self.var_bd61ef5b == 0) {
				e_spawner = var_64cc2fa5[0];
			}
			else
			{
				if (IS_TRUE(self.var_d8cdf3a) || level.var_a576e0b9[var_f2e38849].var_41335b73.size < 2) {
					e_spawner = var_89f44116[0];
				}
				else {
					e_spawner = SArrayRandom(a_spawners, "zm_island_skullweapon_quest_spawn_location");
				}
			}
			self.var_d8cdf3a = !self.var_d8cdf3a;
			ai_attacker = undefined;
			self.a_s_spawnpts[i].script_string = "";
			if (IsDefined(e_spawner) && IsDefined(e_spawner.script_noteworthy)) {
				switch (e_spawner.script_noteworthy) {
					case "zombie_spawner": {
						if (level.var_a576e0b9[var_f2e38849].var_41335b73.size < var_3be27b2b) {
							self.a_s_spawnpts[i].script_string = "find_flesh";
							self.a_s_spawnpts[i].script_noteworthy = "spawn_location";
							ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369, self.a_s_spawnpts[i]);
						}
						break;
					}
					case "zombie_thrasher_spawner": {
						if (level.var_a576e0b9[var_f2e38849].var_bd61ef5b < var_44da5f74) {
							self.a_s_spawnpts[i].script_noteworthy = "thrasher_location";
							ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369);
						}
						break;
					}
					case "zombie_spider_spawner": {
						self.a_s_spawnpts[i].script_noteworthy = "spider_location";
						ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369, self.a_s_spawnpts[i]);
						break;
					}
				}
				wait 0.1;
			}
			if (IsAlive(ai_attacker)) {
				ai_attacker.var_ecc789a5 = var_f2e38849;
				array::add(level.var_a576e0b9[var_f2e38849].var_d38f69da, ai_attacker);
				ai_attacker.ignore_enemy_count = 1;
				ai_attacker.no_damage_points = 1;
				ai_attacker.deathpoints_already_given = 1;
				switch (e_spawner.script_noteworthy) {
					case "zombie_spawner": {
						ai_attacker ForceTeleport(self.a_s_spawnpts[i].origin, self.a_s_spawnpts[i].angles);
						if (ai_attacker.health > 1263) {
							ai_attacker.maxhealth = 1263;
							ai_attacker.health = 1263;
						}
						ai_attacker thread [[@zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::function_bd5d2a96]](self);
						break;
					}
					case "zombie_thrasher_spawner": {
						ai_attacker [[@zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_89976d94]](self.a_s_spawnpts[i].origin);
						self.var_bd61ef5b++;
						ai_attacker clientfield::set("ritual_attacker_fx", 1);
						ai_attacker.var_75729ddd = 1;
						break;
					}
					case "zombie_spider_spawner": {
						ai_attacker.favoriteenemy = [[@zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::get_favorite_enemy]]();
						self.a_s_spawnpts[i] thread function_49e57a3b(ai_attacker, self.a_s_spawnpts[i]);
						break;
					}
				}
				ai_attacker thread [[@zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::function_c46730e7]](self.script_special);
				ai_attacker thread [[@zm_island_util<scripts\zm\zm_island_util.gsc>::function_acd04dc9]]();
				wait self.var_9543b4d3;
			}
			level.zombie_ai_limit = level.zombie_ai_limit + self.var_eca4fee1;
			var_eca4fee1 = var_8f4e08a8[level.activeplayers.size];
			self.var_eca4fee1 = var_eca4fee1;
			level.zombie_ai_limit = level.zombie_ai_limit - self.var_eca4fee1;
		}
		wait self.var_9543b4d3;
	}
}

detour zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::function_ef5b1df5()
{
	var_8ac892bf = array(0, 3, 5, 7, 8);
	var_59d27c2f = array(0, 20, 29, 38, 47);
	level.var_d15b7db3 = var_8ac892bf[level.players.size];
	level.var_49c6fb1c = var_59d27c2f[level.players.size];
	level.zombie_ai_limit = level.zombie_ai_limit - level.var_d15b7db3;
	level flag::clear("spawn_zombies");
	level.disable_nuke_delay_spawning = 1;
	level.var_92914699 = 0;
	level.var_9bc0cd6e = 0;
	var_bc3b3f4c = GetEnt("skullroom_keeper_spawner", "targetname");
	level.var_55c48492 clientfield::set("skullquest_finish_start_fx", 1);
	level.var_55c48492 clientfield::set("skullquest_finish_trail_fx", 1);
	level thread [[@zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::function_41b94a87]]();
	wait 0.25;
	level clientfield::set("keeper_spawn_portals", 1);
	wait 2.5;
	a_spawn_points = struct::get_array("s_spawnpt_skullroom");
	level flag::clear("skullroom_empty_of_players");
	var_2241a147 = [];
	level thread [[@zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::function_d91adba6]]();
	a_spawn_points = SArrayRandomize(a_spawn_points, "zm_island_skullweapon_quest_keeper_location");
	while (level.var_9bc0cd6e < level.var_49c6fb1c && !level flag::get("skullroom_empty_of_players") && !IS_TRUE(level.var_d9d19dae)) {
		foreach (s_spawn_point in a_spawn_points) {
			while (GetFreeActorCount() < 1 && !level flag::get("skullroom_empty_of_players") && !IS_TRUE(level.var_d9d19dae)) {
				wait 0.05;
			}
			while (level.var_92914699 >= level.var_d15b7db3 && !level flag::get("skullroom_empty_of_players") && !IS_TRUE(level.var_d9d19dae)) {
				wait 0.05;
			}
			if (level.var_9bc0cd6e >= level.var_49c6fb1c || level flag::get("skullroom_empty_of_players") || IS_TRUE(level.var_d9d19dae)) {
				break;
			}
			s_spawn_point.script_string = "find_flesh";
			ai = zombie_utility::spawn_zombie(var_bc3b3f4c, "skullroom_keeper_zombie", s_spawn_point);
			if (IsDefined(ai)) {
				level.var_92914699++;
				ai.var_2f846873 = 1;
				ai.targetname = "skullroom_keeper_zombie";
				ai thread [[@zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::function_2d0c5aa1]](s_spawn_point);
				level thread [[@zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::function_efbd4abf]](ai, s_spawn_point);
				ai.custom_location = @zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::function_b820cada;
				array::add(var_2241a147, ai);
			}
			wait 1;
		}
	}
	level flag::clear("skullroom_defend_inprogress");
	level clientfield::set("keeper_spawn_portals", 0);
	level.var_55c48492 clientfield::set("skullquest_finish_start_fx", 0);
	level.var_55c48492 clientfield::set("skullquest_finish_trail_fx", 0);
	level.var_b10ab148 = level.var_9bc0cd6e >= level.var_49c6fb1c;
	level flag::set("skull_quest_complete");
	if (IS_TRUE(level.var_b10ab148)) {
		var_363b7d39 = GetEnt("volume_thrasher_non_teleport_ruins_underground", "targetname");
		var_363b7d39 Delete();
		level.var_55c48492 thread [[@zm_island_skullquest<scripts\zm\zm_island_skullweapon_quest.gsc>::function_85a2a491]]();
	}
	var_2241a147 = array::remove_dead(var_2241a147, 0);
	foreach (var_e35bb14a in var_2241a147) {
		if (IsAlive(var_e35bb14a)) {
			var_e35bb14a Kill();
		}
	}
	level.var_55c48492 PlaySound("evt_keeper_quest_done");
	wait 1.5;
	level.var_55c48492 MoveTo(level.var_55c48492.var_5cd7e450, 0.5);
	level.zombie_ai_limit = level.zombie_ai_limit + level.var_d15b7db3;
	level flag::set("spawn_zombies");
	level.disable_nuke_delay_spawning = 0;
}