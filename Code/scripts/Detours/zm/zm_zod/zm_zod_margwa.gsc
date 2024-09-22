detour zm_zod_margwa<scripts\zm\zm_zod_margwa.gsc>::function_aea74ccd()
{
	var_e0191376 = [[@zm_zod_margwa<scripts\zm\zm_zod_margwa.gsc>::function_79c1b763]]();
	wait 5;
	while (var_e0191376 > 0) {
		while (![[@zm_zod_margwa<scripts\zm\zm_zod_margwa.gsc>::function_8303722e]]()) {
			wait 1;
		}
		var_225347e1 = function_8bcb72e9(1);
		if (IsDefined(var_225347e1)) {
			var_e0191376--;
		}
		if (var_e0191376 > 0) {
			wait SRandomFloatRange("zm_zod_margwa_round", 5, 10);
		}
	}
	level.var_bf361dc0 = level.round_number + SRandomIntRange("zm_zod_margwa_round", 5, 7);
}

detour zm_zod_margwa<scripts\zm\zm_zod_margwa.gsc>::function_8bcb72e9(var_8f401985, s_loc)
{
    return function_8bcb72e9(var_8f401985, s_loc);
}

function_8bcb72e9(var_8f401985, s_loc)
{
	if (!IsDefined(s_loc)) {
		if (level.zm_loc_types["margwa_location"].size == 0) {
			return undefined;
		}
		s_loc = SArrayRandom(level.zm_loc_types["margwa_location"], "zm_zod_margwa_spawn");
	}
	var_225347e1 = [[@zm_ai_margwa<scripts\zm\_zm_ai_margwa.gsc>::function_8a0708c2]](s_loc);
	var_225347e1.var_26f9f957 = @zm_zod_margwa<scripts\zm\zm_zod_margwa.gsc>::function_26f9f957;
	level.var_95981590 = var_225347e1;
	level notify(#"hash_c484afcb");
	if (IsDefined(var_225347e1)) {
		var_225347e1.b_ignore_cleanup = 1;
		var_225347e1 thread [[@zm_zod_margwa<scripts\zm\zm_zod_margwa.gsc>::function_8d578a58]]();
		n_health = (level.round_number * 100) + 100;
		var_225347e1 [[@margwaserverutils<scripts\shared\ai\margwa.gsc>::margwasetheadhealth]](n_health);
	}
	if (!IS_TRUE(var_8f401985)) {
		level.var_bf361dc0 = level.round_number + SRandomIntRange("zm_zod_margwa_round", 5, 7);
	}
	return var_225347e1;
}