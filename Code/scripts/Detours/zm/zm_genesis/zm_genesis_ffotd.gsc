detour zm_genesis_ffotd<scripts\zm\zm_genesis_ffotd.gsc>::function_8921895f()
{
	var_cdb0f86b = GetArrayKeys(level.zombie_powerups);
	var_b4442b55 = array("bonus_points_team", "shield_charge", "ww_grenade", "genesis_random_weapon");
	var_d7a75a6e = [];
	for (i = 0; i < var_cdb0f86b.size; i++) {
		var_77917a61 = 0;
		foreach (var_68de493a in var_b4442b55) {
			if (var_cdb0f86b[i] == var_68de493a) {
				var_77917a61 = 1;
			}
		}
		if (var_77917a61) {
			continue;
		}
		var_d7a75a6e[var_d7a75a6e.size] = var_cdb0f86b[i];
	}
	var_d7a75a6e = SArrayRandomize(var_d7a75a6e, "zm_genesis_ffotd_feelin_lucky");
	return var_d7a75a6e[0];
}