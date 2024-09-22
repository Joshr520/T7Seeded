detour zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_43eea1de()
{
	return function_43eea1de();
}

function_43eea1de()
{
	level endon(#"hash_a881e3fa");
	for (;;) {
		var_47364533 = SRandomFloatRange("zm_zod_shadowman_move_wait", self.var_e033b3aa, self.var_f5525b44);
		wait var_47364533;
		n_roll = SRandomFloatRange("zm_zod_shadowman_move", 0, 1);
		var_6ab32645 = 0;
		foreach (s_move in self.var_a21704fb) {
			var_6ab32645 = var_6ab32645 + s_move.probability;
			if (n_roll <= var_6ab32645) {
				if (!IS_TRUE(self.var_8abfb076)) {
					self [[s_move.func]](s_move.n_move_duration);
				}
				break;
			}
		}
		self.var_a21704fb = SArrayRandomize(self.var_a21704fb, "zm_zod_shadowman_move");
	}
}

detour zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_f3805c8a(var_8f0a8b6a, str_script_noteworthy, var_a21704fb, var_e033b3aa, var_f5525b44)
{
	if (!IsDefined(level.var_1a2a51eb)) {
		level.var_1a2a51eb = SpawnStruct();
	}
	level.var_1a2a51eb.var_8f0a8b6a = var_8f0a8b6a;
	a_s_spawnpoints = struct::get_array(var_8f0a8b6a, "targetname");
	if (level clientfield::get("ee_quest_state") === 1) {
		a_s_spawnpoints = array::filter(a_s_spawnpoints, 0, @zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_726d4cc4, 0);
	}
	if (IsDefined(str_script_noteworthy)) {
		a_s_spawnpoints = array::filter(a_s_spawnpoints, 0, @zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_69330ce7, str_script_noteworthy);
	}
	else {
		a_s_spawnpoints = SArrayRandomize(a_s_spawnpoints, "zm_zod_shadowman_spawn");
	}
	level.var_1a2a51eb.s_spawnpoint = a_s_spawnpoints[a_s_spawnpoints.size - 1];
	var_2e456dd1 = level.var_1a2a51eb.s_spawnpoint.origin;
	var_7e1ba25f = level.var_1a2a51eb.s_spawnpoint.angles;
	level.var_1a2a51eb.var_93dad597 = util::spawn_anim_model("c_zom_zod_shadowman_tentacles_fb", var_2e456dd1, var_7e1ba25f);
	level.var_1a2a51eb.var_93dad597 SetCanDamage(1);
	level.var_1a2a51eb.var_93dad597 clientfield::set("shadowman_fx", 1);
	level.var_1a2a51eb.var_93dad597 PlaySound("zmb_shadowman_tele_in");
	level.var_1a2a51eb.var_93dad597 Attach("p7_fxanim_zm_zod_redemption_key_ritual_mod", "tag_weapon_right");
	level.var_1a2a51eb.n_script_int = 0;
	level.var_1a2a51eb.str_script_noteworthy = str_script_noteworthy;
	level.var_1a2a51eb thread function_b6c7fd80();
	level.var_1a2a51eb.var_e033b3aa = var_e033b3aa;
	level.var_1a2a51eb.var_f5525b44 = var_f5525b44;
	level.var_1a2a51eb.var_a21704fb = var_a21704fb;
	level.var_1a2a51eb thread function_43eea1de();
	level.var_1a2a51eb.var_93dad597 thread animation::play("ai_zombie_zod_shadowman_float_idle_loop", undefined, undefined, 1);
	return level.var_1a2a51eb;
}

detour zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_b6c7fd80()
{
	return function_b6c7fd80();
}

function_b6c7fd80()
{
	level notify(#"hash_b6c7fd80");
	level endon(#"hash_b6c7fd80");
	level endon(#"hash_a881e3fa");
	a_s_spawnpoints = struct::get_array(self.var_8f0a8b6a, "targetname");
	if (IsDefined(self.str_script_noteworthy)) {
		a_s_spawnpoints = array::filter(a_s_spawnpoints, 0, @zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_69330ce7, self.str_script_noteworthy);
	}
	else {
		a_s_spawnpoints = SArrayRandomize(a_s_spawnpoints, "zm_zod_shadowman_damage_func");
	}
	var_bac4e70 = 0;
	var_90530d3 = 0;
	self.var_8abfb076 = 0;
	for (;;) {
		self.var_93dad597.health = 1000000;
		self.var_93dad597 waittill("damage", amount, attacker, direction_vec, point, type, tagname, modelname, partname, weapon);
		PlayFX(level._effect["shadowman_impact_fx"], point);
		var_90530d3 = var_90530d3 + amount;
		var_6b401aad = 0;
		for (i = 0; i < 2; i++) {
			wpn_idgun = GetWeapon(level.idgun[i].str_wpnname);
			if (weapon === wpn_idgun) {
				var_6b401aad = 1;
			}
		}
		n_player_count = level.activeplayers.size;
		var_d6a1b83c = 0.5 + (0.5 * ((n_player_count - 1) / 3));
		var_9bd75db5 = 1000 * var_d6a1b83c;
		var_e3b39dfc = 0;
		if (var_90530d3 >= var_9bd75db5) {
			var_e3b39dfc = 1;
		}
		if (!var_e3b39dfc && !var_6b401aad) {
			continue;
		}
		var_90530d3 = 0;
		if (level clientfield::get("ee_quest_state") === 1 && level flag::get("ee_boss_vulnerable") === 0) {
			continue;
		}
		self.var_8abfb076 = 1;
		level notify(#"hash_82a23c03");
		if (level flag::get("ee_boss_started")) {
			if (self.n_script_int < 8) {
				self.n_script_int++;
				self.s_spawnpoint = function_293235e9(self.var_8f0a8b6a, self.s_spawnpoint, self.n_script_int);
			}
			var_685eb707 = 0.1;
			[[@zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_284b1884]](self, self.s_spawnpoint, var_685eb707, undefined);
			self.var_93dad597 thread animation::play("ai_zombie_zod_shadowman_captured_intro", undefined, undefined, 1);
		}
		else {
			var_bac4e70++;
			if (var_bac4e70 == a_s_spawnpoints.size) {
				a_s_spawnpoints = SArrayRandomize(a_s_spawnpoints, "zm_zod_shadowman_damage_func");
				var_bac4e70 = 0;
			}
			self.s_spawnpoint = a_s_spawnpoints[var_bac4e70];
			var_685eb707 = SRandomFloatRange("zm_zod_shadowman_damage_func", 5, 10);
			self.var_8abfb076 = 0;
			var_5d186a94 = level.var_6e3c8a77.origin;
			v_dir = VectorNormalize(var_5d186a94 - self.s_spawnpoint.origin);
			v_angles = VectorToAngles(v_dir);
			[[@zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_284b1884]](self, self.s_spawnpoint, var_685eb707, v_angles);
			self.var_93dad597 thread animation::play("ai_zombie_zod_shadowman_float_idle_loop", undefined, undefined, 1);
		}
	}
}

detour zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_293235e9(var_8f0a8b6a, var_1e5c1571, n_script_int)
{
	return function_293235e9(var_8f0a8b6a, var_1e5c1571, n_script_int);
}

function_293235e9(var_8f0a8b6a, var_1e5c1571, n_script_int)
{
	a_s_spawnpoints = struct::get_array(var_8f0a8b6a, "targetname");
	if (IsDefined(var_1e5c1571)) {
		ArrayRemoveValue(a_s_spawnpoints, var_1e5c1571);
	}
	if (IsDefined(n_script_int)) {
		a_s_spawnpoints = array::filter(a_s_spawnpoints, 0, @zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_726d4cc4, n_script_int);
	}
	a_s_spawnpoints = SArrayRandomize(a_s_spawnpoints, "zm_zod_shadowman_boss_location");
	return a_s_spawnpoints[0];
}

detour zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_b4b792ef(n_move_duration)
{
	level endon(#"hash_a881e3fa");
	level endon(#"hash_82a23c03");
	var_2c563e77 = [[@zm_zod_util<scripts\zm\zm_zod_util.gsc>::function_15166300]](1);
	var_57689abe = [[@zm_zod_util<scripts\zm\zm_zod_util.gsc>::function_15166300]](3);
	var_32cbfe17 = [];
	if (var_2c563e77 >= 4) {
		if (!IsDefined(var_32cbfe17)) {
			var_32cbfe17 = [];
		}
		else if (!IsArray(var_32cbfe17)) {
			var_32cbfe17 = array(var_32cbfe17);
		}
		var_32cbfe17[var_32cbfe17.size] = @zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_c94f30a2;
	}
	if (var_57689abe >= 3) {
		if (!IsDefined(var_32cbfe17)) {
			var_32cbfe17 = [];
		}
		else if (!IsArray(var_32cbfe17)) {
			var_32cbfe17 = array(var_32cbfe17);
		}
		var_32cbfe17[var_32cbfe17.size] = @zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_45c7d9eb;
	}
	if (var_32cbfe17.size === 0) {
		if (!IsDefined(var_32cbfe17)) {
			var_32cbfe17 = [];
		}
		else if (!IsArray(var_32cbfe17)) {
			var_32cbfe17 = array(var_32cbfe17);
		}
		var_32cbfe17[var_32cbfe17.size] = @zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_e44c4f1b;
	}
	else {
		if (!IsDefined(var_32cbfe17)) {
			var_32cbfe17 = [];
		}
		else if (!IsArray(var_32cbfe17)) {
			var_32cbfe17 = array(var_32cbfe17);
		}
		var_32cbfe17[var_32cbfe17.size] = @zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_fcd226a8;
	}
	var_b37e00f9 = SArrayRandom(var_32cbfe17, "zm_zod_shadowman_behavior");
	self [[var_b37e00f9]](n_move_duration);
}

detour zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_fcd226a8(n_move_duration)
{
	return function_fcd226a8(n_move_duration);
}

function_fcd226a8(n_move_duration)
{
	level endon(#"hash_a881e3fa");
	level endon(#"hash_82a23c03");
	self [[@zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_a3821eb5]](n_move_duration);
	var_9eb45ed3 = array("boxer", "detective", "femme", "magician");
	str_charname = SArrayRandom(var_9eb45ed3, "zm_zod_shadowman_character");
	level clientfield::set(("ee_keeper_" + str_charname) + "_state", 6);
	wait n_move_duration;
}

detour zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_1bd7a0f4(var_8cf7b520, var_cbdd21c0, n_spawn_count, var_58655a9e, var_ab3cc960, var_8388cfbb)
{
	a_s_spawnpoints = struct::get_array(var_8cf7b520, "targetname");
	a_s_spawnpoints = SArrayRandomize(a_s_spawnpoints, "zm_zod_shadowman_buffed_spawn");
	v_origin = self.var_93dad597.origin;
	for (i = 0; i < n_spawn_count; i++) {
		v_target = a_s_spawnpoints[i].origin;
		switch (var_cbdd21c0) {
			case 0: {
				self thread [[@zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_1063429a]](a_s_spawnpoints[i]);
				break;
			}
			case 1: {
				self thread function_4ef376eb(a_s_spawnpoints[i]);
				break;
			}
			case 2: {
				self thread function_7a4cf63(a_s_spawnpoints[i], var_8388cfbb);
				break;
			}
			case 3: {
				self thread [[@zm_zod_margwa<scripts\zm\zm_zod_margwa.gsc>::function_8bcb72e9]](0, a_s_spawnpoints[i]);
				break;
			}
		}
		var_dc7b7a0f = SRandomFloatRange("zm_zod_shadowman_buffed_spawn", var_58655a9e, var_ab3cc960);
		wait var_dc7b7a0f;
	}
}

detour zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_4ef376eb(s_spawnpoint)
{
	return function_4ef376eb(s_spawnpoint);
}

function_4ef376eb(s_spawnpoint)
{
	var_42513f6e = GetEnt("ritual_zombie_spawner", "targetname");
	ai_wasp = zombie_utility::spawn_zombie(level.wasp_spawners[0], "buffed_parasite", s_spawnpoint);
	if (IsDefined(ai_wasp)) {
		if (!IsDefined(level.var_27fa160f)) {
			level.var_27fa160f = [];
		}
		if (!IsDefined(level.var_27fa160f)) {
			level.var_27fa160f = [];
		}
		else if (!IsArray(level.var_27fa160f)) {
			level.var_27fa160f = array(level.var_27fa160f);
		}
		level.var_27fa160f[level.var_27fa160f.size] = ai_wasp;
		ai_wasp.favoriteenemy = SArrayRandom(level.activeplayers, "zm_zod_shadowman_wasp_enemy");
		level thread [[@zm_ai_wasp<scripts\zm\_zm_ai_wasp.gsc>::wasp_spawn_init]](ai_wasp, s_spawnpoint.origin);
	}
}

detour zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_479785a0(var_e28c6e5d)
{
	var_d7afb638 = "ee_plague_pods_" + var_e28c6e5d;
	if (!IsDefined(level.var_c0f45612[var_d7afb638].spawned)) {
		return undefined;
	}
	var_c0eb23cc = array::filter(level.var_c0f45612[var_d7afb638].spawned, 0, @zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_9edae260);
	if (var_c0eb23cc.size === 0) {
		return undefined;
	}
	s_pod = SArrayRandom(var_c0eb23cc, "zm_zod_shadowman_pod_location");
	return s_pod;
}

detour zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_7a4cf63(s_spawnpoint, var_8388cfbb)
{
	return function_7a4cf63(s_spawnpoint, var_8388cfbb);
}

function_7a4cf63(s_spawnpoint, var_8388cfbb)
{
	var_42513f6e = GetEnt("ritual_zombie_spawner", "targetname");
	ai_raps = zombie_utility::spawn_zombie(level.raps_spawners[0], "buffed_elemental", s_spawnpoint);
	if (IsDefined(ai_raps)) {
		if (!IsDefined(level.var_35fcee79)) {
			level.var_35fcee79 = [];
		}
		if (!IsDefined(level.var_35fcee79)) {
			level.var_35fcee79 = [];
		}
		else if (!IsArray(level.var_35fcee79)) {
			level.var_35fcee79 = array(level.var_35fcee79);
		}
		level.var_35fcee79[level.var_35fcee79.size] = ai_raps;
		ai_raps clientfield::set("veh_status_fx", 2);
		ai_raps.favoriteenemy = SArrayRandom(level.activeplayers, "zm_zod_shadowman_raps_enemy");
		s_spawnpoint thread [[@zm_ai_raps<scripts\zm\_zm_ai_raps.gsc>::raps_spawn_fx]](ai_raps, s_spawnpoint);
		if (IsDefined(var_8388cfbb)) {
			ai_raps thread [[@zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_4a3d00d6]](var_8388cfbb);
		}
	}
}

detour zm_zod_shadowman<scripts\zm\zm_zod_shadowman.gsc>::function_f38a6a2a(var_8661a082)
{
	var_c9a88def = struct::get_array("cursetrap_point", "targetname");
	var_c9a88def = SArrayRandomize(var_c9a88def, "zm_zod_shadowman_trap_location");
	var_9e546be = [];
	var_5543272f = [];
	for (i = 0; i < var_c9a88def.size; i++) {
		if (IsDefined(var_c9a88def[i].active) && var_c9a88def[i].active) {
			if (!IsDefined(var_9e546be)) {
				var_9e546be = [];
			}
			else if (!IsArray(var_9e546be)) {
				var_9e546be = array(var_9e546be);
			}
			var_9e546be[var_9e546be.size] = var_c9a88def[i];
			continue;
		}
		if (!IsDefined(var_5543272f)) {
			var_5543272f = [];
		}
		else if (!IsArray(var_5543272f)) {
			var_5543272f = array(var_5543272f);
		}
		var_5543272f[var_5543272f.size] = var_c9a88def[i];
	}
	var_e1b2953e = var_9e546be.size;
	n_diff = var_8661a082 - var_e1b2953e;
	var_4162cc72 = Abs(n_diff);
	for (i = 0; i < var_4162cc72; i++) {
		if (n_diff > 0) {
			var_5543272f[i].active = 1;
			continue;
		}
		if (n_diff < 0) {
			var_9e546be[i].active = 0;
		}
	}
}