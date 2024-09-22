detour zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_279705f()
{
	level endon(#"hash_d1f7df7e");
	var_ac9b7de4 = level.var_bbdc1f95.var_69943735[3];
	while (!IS_TRUE(var_ac9b7de4.b_dead)) {
		level thread function_4c7498f7();
		wait SRandomIntRange("zm_island_takeo_fight_attack", 10, 20);
	}
}

detour zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_4c7498f7()
{
	return function_4c7498f7();
}

function_4c7498f7()
{
	var_ac9b7de4 = level.var_bbdc1f95.var_69943735[3];
	if (!IS_TRUE(var_ac9b7de4.b_dead) && !IS_TRUE(var_ac9b7de4.var_722e43d8)) {
		var_ac9b7de4.var_722e43d8 = 1;
		var_f1a28621 = array("roar", "jawsnap");
		level thread [[@zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_6addaa9e]](SArrayRandom(var_f1a28621, "zm_island_takeo_fight_vines"));
		if (IS_TRUE(var_ac9b7de4.var_6c555b6c)) {
			var_ac9b7de4 thread scene::play("p7_fxanim_zm_island_takeo_arm3_open_slam_bundle");
		}
		else {
			var_ac9b7de4 thread scene::play("p7_fxanim_zm_island_takeo_arm3_close_slam_bundle");
		}
		level waittill(#"hash_4c7498f7");
		level thread scene::play("p7_fxanim_zm_island_takeo_vines_bundle");
		var_d034d3c3 = struct::get("s_vine_slam_impact_pos", "targetname");
		RadiusDamage(var_d034d3c3.origin, 100, 480, 240, undefined, "MOD_GRENADE");
		PlayRumbleOnPosition("zm_island_rumble_takeo_vine_slam", var_d034d3c3.origin);
		exploder::exploder("fxexp_620");
		wait 1.5;
		var_ac9b7de4.var_722e43d8 = 0;
	}
}

detour zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_4ea8a87a()
{
	if (!level flag::get("takeofight_wave_spawning"))
	{
		level.disable_nuke_delay_spawning = 1;
		level.var_5c9015c4 = level.zombie_ai_limit;
		level.var_5258ba34 = 1;
		a_spawners = [];
		var_89f44116 = level.zombie_spawners;
		var_64cc2fa5 = level.var_feebf312;
		var_6469b451 = level.var_c38a4fee;
		var_62813733 = 0;
		a_spawners = array(var_64cc2fa5[0], var_6469b451[0], var_89f44116[0]);
		self [[@zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_2e25785c]]();
		var_19b19369 = "takeofight_enemy";
		self.var_bd61ef5b = 0;
		self.var_9defe760 = 0;
		self.var_bc88fb8b = 0;
		self.var_8a71c4c5 = 0;
		self.a_ai_attackers = [];
		self.a_s_spawnpts = SArrayRandomize(self.a_s_spawnpts, "zm_island_takeo_fight_spawn_location");
		zm_spawner::register_zombie_death_event_callback(@zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_3127ccbd);
		callback::on_vehicle_killed(@zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_a3420702);
		level flag::set("takeofight_wave_spawning");
		wait 0.1;
		level thread [[@zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_fe7b0c13]]();
		while (level flag::get("takeofight_wave_spawning") && !IS_TRUE(level.var_f0fe245e)) {
			var_43b53d77 = self.a_s_spawnpts.size;
			for (i = 0; i < var_43b53d77; i++) {
				while (GetFreeActorCount() < 1) {
					wait 0.05;
				}
				while (self.var_8a71c4c5 >= self.var_eca4fee1) {
					wait 0.05;
				}
				if (level flag::get("takeofight_wave_spawning") && !IS_TRUE(level.var_f0fe245e)) {
					e_spawner = SArrayRandom(a_spawners, "zm_island_takeo_fight_spawn_location");
					ai_attacker = undefined;
					switch (e_spawner.script_noteworthy) {
						case "zombie_spawner": {
							if (self.var_9defe760 < self.var_fc3dea41) {
								self.a_s_spawnpts[i].script_noteworthy = "riser_location";
								self.a_s_spawnpts[i].script_string = "find_flesh";
								ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369, self.a_s_spawnpts[i]);
							}
							break;
						}
						case "zombie_thrasher_spawner": {
							if (self.var_bd61ef5b < self.var_44da5f74) {
								self.a_s_spawnpts[i].script_noteworthy = "riser_location";
								ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369);
							}
							break;
						}
						case "zombie_spider_spawner": {
							if (self.var_bc88fb8b < self.var_1fcf1bc4) {
								self.a_s_spawnpts[i].script_noteworthy = "spider_location";
								ai_attacker = zombie_utility::spawn_zombie(e_spawner, var_19b19369, self.a_s_spawnpts[i]);
							}
							break;
						}
					}
					wait 0.1;
					if (IsAlive(ai_attacker)) {
						ai_attacker.ignore_enemy_count = 1;
						ai_attacker.no_damage_points = 1;
						ai_attacker.deathpoints_already_given = 1;
						ai_attacker.var_bf5bc647 = 1;
						self.var_8a71c4c5++;
						array::add(self.a_ai_attackers, ai_attacker);
						switch (e_spawner.script_noteworthy) {
							case "zombie_spawner": {
								self.var_9defe760++;
								break;
							}
							case "zombie_thrasher_spawner": {
								self.var_bd61ef5b++;
								ai_attacker [[@zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_89976d94]](self.a_s_spawnpts[i].origin);
								if (IS_TRUE(var_62813733)) {
									[[@thrasherserverutils<scripts\shared\ai\archetype_thrasher.gsc>::thrashergoberserk]](ai_attacker);
								}
								break;
							}
							case "zombie_spider_spawner": {
								self.var_bc88fb8b++;
								ai_attacker.favoriteenemy = [[@zm_ai_spiders<scripts\zm\_zm_ai_spiders.gsc>::get_favorite_enemy]]();
								self.a_s_spawnpts[i] thread function_49e57a3b(ai_attacker, self.a_s_spawnpts[i]);
								break;
							}
						}
						wait self.var_5687375e;
					}
					self [[@zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_b96762d3]]();
					continue;
				}
				break;
			}
			wait self.var_654ec44b;
		}
		while (self.a_ai_attackers.size > 0 && !IS_TRUE(level.var_f0fe245e)) {
			self.a_ai_attackers = array::remove_undefined(self.a_ai_attackers);
			wait 1;
		}
		zm_spawner::deregister_zombie_death_event_callback(@zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_3127ccbd);
		callback::remove_on_vehicle_killed(@zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_a3420702);
		level.var_5258ba34 = 0;
		level flag::clear("takeofight_wave_spawning");
		self thread [[@zm_island_takeo_fight<scripts\zm\zm_island_takeo_fight.gsc>::function_612749c9]]();
	}
}