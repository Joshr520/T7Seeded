detour zm_weapons<scripts\zm\_zm_weapons.gsc>::random_attachment(weapon, exclude)
{
	lo = 0;
	if (IsDefined(level.zombie_weapons[weapon].addon_attachments) && level.zombie_weapons[weapon].addon_attachments.size > 0) {
		attachments = level.zombie_weapons[weapon].addon_attachments;
	}
	else {
		attachments = weapon.supportedattachments;
		lo = 1;
	}
	minatt = lo;
	if (IsDefined(exclude) && exclude != "none") {
		minatt = lo + 1;
	}
	if (attachments.size > minatt) {
		for (;;) {
			idx = (SRandomInt("zm_weapons_random_attachment", attachments.size - lo)) + lo;
			if (!IsDefined(exclude) || attachments[idx] != exclude) {
				return attachments[idx];
			}
		}
	}
	return "none";
}

detour zm_weapons<scripts\zm\_zm_weapons.gsc>::get_pack_a_punch_weapon_options(weapon)
{
	if (!IsDefined(self.pack_a_punch_weapon_options)) {
		self.pack_a_punch_weapon_options = [];
	}
	if (!zm_weapons::is_weapon_upgraded(weapon)) {
		return self CalcWeaponOptions(0, 0, 0, 0, 0);
	}
	if (IsDefined(self.pack_a_punch_weapon_options[weapon])) {
		return self.pack_a_punch_weapon_options[weapon];
	}
	smiley_face_reticle_index = 1;
	camo_index = zm_weapons::get_pack_a_punch_camo_index(undefined);
	lens_index = SRandomIntRange("zm_weapons_pack_options", 0, 6);
	reticle_index = SRandomIntRange("zm_weapons_pack_options", 0, 16);
	reticle_color_index = SRandomIntRange("zm_weapons_pack_options", 0, 6);
	plain_reticle_index = 16;
	use_plain = SRandomInt("zm_weapons_pack_options", 10) < 1;
	if ("saritch_upgraded" == weapon.rootweapon.name) {
		reticle_index = smiley_face_reticle_index;
	}
	else if (use_plain) {
		reticle_index = plain_reticle_index;
	}
	scary_eyes_reticle_index = 8;
	purple_reticle_color_index = 3;
	if (reticle_index == scary_eyes_reticle_index) {
		reticle_color_index = purple_reticle_color_index;
	}
	letter_a_reticle_index = 2;
	pink_reticle_color_index = 6;
	if (reticle_index == letter_a_reticle_index) {
		reticle_color_index = pink_reticle_color_index;
	}
	letter_e_reticle_index = 7;
	green_reticle_color_index = 1;
	if (reticle_index == letter_e_reticle_index) {
		reticle_color_index = green_reticle_color_index;
	}
	self.pack_a_punch_weapon_options[weapon] = self CalcWeaponOptions(camo_index, lens_index, reticle_index, reticle_color_index);
	return self.pack_a_punch_weapon_options[weapon];
}

detour zm_weapons<scripts\zm\_zm_weapons.gsc>::get_pack_a_punch_camo_index(prev_pap_index)
{
	if (IsDefined(level.pack_a_punch_camo_index_number_variants)) {
		if (IsDefined(prev_pap_index)) {
			camo_variant = prev_pap_index + 1;
			if (camo_variant >= (level.pack_a_punch_camo_index + level.pack_a_punch_camo_index_number_variants)) {
				camo_variant = level.pack_a_punch_camo_index;
			}
			return camo_variant;
		}
		camo_variant = SRandomIntRange("zm_weapons_camo", 0, level.pack_a_punch_camo_index_number_variants);
		return level.pack_a_punch_camo_index + camo_variant;
	}
	return level.pack_a_punch_camo_index;
}