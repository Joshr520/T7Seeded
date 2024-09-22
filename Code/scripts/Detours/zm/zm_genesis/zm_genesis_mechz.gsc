detour zm_genesis_mechz<scripts\zm\zm_genesis_mechz.gsc>::function_2a2bfc25()
{
	self waittill(#"hash_46c1e51d");
	if (level flag::get("zombie_drop_powerups") && !IS_TRUE(self.no_powerups)) {
		a_bonus_types = array("double_points", "insta_kill", "full_ammo", "nuke");
		str_type = SArrayRandom(a_bonus_types, "zm_genesis_mechz_powerup");
		zm_powerups::specific_powerup_drop(str_type, self.origin);
	}
}