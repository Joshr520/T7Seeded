detour zm_bgb_im_feelin_lucky<scripts\zm\bgbs\_zm_bgb_im_feelin_lucky.gsc>::function_29a9b9b8()
{
	var_d7a75a6e = GetArrayKeys(level.zombie_powerups);
	var_d7a75a6e = SArrayRandomize(var_d7a75a6e, "zm_bgb_im_feelin_lucky_powerup");
	foreach (str_key in var_d7a75a6e) {
		if (level.zombie_powerups[str_key].player_specific === 1) {
			ArrayRemoveValue(var_d7a75a6e, str_key);
		}
	}
	return var_d7a75a6e[0];
}