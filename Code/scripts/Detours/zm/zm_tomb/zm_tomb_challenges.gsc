detour zm_tomb_challenges<scripts\zm\zm_tomb_challenges.gsc>::reward_packed_weapon(player, s_stat)
{
	if (!IsDefined(s_stat.var_e564b69e)) {
		a_weapons = array("smg_capacity", "smg_mp40_1940", "ar_accurate");
		var_7e5dd894 = GetWeapon(SArrayRandom(a_weapons, "zm_tomb_challenges_weapon"));
		s_stat.var_e564b69e = zm_weapons::get_upgrade_weapon(var_7e5dd894);
	}
	m_weapon = Spawn("script_model", self.origin);
	m_weapon.angles = self.angles + vectorscale((0, 1, 0), 180);
	m_weapon PlaySound("zmb_spawn_powerup");
	m_weapon PlayLoopSound("zmb_spawn_powerup_loop", 0.5);
	str_model = [[@zm_tomb_challenges<scripts\zm\zm_tomb_challenges.gsc>::getweaponmodel]](s_stat.var_e564b69e);
	options = player zm_weapons::get_pack_a_punch_weapon_options(s_stat.var_e564b69e);
	m_weapon UseWeaponModel(s_stat.var_e564b69e, str_model, options);
	util::wait_network_frame();
	if (![[@zm_challenges_tomb<scripts\zm\zm_challenges_tomb.gsc>::reward_rise_and_grab]](m_weapon, 50, 2, 2, 10)) {
		return false;
	}
	weapon_limit = zm_utility::get_player_weapon_limit(player);
	primaries = player GetWeaponsListPrimaries();
	if (IsDefined(primaries) && primaries.size >= weapon_limit) {
		player zm_weapons::weapon_give(s_stat.var_e564b69e);
	}
	else {
		player zm_weapons::give_build_kit_weapon(s_stat.var_e564b69e);
		player GiveStartAmmo(s_stat.var_e564b69e);
	}
	player SwitchToWeapon(s_stat.var_e564b69e);
	m_weapon StopLoopSound(0.1);
	player PlaySound("zmb_powerup_grabbed");
	m_weapon Delete();
	return true;
}