detour zm_genesis_challenges<scripts\zm\zm_genesis_challenges.gsc>::on_player_connect()
{
	level flag::wait_till("flag_init_player_challenges");
	self flag::init("flag_player_collected_reward_1");
	self flag::init("flag_player_collected_reward_2");
	self flag::init("flag_player_collected_reward_3");
	self flag::init("flag_player_completed_challenge_1");
	self flag::init("flag_player_completed_challenge_2");
	self flag::init("flag_player_completed_challenge_3");
	self flag::init("flag_player_initialized_reward");
	self.s_challenges = SpawnStruct();
	self.s_challenges.a_challenge_1 = [];
	self.s_challenges.a_challenge_2 = [];
	self.s_challenges.a_challenge_3 = [];
	self.s_challenges.a_challenge_1 = SArrayRandom(level.s_challenges.a_challenge_1, "zm_genesis_challenges_init");
	self.s_challenges.a_challenge_2 = SArrayRandom(level.s_challenges.a_challenge_2, "zm_genesis_challenges_init");
	self.s_challenges.a_challenge_3 = SArrayRandom(level.s_challenges.a_challenge_3, "zm_genesis_challenges_init");
	ArrayRemoveValue(level.s_challenges.a_challenge_1, self.s_challenges.a_challenge_1);
	ArrayRemoveValue(level.s_challenges.a_challenge_2, self.s_challenges.a_challenge_2);
	ArrayRemoveValue(level.s_challenges.a_challenge_3, self.s_challenges.a_challenge_3);
	self thread [[@zm_genesis_challenges<scripts\zm\zm_genesis_challenges.gsc>::function_b7156b15]]();
}

detour zm_genesis_challenges<scripts\zm\zm_genesis_challenges.gsc>::function_1d22626(e_player, n_challenge)
{
	e_player endon("disconnect");
	var_7bb343ef = (0, 90, 0);
	var_93571595 = struct::get_array("s_challenge_reward", "targetname");
	n_entity = e_player GetEntityNumber();
	foreach (s_reward in var_93571595) {
		if (s_reward.script_int == n_entity) {
			break;
		}
	}
	switch (n_challenge) {
		case 1: {
			var_17b3dc96 = "p7_zm_power_up_max_ammo";
			s_reward.var_e1513629 = Vectorscale((0, 0, 1), 6);
			s_reward.var_b90d551 = var_7bb343ef;
			break;
		}
		case 2: {
			var_3728fce1 = [];
			if (!IsDefined(var_3728fce1)) {
				var_3728fce1 = [];
			}
			else if (!IsArray(var_3728fce1)) {
				var_3728fce1 = array(var_3728fce1);
			}
			var_3728fce1[var_3728fce1.size] = "lmg_cqb_upgraded";
			if (!IsDefined(var_3728fce1)) {
				var_3728fce1 = [];
			}
			else if (!IsArray(var_3728fce1)) {
				var_3728fce1 = array(var_3728fce1);
			}
			var_3728fce1[var_3728fce1.size] = "ar_damage_upgraded";
			if (!IsDefined(var_3728fce1)) {
				var_3728fce1 = [];
			}
			else if (!IsArray(var_3728fce1)) {
				var_3728fce1 = array(var_3728fce1);
			}
			var_3728fce1[var_3728fce1.size] = "smg_versatile_upgraded";
			var_17b3dc96 = SArrayRandom(var_3728fce1, "zm_genesis_challenges_reward");
			var_6b215f76 = (AnglesToRight(s_reward.angles) * 5) + (AnglesToForward(s_reward.angles) * -2);
			s_reward.var_e1513629 = var_6b215f76 + (0, 0, 1);
			s_reward.var_b90d551 = var_7bb343ef;
			break;
		}
		case 3: {
			var_17b3dc96 = "zombie_pickup_perk_bottle";
			var_1bfa1f7e = AnglesToForward(s_reward.angles) * -2;
			s_reward.var_e1513629 = var_1bfa1f7e + Vectorscale((0, 0, 1), 7);
			s_reward.var_b90d551 = var_7bb343ef;
			break;
		}
	}
	e_player.var_c981566c = 1;
	var_df95c68b = level.a_e_challenge_boards[n_entity];
	var_df95c68b scene::play("p7_fxanim_zm_gen_challenge_prizestone_open_bundle", var_df95c68b);
	var_df95c68b clientfield::set("challenge_board_reward", 1);
	self [[@zm_genesis_challenges<scripts\zm\zm_genesis_challenges.gsc>::function_b1f54cb4]](e_player, s_reward, var_17b3dc96, 30);
	self.var_30ff0d6c clientfield::set("powerup_fx", 1);
	self.var_30ff0d6c.n_challenge = n_challenge;
	e_player flag::set("flag_player_initialized_reward");
	self thread [[@zm_genesis_challenges<scripts\zm\zm_genesis_challenges.gsc>::function_1ad9d1a0]](e_player, 30 * -1, n_entity);
}