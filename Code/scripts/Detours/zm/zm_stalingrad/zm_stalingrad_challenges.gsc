detour zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_b7156b15()
{
	self endon("disconnect");
	self flag::init("flag_player_collected_reward_1");
	self flag::init("flag_player_collected_reward_2");
	self flag::init("flag_player_collected_reward_3");
	self flag::init("flag_player_collected_reward_4");
	self flag::init("flag_player_collected_reward_5");
	self flag::init("flag_player_completed_challenge_1");
	self flag::init("flag_player_completed_challenge_2");
	self flag::init("flag_player_completed_challenge_3");
	self flag::init("flag_player_completed_challenge_4");
	if (level flag::get("gauntlet_quest_complete")) {
		self flag::set("flag_player_completed_challenge_4");
	}
	self flag::init("flag_player_initialized_reward");
	level flag::wait_till("initial_players_connected");
	self._challenges = spawnstruct();
	self._challenges.challenge_1 = SArrayRandom(level._challenges.challenge_1, "zm_stalingrad_challenges_order");
	self._challenges.challenge_2 = SArrayRandom(level._challenges.challenge_2, "zm_stalingrad_challenges_order");
	self._challenges.challenge_3 = SArrayRandom(level._challenges.challenge_3, "zm_stalingrad_challenges_order");
	while (level flag::get("solo_game") && level.players.size == 1 && self._challenges.challenge_3.str_notify == "update_challenge_3_4") {
        self._challenges.challenge_3 = SArrayRandom(level._challenges.challenge_3, "zm_stalingrad_challenges_order");
    }
	ArrayRemoveValue(level._challenges.challenge_1, self._challenges.challenge_1);
	ArrayRemoveValue(level._challenges.challenge_2, self._challenges.challenge_2);
	ArrayRemoveValue(level._challenges.challenge_3, self._challenges.challenge_3);
	self thread [[@zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_2ce855f3]](self._challenges.challenge_1);
	self thread [[@zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_2ce855f3]](self._challenges.challenge_2);
	self thread [[@zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_2ce855f3]](self._challenges.challenge_3);
	self thread [[@zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_fbbc8608]](self._challenges.challenge_1.n_index, "flag_player_completed_challenge_1");
	self thread [[@zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_fbbc8608]](self._challenges.challenge_2.n_index, "flag_player_completed_challenge_2");
	self thread [[@zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_fbbc8608]](self._challenges.challenge_3.n_index, "flag_player_completed_challenge_3");
	self thread [[@zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_974d5f1d]]();
	n_player_number = self GetEntityNumber();
	for (i = 1; i <= 4; i++) {
		self thread [[@zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_a2d25f82]](i);
	}
	foreach (s_challenge in struct::get_array("s_challenge_trigger")) {
		if (s_challenge.script_int == n_player_number) {
			s_challenge function_4e61a018();
			break;
		}
	}
}

detour zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_4e61a018()
{
    return function_4e61a018();
}

function_4e61a018()
{
	self zm_unitrigger::create_unitrigger("", 128, @zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_3ae0d6d5);
	self.s_unitrigger.require_look_at = 0;
	self.s_unitrigger.inactive_reassess_time = 0.1;
	zm_unitrigger::unitrigger_force_per_player_triggers(self.s_unitrigger, 1);
	self.var_b2a5207f = GetEnt("challenge_gravestone_" + self.script_int, "targetname");
	self.var_407ba908 = [];
	if (!IsDefined(self.var_407ba908)) {
		self.var_407ba908 = [];
	}
	else if (!IsArray(self.var_407ba908)) {
		self.var_407ba908 = array(self.var_407ba908);
	}
	self.var_407ba908[self.var_407ba908.size] = "ar_famas_upgraded";
	if (!IsDefined(self.var_407ba908)) {
		self.var_407ba908 = [];
	}
	else if (!IsArray(self.var_407ba908)) {
		self.var_407ba908 = array(self.var_407ba908);
	}
	self.var_407ba908[self.var_407ba908.size] = "ar_garand_upgraded";
	if (!IsDefined(self.var_407ba908)) {
		self.var_407ba908 = [];
	}
	else if (!IsArray(self.var_407ba908)) {
		self.var_407ba908 = array(self.var_407ba908);
	}
	self.var_407ba908[self.var_407ba908.size] = "smg_mp40_upgraded";
	if (!IsDefined(self.var_407ba908)) {
		self.var_407ba908 = [];
	}
	else if (!IsArray(self.var_407ba908)) {
		self.var_407ba908 = array(self.var_407ba908);
	}
	self.var_407ba908[self.var_407ba908.size] = "special_crossbow_dw_upgraded";
	if (!IsDefined(self.var_407ba908)) {
		self.var_407ba908 = [];
	}
	else if (!IsArray(self.var_407ba908)) {
		self.var_407ba908 = array(self.var_407ba908);
	}
	self.var_407ba908[self.var_407ba908.size] = "launcher_multi_upgraded";
	self.var_407ba908 = SArrayRandomize(self.var_407ba908, "zm_stalingrad_challenges_weapon");
	self.var_d86e8be = 0;
	self thread [[@zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_424b6fe8]]();
}

detour zm_stalingrad_challenges<scripts\zm\zm_stalingrad_challenges.gsc>::function_6131520e()
{
	self endon("disconnect");
	a_str_perks = GetArrayKeys(level._custom_perks);
	a_str_perks = SArrayRandomize(a_str_perks, "zm_stalingrad_challenges_perk");
	foreach (str_perk in a_str_perks) {
		if (!self HasPerk(str_perk)) {
			self zm_perks::give_perk(str_perk, 0);
			break;
		}
	}
}