detour aat<scripts\shared\aat_shared.gsc>::aat_response(death, inflictor, attacker, damage, flags, mod, weapon, vpoint, vdir, shitloc, psoffsettime, boneindex, surfacetype)
{
	if (!IsPlayer(attacker)) {
		return;
	}
	if (mod != "MOD_PISTOL_BULLET" && mod != "MOD_RIFLE_BULLET" && mod != "MOD_GRENADE" && mod != "MOD_PROJECTILE" && mod != "MOD_EXPLOSIVE" && mod != "MOD_IMPACT") {
		return;
	}
	weapon = aat::get_nonalternate_weapon(weapon);
	name = attacker.aat[weapon];
	if (!IsDefined(name)) {
		return;
	}
	if (death && !level.aat[name].occurs_on_death) {
		return;
	}
	if (!IsDefined(self.archetype)) {
		return;
	}
	if (IS_TRUE(level.aat[name].immune_trigger[self.archetype])) {
		return;
	}
	now = GetTime() / 1000;
	if (now <= (self.aat_cooldown_start[name] + level.aat[name].cooldown_time_entity)) {
		return;
	}
	if (now <= (attacker.aat_cooldown_start[name] + level.aat[name].cooldown_time_attacker)) {
		return;
	}
	if (now <= (level.aat[name].cooldown_time_global_start + level.aat[name].cooldown_time_global)) {
		return;
	}
	if (IsDefined(level.aat[name].validation_func)) {
		if (!self [[level.aat[name].validation_func]]()) {
			return;
		}
	}
	success = 0;
	reroll_icon = undefined;
	percentage = level.aat[name].percentage;
	if (percentage >= SRandomFloat("aat_roll", 1)) {
		success = 1;
	}
	if (!success) {
		keys = GetArrayKeys(level.aat_reroll);
		keys = SArrayRandomize(keys, "aat_roll");
		foreach (key in keys) {
			if (attacker [[level.aat_reroll[key].active_func]]()) {
				for (i = 0; i < level.aat_reroll[key].count; i++) {
					if (percentage >= SRandomFloat("aat_roll", 1)) {
						success = 1;
						reroll_icon = level.aat_reroll[key].damage_feedback_icon;
						break;
					}
				}
			}
			if (success)
			{
				break;
			}
		}
	}
	if (!success) {
		return;
	}
	level.aat[name].cooldown_time_global_start = now;
	attacker.aat_cooldown_start[name] = now;
	self thread [[level.aat[name].result_func]](death, attacker, mod, weapon);
	attacker thread damagefeedback::update_override(level.aat[name].damage_feedback_icon, level.aat[name].damage_feedback_sound, reroll_icon);
}

detour aat<scripts\shared\aat_shared.gsc>::acquire(weapon, name)
{
	if (!IS_TRUE(level.aat_in_use)) {
		return;
	}
	weapon = aat::get_nonalternate_weapon(weapon);
	if (aat::is_exempt_weapon(weapon))
	{
		return;
	}
	if (IsDefined(name)) {
		self.aat[weapon] = name;
	}
	else {
		keys = GetArrayKeys(level.aat);
		ArrayRemoveValue(keys, "none");
		if (IsDefined(self.aat[weapon])) {
			ArrayRemoveValue(keys, self.aat[weapon]);
		}
		rand = SRandomInt("aat_acquire", keys.size);
		self.aat[weapon] = keys[rand];
	}
	if (weapon == self GetCurrentWeapon()) {
		self clientfield::set_to_player("aat_current", level.aat[self.aat[weapon]].clientfield_index);
	}
}