detour zm_perk_widows_wine<scripts\zm\_zm_perk_widows_wine.gsc>::widows_wine_zombie_death_watch(attacker)
{
	if (IS_TRUE(self.b_widows_wine_cocoon) || IS_TRUE(self.b_widows_wine_slow) && !IS_TRUE(self.b_widows_wine_no_powerup)) {
		if (IsDefined(self.attacker) && IsPlayer(self.attacker) && self.attacker HasPerk("specialty_widowswine")) {
			chance = 0.2;
			if (IsDefined(self.damageweapon) && self.damageweapon == level.w_widows_wine_grenade) {
				chance = 0.15;
			}
			else if (IsDefined(self.damageweapon) && (self.damageweapon == level.w_widows_wine_knife || self.damageweapon == level.w_widows_wine_bowie_knife || self.damageweapon == level.w_widows_wine_sickle_knife)) {
				chance = 0.25;
			}
			if (SRandomFloat("zm_perk_widows_wine_powerup", 1) <= chance) {
				self.no_powerups = 1;
				level._powerup_timeout_override = @zm_perk_widows_wine<scripts\zm\_zm_perk_widows_wine.gsc>::powerup_widows_wine_timeout;
				level thread zm_powerups::specific_powerup_drop("ww_grenade", self.origin, undefined, undefined, undefined, self.attacker);
				level._powerup_timeout_override = undefined;
			}
		}
	}
}