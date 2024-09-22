detour zm_bgb_disorderly_combat<scripts\zm\bgbs\_zm_bgb_disorderly_combat.gsc>::function_7039f685()
{
	self endon("disconnect");
	self endon("bled_out");
	self endon("bgb_update");
	level.var_8fcdc919 = SArrayRandomize(level.var_8fcdc919, "zm_bgb_disorderly_combat_weapons");
	self SetPerk("specialty_ammodrainsfromstockfirst");
	self thread zm_bgb_disorderly_combat::disable_weapons();
	self.get_player_weapon_limit = @zm_bgb_disorderly_combat<scripts\zm\bgbs\_zm_bgb_disorderly_combat.gsc>::function_7087df78;
	self util::waittill_either("weapon_change_complete", "bgb_flavor_hexed_give_zm_bgb_disorderly_combat");
	if (!IsDefined(self.var_fe555a38)) {
		self.var_fe555a38 = self GetCurrentWeapon();
	}
	b_upgraded = zm_weapons::is_weapon_upgraded(self.var_fe555a38);
	var_6c94ea19 = self aat::getaatonweapon(self.var_fe555a38);
	if (IsDefined(var_6c94ea19)) {
		zm_bgb_disorderly_combat::function_c7d73bac(var_6c94ea19.name);
	}
	if (IsDefined(self.aat) && self.aat.size) {
		self.var_cc73883d = ArrayCopy(self.aat);
		self.aat = [];
	}
	n_index = 0;
	var_1ff6fb34 = 0;
	for (;;) {
		self bgb::function_378bff5d();
		self zm_bgb_disorderly_combat::function_8a5ef15f();
		if (IsDefined(self.var_8cee13f3)) {
			if (self HasWeapon(self.var_8cee13f3)) {
				self TakeWeapon(self.var_8cee13f3);
			}
			else {
				self TakeWeapon(self GetCurrentWeapon());
			}
		}
		self PlaySoundToPlayer("zmb_bgb_disorderly_weap_switch", self);
		if (IsDefined(var_6c94ea19) && level.var_5013e65c.size) {
			var_77bd95a = level.var_5013e65c[var_1ff6fb34];
			var_1ff6fb34++;
			if (var_1ff6fb34 >= level.var_5013e65c.size) {
				level.var_5013e65c = SArrayRandomize(level.var_5013e65c, "zm_bgb_disorderly_combat_weapons");
				var_1ff6fb34 = 0;
			}
		}
		var_aca7cde1 = self zm_bgb_disorderly_combat::function_4035ce17(n_index, b_upgraded, var_77bd95a);
		n_index++;
		while (!var_aca7cde1) {
            var_aca7cde1 = self zm_bgb_disorderly_combat::function_4035ce17(n_index, b_upgraded, var_77bd95a);
			n_index++;
        }
		self thread zm_bgb_disorderly_combat::function_dedb7bff();
		wait 10;
	}
}

detour zm_bgb_disorderly_combat<scripts\zm\bgbs\_zm_bgb_disorderly_combat.gsc>::function_4035ce17(n_index, b_upgraded, var_77bd95a)
{
	if (n_index >= level.var_8fcdc919.size) {
		level.var_8fcdc919 = SArrayRandomize(level.var_8fcdc919, "zm_bgb_disorderly_combat_weapons");
		n_index = 0;
	}
	var_e3c04036 = level.var_8fcdc919[n_index];
	if (b_upgraded) {
		var_e3c04036 = zm_weapons::get_upgrade_weapon(var_e3c04036);
	}
	if (!self zm_bgb_disorderly_combat::has_weapon(var_e3c04036)) {
		var_e3c04036 = self zm_weapons::give_build_kit_weapon(var_e3c04036);
		self.var_8cee13f3 = var_e3c04036;
		self GiveWeapon(var_e3c04036);
		self ShouldDoInitialWeaponRaise(var_e3c04036, 0);
		self SwitchToWeaponImmediate(var_e3c04036);
		if (IsDefined(var_77bd95a) && var_77bd95a != "none") {
			self thread aat::acquire(var_e3c04036, var_77bd95a);
		}
		self bgb::do_one_shot_use(1);
		return true;
	}
	return false;
}

detour zm_bgb_disorderly_combat<scripts\zm\bgbs\_zm_bgb_disorderly_combat.gsc>::function_c7d73bac(str_name)
{
	ArrayRemoveValue(level.var_5013e65c, str_name);
	level.var_5013e65c = SArrayRandomize(level.var_5013e65c, "zm_bgb_disorderly_combat_weapons");
	if (!IsDefined(level.var_5013e65c)) {
		level.var_5013e65c = [];
	}
	else if (!IsArray(level.var_5013e65c)) {
		level.var_5013e65c = array(level.var_5013e65c);
	}
	level.var_5013e65c[level.var_5013e65c.size] = str_name;
}