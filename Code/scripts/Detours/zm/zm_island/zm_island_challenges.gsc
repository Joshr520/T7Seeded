detour zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::on_player_connect()
{
	level flag::wait_till("flag_init_player_challenges");
	var_a879fa43 = self GetEntityNumber();
	self.var_8575e180 = 0;
	self.var_26f3bd30 = 0;
	self.var_301c71e9 = 0;
	self._challenges = SpawnStruct();
	self._challenges.challenge_1 = [];
	self._challenges.challenge_2 = [];
	self._challenges.challenge_3 = [];
	self._challenges.challenge_1 = SArrayRandom(level._challenges.challenge_1, "zm_island_challenges_order");
	self._challenges.challenge_2 = SArrayRandom(level._challenges.challenge_2, "zm_island_challenges_order");
	self._challenges.challenge_3 = SArrayRandom(level._challenges.challenge_3, "zm_island_challenges_order");
	ArrayRemoveValue(level._challenges.challenge_1, self._challenges.challenge_1);
	ArrayRemoveValue(level._challenges.challenge_2, self._challenges.challenge_2);
	ArrayRemoveValue(level._challenges.challenge_3, self._challenges.challenge_3);
	self thread [[@zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::function_b7156b15]](var_a879fa43);
}

detour zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::function_8675d6ed(n_challenge)
{
	self endon("disconnect");
	var_a879fa43 = self GetEntityNumber();
	var_81d71db = [];
	s_altar = struct::get("s_challenge_altar");
	if (n_challenge == 1) {
		var_c9d33fc4 = "p7_zm_power_up_max_ammo";
	}
	else if (n_challenge == 2) {
        array::add(var_81d71db, "wpn_t7_lmg_dingo_world");
        array::add(var_81d71db, "wpn_t7_shotty_gator_world");
        array::add(var_81d71db, "wpn_t7_sniper_svg100_world");
        var_c9d33fc4 = SArrayRandom(var_81d71db, "zm_island_challenges_weapon");
    }
    else {
        var_c9d33fc4 = "zombie_pickup_perk_bottle";
    }
	level flag::set("flag_player_initialized_reward");
	var_a6a1ecf9 = GetEnt("altar_lid", "targetname");
	self [[@zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::function_d655a4ce]](var_a6a1ecf9);
	self thread [[@zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::function_26abcbe0]]();
	self thread [[@zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::function_994b4784]](var_a6a1ecf9);
	if (n_challenge == 2) {
		v_spawnpt = s_altar.origin + (0, 8, 30);
	}
	else {
		v_spawnpt = s_altar.origin + (0, 0, 30);
	}
	var_30ff0d6c = [[@zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::function_5e39bbbe]](var_c9d33fc4, v_spawnpt, s_altar.angles);
	self thread [[@zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::function_6168d051]](var_30ff0d6c);
	if (n_challenge == 1) {
		var_30ff0d6c clientfield::set("challenge_glow_fx", 1);
	}
	else if (n_challenge == 3) {
		var_30ff0d6c clientfield::set("challenge_glow_fx", 2);
	}
	var_30ff0d6c thread [[@zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::timer_til_despawn]](self, n_challenge, v_spawnpt, 30 * -1);
	self thread [[@zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::function_5c44a258]](var_30ff0d6c);
	var_30ff0d6c endon(#"hash_59e0fa55");
	var_30ff0d6c.trigger = s_altar [[@zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::function_be89930d]](var_a879fa43, n_challenge);
	var_30ff0d6c.trigger waittill("trigger", e_who);
	if (e_who == self) {
		self PlaySoundToPlayer("zmb_trial_unlock_reward", self);
		var_30ff0d6c.trigger notify("reward_grabbed");
		self [[@zm_island_challenges<scripts\zm\zm_island_challenges.gsc>::player_give_reward]](n_challenge, s_altar, var_c9d33fc4);
		if (IsDefined(var_30ff0d6c.trigger)) {
			zm_unitrigger::unregister_unitrigger(var_30ff0d6c.trigger);
			var_30ff0d6c.trigger = undefined;
		}
		if (IsDefined(var_30ff0d6c)) {
			var_30ff0d6c Delete();
		}
	}
}