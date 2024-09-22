detour zm_bgb_flavor_hexed<scripts\zm\bgbs\_zm_bgb_flavor_hexed.gsc>::event()
{
	self endon("disconnect");
	self endon("bled_out");
	self.var_c3a5a8 = [];
	var_2cf032a6 = self.bgb_pack;
	foreach (str_bgb, var_410edbc8 in level.bgb) {
		if (var_410edbc8.consumable == 1) {
			if (!IsInArray(var_2cf032a6, str_bgb) && str_bgb != "zm_bgb_flavor_hexed") {
				if (!IsDefined(self.var_c3a5a8)) {
					self.var_c3a5a8 = [];
				}
				else if (!IsArray(self.var_c3a5a8)) {
					self.var_c3a5a8 = array(self.var_c3a5a8);
				}
				self.var_c3a5a8[self.var_c3a5a8.size] = str_bgb;
			}
		}
	}
	var_50f0f8bb = SArrayRandom(self.var_c3a5a8, "zm_bgb_flavor_hexed_gum");
	self thread zm_bgb_flavor_hexed::function_9a45adfb(var_50f0f8bb);
}

detour zm_bgb_flavor_hexed<scripts\zm\bgbs\_zm_bgb_flavor_hexed.gsc>::function_655e0571(var_50f0f8bb)
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("bgb_gumball_anim_give");
	self waittill("bgb_update_give_" + var_50f0f8bb);
	self notify("bgb_flavor_hexed_give_" + var_50f0f8bb);
	self waittill("bgb_update", var_1531e8c4, var_9a4acf7);
	if (var_9a4acf7 === var_50f0f8bb && self.var_c3a5a8.size) {
		var_df8558a0 = SArrayRandom(self.var_c3a5a8, "zm_bgb_flavor_hexed_gum");
		self PlaySoundToPlayer("zmb_bgb_flavorhex", self);
		self thread zm_bgb_flavor_hexed::function_21f6c6f5(var_df8558a0);
		self bgb::give(var_df8558a0);
	}
}