detour zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_ffa65395(golden_bucket)
{
	self endon(#"hash_70cb3a5f");
	if (IS_TRUE(golden_bucket)) {
		return;
	}
	self.s_plant.watered_with = [];
	self.s_plant.var_2a1e031c = [];
	wait 1;
	for (n_round = 0; n_round < 3; n_round++) {
		self.s_plant.var_4d34f582 = 0;
		self waittill(#"hash_8626f7f1", user);
		self.s_plant.var_4d34f582 = 1;
		user notify("update_challenge_1_3");
		user PlaySound("evt_island_seed_water");
		if (!IsDefined(user.var_f6130406)) {
			user.var_f6130406 = 1;
			user notify("player_watered_plant");
		}
		else {
			n_rand = SRandomIntRange("zm_island_planting_watered", 1, 101);
			if (n_rand <= 20)
			{
				user notify("player_watered_plant");
			}
		}
		self.s_plant.watered_with[self.s_plant.watered_with.size] = user.var_c6cad973;
		user thread [[@zm_island_power<scripts\zm\zm_island_power.gsc>::function_a84a1aec]]();
		array::add(self.s_plant.var_2a1e031c, user, 1);
		if (n_round == 2) {
			if (self.s_plant.var_2a1e031c[0] === self.s_plant.var_2a1e031c[1] && self.s_plant.var_2a1e031c[1] === self.s_plant.var_2a1e031c[2]) {
				user notify("update_challenge_1_1");
			}
		}
		self.s_plant.var_8d8becb0 = 1;
		self.s_plant.model clientfield::set("plant_watered_fx", 1);
		self.model clientfield::set("planter_model_watered", 1);
		level waittill("end_of_round");
		self.s_plant.model clientfield::set("plant_watered_fx", 0);
		self.model clientfield::set("planter_model_watered", 0);
	}
}

detour zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_26651461(watered_with, plant_ww_hits, force_plant, golden_bucket)
{
	plant_odds = [];
	plant_odds[0] = 0;
	plant_odds[1] = 0;
	plant_odds[2] = 0;
	plant_odds[3] = 0;
	plant_odds[4] = 0;
	plant_odds[5] = 0;
	plant_odds[6] = 0;
	plant_odds[7] = 0;
	plant_odds[8] = 0;
	plant_odds[9] = 0;
	plant_odds[10] = 0;
	watered_with_1 = 0;
	watered_with_2 = 0;
	watered_with_3 = 0;
	watered_with_4 = 0;
	if (self.script_noteworthy === "ee_planting_spot") {
		b_ee_planting_spot = 1;
	}
	else {
		b_ee_planting_spot = 0;
	}
	for (i = 0; i < watered_with.size; i++) {
		if (watered_with[i] == 4) {
			if (b_ee_planting_spot && !level flag::get("ww_upgrade_spawned_from_plant")) {
				continue;
			}
			watered_with[i] = SRandomIntRange("zm_island_planting_reward", 1, 4);
		}
	}
	foreach (plant_num in watered_with) {
		if (plant_num == 1) {
			watered_with_1++;
			continue;
		}
		if (plant_num == 2) {
			watered_with_2++;
			continue;
		}
		if (plant_num == 3) {
			watered_with_3++;
			continue;
		}
		if (plant_num == 4) {
			watered_with_4++;
		}
	}
	if (self.script_noteworthy === "ee_planting_spot") {
		self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_5726c670]](watered_with_4);
		return;
	}
	n_total = 0;
	if (level.var_50d5cc84 < 4) {
		if (plant_ww_hits == 3) {
			plant_odds[10] = 20;
		}
		else {
			plant_odds[10] = 5 * plant_ww_hits;
		}
	}
	ww_odds_mult = 100 - plant_odds[10];
	n_total = n_total + plant_odds[10];
	if (watered_with_1 == 1 && watered_with_2 == 1 && watered_with_3 == 1) {
		plant_odds[8] = ww_odds_mult / 2;
		plant_odds[2] = (ww_odds_mult / 2) / 3;
		plant_odds[4] = (ww_odds_mult / 2) / 3;
		plant_odds[6] = (ww_odds_mult / 2) / 3;
		plant_odds[0] = 0;
		plant_odds[1] = 0;
	}
	else {
		plant_odds[2] = ww_odds_mult * (watered_with_1 / 3);
		plant_odds[4] = ww_odds_mult * (watered_with_3 / 3);
		plant_odds[6] = ww_odds_mult * (watered_with_2 / 3);
		n_total = n_total + ((plant_odds[2] + plant_odds[4]) + plant_odds[6]);
		if (watered_with.size === 0 && plant_ww_hits === 0) {
			plant_odds[0] = 100 - n_total;
			plant_odds[1] = 0;
		}
		else {
			plant_odds[0] = 0;
			plant_odds[1] = 100 - n_total;
		}
	}
	plant_odds[3] = plant_odds[2] * (plant_ww_hits / 3);
	plant_odds[2] = Abs(plant_odds[2] - plant_odds[3]);
	plant_odds[5] = plant_odds[4] * (plant_ww_hits / 3);
	plant_odds[4] = Abs(plant_odds[4] - plant_odds[5]);
	plant_odds[7] = plant_odds[6] * (plant_ww_hits / 3);
	plant_odds[6] = Abs(plant_odds[6] - plant_odds[7]);
	plant_odds[9] = plant_odds[8] * (plant_ww_hits / 3);
	plant_odds[8] = Abs(plant_odds[8] - plant_odds[9]);
	if (IS_TRUE(golden_bucket)) {
		plant_odds = [];
		if (plant_ww_hits > 0) {
			plant_odds[5] = 100;
		}
		else {
			plant_odds[4] = 100;
		}
	}
	plant_scores = [];
	accum_score = 0;
	foreach (plant, n_score in plant_odds) {
		if (n_score > 0) {
			plant_scores[plant] = accum_score + n_score;
			accum_score = accum_score + n_score;
		}
	}
	n_random = SRandomFloatRange("zm_island_planting_reward", 0, 100);
	foreach (plant, n_score in plant_scores) {
		if (n_random <= n_score) {
			break;
		}
	}
	if (IsDefined(force_plant)) {
		plant = force_plant;
	}
	switch (plant) {
		case 0: {
			self function_41663231();
			break;
		}
		case 1: {
			self function_41663231(1);
			break;
		}
		case 2: {
			self function_a6084535(0, watered_with_4);
			break;
		}
		case 3: {
			self function_a6084535(1, watered_with_4);
			break;
		}
		case 4: {
			self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_5d62716]](0, golden_bucket);
			break;
		}
		case 5: {
			self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_5d62716]](1, golden_bucket);
			break;
		}
		case 6: {
			self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_12c8548e]]();
			break;
		}
		case 7: {
			self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_12c8548e]](1);
			break;
		}
		case 8: {
			self function_fd098f17();
			break;
		}
		case 9: {
			self function_fd098f17(1);
			break;
		}
		case 10: {
			self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_3e429652]]();
			break;
		}
		default: {
			break;
		}
	}
}

detour zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_41663231(b_upgraded = 0)
{
	return function_41663231(b_upgraded);
}

function_41663231(b_upgraded = 0)
{
	if (IsDefined(self.var_561a9c48)) {
		self.var_561a9c48 notify("minor_cache_plant_spawned");
	}
	level notify("minor_cache_plant_spawned");
	self.s_plant.model StopAnimScripted();
	self.s_plant.model SetModel("p7_fxanim_zm_island_plant_cache_minor_mod");
	self.s_plant.model Show();
	self.s_plant.model Solid();
	self.s_plant.model DisConnectPaths();
	self.s_plant.model clientfield::set("cache_plant_interact_fx", 1);
	self thread scene::init("p7_fxanim_zm_island_plant_cache_minor_bundle", self.s_plant.model);
	self.s_plant.model waittill(#"hash_1879b5e4");
	self thread [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_a6ebbe13]]();
	self waittill(#"hash_ebe5cad7", e_who);
	zm_unitrigger::unregister_unitrigger(self.var_23c5e7a6);
	self.var_23c5e7a6 = undefined;
	self.s_plant.model clientfield::set("cache_plant_interact_fx", 0);
	self scene::play("p7_fxanim_zm_island_plant_cache_minor_bundle", self.s_plant.model);
	if (b_upgraded == 1) {
		var_3d9ef8e9 = level.var_9d5349d;
	}
	else {
		var_3d9ef8e9 = level.var_349b9c58;
	}
	n_reward = SRandomFloatRange("zm_island_planting_reward_powerup", 0, 100);
	foreach (str_reward, n_chance in var_3d9ef8e9) {
		if (n_reward <= n_chance) {
			break;
		}
	}
	switch (str_reward) {
		case "points": {
			var_93eb638b = zm_powerups::specific_powerup_drop("bonus_points_player", self.origin + VectorScale((0, 0, 1), 8), undefined, undefined, 1);
			e_who notify("player_revealed_cache_plant_good");
			var_93eb638b util::waittill_any("powerup_grabbed", "death", "powerup_reset", "powerup_timedout");
			break;
		}
		case "pistol": {
			e_who notify("player_revealed_cache_plant_bad");
			self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::dig_up_weapon]](e_who, level.var_3f5e92d);
			break;
		}
		case "sniper": {
			e_who notify("player_revealed_cache_plant_bad");
			self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::dig_up_weapon]](e_who, level.var_f3798849);
			break;
		}
		case "launcher": {
			e_who notify("player_revealed_cache_plant_bad");
			self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::dig_up_weapon]](e_who, level.var_c29d7558);
			break;
		}
		case "ar": {
			e_who notify("player_revealed_cache_plant_bad");
			self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::dig_up_weapon]](e_who, level.var_b00f35c1);
			break;
		}
		case "zombie": {
			self.s_plant.model NotSolid();
			self.s_plant.model ConnectPaths();
			wait 0.05;
			s_temp = SpawnStruct();
			s_temp.origin = [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_15c62ca8]](self.origin, 20);
			if (!IsDefined(s_temp.origin)) {
				s_temp.origin = self.origin;
			}
			s_temp.script_noteworthy = "custom_spawner_entry quick_riser_location";
			s_temp.script_string = "find_flesh";
			zombie_utility::spawn_zombie(level.zombie_spawners[0], "aether_zombie", s_temp);
			util::wait_network_frame();
			s_temp struct::delete();
			self.s_plant.model clientfield::set("zombie_or_grenade_spawned_from_minor_cache_plant", 1);
			self.s_plant.model util::delay(3, undefined, clientfield::set, "zombie_or_grenade_spawned_from_minor_cache_plant", 0);
			e_who notify("player_revealed_cache_plant_bad");
			break;
		}
		case "grenade": {
			self.s_plant.model NotSolid();
			self.s_plant.model ConnectPaths();
			wait 0.05;
			v_spawnpt = self.origin;
			grenade = GetWeapon("frag_grenade");
			e_who MagicGrenadeType(grenade, v_spawnpt, VectorScale((0, 0, 1), 300), 3);
			self.s_plant.model clientfield::set("zombie_or_grenade_spawned_from_minor_cache_plant", 2);
			self.s_plant.model util::delay(3, undefined, clientfield::set, "zombie_or_grenade_spawned_from_minor_cache_plant", 0);
			e_who notify("player_revealed_cache_plant_bad");
			break;
		}
		default: {
			break;
		}
	}
	self.s_plant.model clientfield::set("plant_growth_siege_anims", 0);
	self scene::play("p7_fxanim_zm_island_plant_cache_minor_death_bundle", self.s_plant.model);
}

detour zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_a6084535(b_upgraded = 0, var_98b687fa)
{
	return function_a6084535(b_upgraded, var_98b687fa);
}

function_a6084535(b_upgraded = 0, var_98b687fa)
{
	if (IsDefined(self.var_561a9c48)) {
		self.var_561a9c48 notify("major_cache_plant_spawned");
	}
	level notify("major_cache_plant_spawned");
	self.s_plant.model StopAnimScripted();
	if (b_upgraded == 1) {
		self.s_plant.model SetModel("p7_fxanim_zm_island_plant_cache_major_glow_mod");
	}
	else {
		self.s_plant.model SetModel("p7_fxanim_zm_island_plant_cache_major_mod");
	}
	self.s_plant.model clientfield::set("cache_plant_interact_fx", 1);
	self.s_plant.model Show();
	self.s_plant.model Solid();
	self.s_plant.model DisConnectPaths();
	self thread scene::init("p7_fxanim_zm_island_plant_cache_major_bundle", self.s_plant.model);
	self.s_plant.model waittill(#"hash_aa2731d8");
	self thread [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_192bd777]]();
	self waittill(#"hash_983c15d3", e_who);
	zm_unitrigger::unregister_unitrigger(self.var_23c5e7a6);
	self.var_23c5e7a6 = undefined;
	self.s_plant.model clientfield::set("cache_plant_interact_fx", 0);
	self scene::play("p7_fxanim_zm_island_plant_cache_major_bundle", self.s_plant.model);
	if (b_upgraded == 1) {
		var_3d9ef8e9 = level.var_ff3b49;
		var_582b5c62 = level.var_2afecb6f;
	}
	else {
		var_3d9ef8e9 = level.var_170b1e5c;
		var_582b5c62 = level.var_e6d4b4ec;
	}
	n_reward = SRandomFloatRange("zm_island_planting_reward_spotty", 0, var_582b5c62);
	foreach (n_chance in var_3d9ef8e9) {
		if (n_reward <= n_chance) {
			break;
		}
	}
	if (b_upgraded == 1) {
		if (level flag::get("trilogy_released") && !level flag::get("aa_gun_ee_complete") && !level flag::get("player_has_aa_gun_ammo") && !level flag::get("aa_gun_ammo_loaded")) {
			n_chance = SRandomFloatRange("zm_island_planting_reward_spotty", 0, 100);
			if (n_chance <= level.var_df105f37) {
				str_reward = "aa_gun_ammo";
			}
			else {
				level.var_df105f37 = level.var_df105f37 + 10;
			}
		}
	}
	switch (str_reward) {
		case "points": {
			var_93eb638b = zm_powerups::specific_powerup_drop("bonus_points_team", self.origin + VectorScale((0, 0, 1), 8), undefined, undefined, 1);
			var_93eb638b thread [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_61d38f32]]();
			e_who notify("player_revealed_cache_plant_good");
			var_93eb638b util::waittill_any("powerup_grabbed", "death", "powerup_reset", "powerup_timedout");
			break;
		}
		case "weapon": {
			if (b_upgraded == 1) {
				e_who notify("player_revealed_cache_plant_good");
				self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::dig_up_weapon]](e_who, SArrayRandom(level.var_8aee1d4, "zm_island_planting_reward_spotty"));
			}
			else {
				e_who notify("player_revealed_cache_plant_good");
				self [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::dig_up_weapon]](e_who, SArrayRandom(level.var_b39227d1, "zm_island_planting_reward_spotty"));
			}
			break;
		}
		case "powerup": {
			if (b_upgraded == 1) {
				str_powerup = SArrayRandom(level.var_1a1ac6dd, "zm_island_planting_reward_spotty");
			}
			else {
				str_powerup = SArrayRandom(level.var_c88b32a2, "zm_island_planting_reward_spotty");
			}
			var_93eb638b = zm_powerups::specific_powerup_drop(str_powerup, self.origin + VectorScale((0, 0, 1), 8), undefined, undefined, 1);
			var_93eb638b thread [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_61d38f32]]();
			e_who notify("player_revealed_cache_plant_good");
			var_93eb638b util::waittill_any("powerup_grabbed", "death", "powerup_reset", "powerup_timedout");
			break;
		}
		case "perk_bottle": {
			var_93eb638b = zm_powerups::specific_powerup_drop("empty_perk", self.origin + VectorScale((0, 0, 1), 8), undefined, undefined, 1);
			var_93eb638b thread [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_61d38f32]]();
			e_who notify("player_revealed_cache_plant_good");
			var_93eb638b util::waittill_any("powerup_grabbed", "death", "powerup_reset", "powerup_timedout");
			break;
		}
		case "aa_gun_ammo": {
			self [[@main_quest<scripts\zm\zm_island_main_ee_quest.gsc>::function_1f4e6abd]]();
			break;
		}
	}
	self.s_plant.model clientfield::set("plant_growth_siege_anims", 0);
	self scene::play("p7_fxanim_zm_island_plant_cache_major_death_bundle", self.s_plant.model);
}

detour zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_fd098f17(b_upgraded = 0)
{
	return function_fd098f17(b_upgraded);
}

function_fd098f17(b_upgraded = 0)
{
	if (IsDefined(self.var_561a9c48)) {
		self.var_561a9c48 notify("fruit_plant_spawned");
	}
	level notify("fruit_plant_spawned");
	if (b_upgraded == 1) {
		var_d583f9d = "p7_fxanim_zm_island_plant_fruit_glow_mod";
	}
	else {
		var_d583f9d = "p7_fxanim_zm_island_plant_fruit_mod";
	}
	self.s_plant.model SetModel(var_d583f9d);
	self.s_plant.model Show();
	self.s_plant.model Solid();
	self.s_plant.model DisConnectPaths();
	self thread scene::init("p7_fxanim_zm_island_plant_fruit_bundle", self.s_plant.model);
	self.s_plant.model waittill(#"hash_334ee3df");
	self thread [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_bf89dc95]]();
	self waittill(#"hash_f224e16d", e_player);
	zm_unitrigger::unregister_unitrigger(self.var_23c5e7a6);
	self.var_23c5e7a6 = undefined;
	e_player notify(#"hash_3e1e1a8");
	if (b_upgraded == 1) {
		if (e_player zm_utility::can_player_purchase_perk()) {
			level thread [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_cccc72b3]](e_player);
		}
		else {
			level thread [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_cc0c1582]](e_player);
		}
	}
	else {
		n_chance = SRandomFloatRange("zm_island_planting_reward_fruit", 0, 100);
		if (n_chance <= 75) {
			if (e_player zm_utility::can_player_purchase_perk()) {
				level thread [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_cccc72b3]](e_player);
			}
			else {
				level thread [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_cc0c1582]](e_player);
			}
		}
		else {
			level thread [[@zm_island_planting<scripts\zm\zm_island_planting.gsc>::function_cc0c1582]](e_player);
		}
	}
	self.s_plant.model clientfield::set("plant_growth_siege_anims", 0);
	self.s_plant.model HidePart("plant_fruit_stalk_egg_hide_jnt", var_d583f9d);
	self scene::play("p7_fxanim_zm_island_plant_fruit_bundle", self.s_plant.model);
	self.s_plant.model ShowPart("plant_fruit_stalk_egg_hide_jnt", var_d583f9d);
}