detour zm_bgb_soda_fountain<scripts\zm\bgbs\_zm_bgb_soda_fountain.gsc>::event()
{
	self endon("disconnect");
	self endon("bgb_update");
	self.var_76382430 = 5;
	while (self.var_76382430 > 0) {
		self waittill("perk_purchased", str_perk);
		self bgb::do_one_shot_use();
		a_str_perks = GetArrayKeys(level._custom_perks);
		if (IsInArray(a_str_perks, str_perk)) {
			ArrayRemoveValue(a_str_perks, str_perk);
		}
		a_str_perks = SArrayRandomize(a_str_perks, "zm_bgb_soda_fountain_perk");
		for (i = 0; i < a_str_perks.size; i++) {
			if (!self HasPerk(a_str_perks[i])) {
				self zm_perks::give_perk(a_str_perks[i], 0);
				break;
			}
		}
		self.var_76382430--;
		self bgb::set_timer(self.var_76382430, 5);
	}
}