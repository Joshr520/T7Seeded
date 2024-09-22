detour zm_perks<scripts\zm\_zm_perks.gsc>::quantum_bomb_give_nearest_perk_result(position)
{
	[[level.quantum_bomb_play_mystery_effect_func]](position);
	vending_triggers = GetEntArray("zombie_vending", "targetname");
	nearest = 0;
	for (i = 1; i < vending_triggers.size; i++) {
		if (DistanceSquared(vending_triggers[i].origin, position) < DistanceSquared(vending_triggers[nearest].origin, position)) {
			nearest = i;
		}
	}
	players = GetPlayers();
	perk = vending_triggers[nearest].script_noteworthy;
	for (i = 0; i < players.size; i++) {
		player = players[i];
		if (player.sessionstate == "spectator" || player laststand::player_is_in_laststand()) {
			continue;
		}
		if (!player HasPerk(perk) && (!IsDefined(player.perk_purchased) || player.perk_purchased != perk) && SRandomInt("zm_perks_qed", 5)) {
			if (player == self) {
				self thread zm_audio::create_and_play_dialog("kill", "quant_good");
			}
			player zm_perks::give_perk(perk);
			player [[level.quantum_bomb_play_player_effect_func]]();
		}
	}
}

detour zm_perks<scripts\zm\_zm_perks.gsc>::give_random_perk()
{
	random_perk = undefined;
	a_str_perks = GetArrayKeys(level._custom_perks);
	perks = [];
	for (i = 0; i < a_str_perks.size; i++) {
		perk = a_str_perks[i];
		if (IsDefined(self.perk_purchased) && self.perk_purchased == perk) {
			continue;
		}
		if (!self HasPerk(perk) && !self zm_perks::has_perk_paused(perk)) {
			perks[perks.size] = perk;
		}
	}
	if (perks.size > 0) {
		perks = SArrayRandomize(perks, "zm_perks_give");
		random_perk = perks[0];
		self zm_perks::give_perk(random_perk);
	}
	else {
		self PlaySoundToPlayer(level.zmb_laugh_alias, self);
	}
	return random_perk;
}

detour zm_perks<scripts\zm\_zm_perks.gsc>::lose_random_perk()
{
	a_str_perks = GetArrayKeys(level._custom_perks);
	perks = [];
	for (i = 0; i < a_str_perks.size; i++) {
		perk = a_str_perks[i];
		if (IsDefined(self.perk_purchased) && self.perk_purchased == perk) {
			continue;
		}
		if (self HasPerk(perk) || self zm_perks::has_perk_paused(perk)) {
			perks[perks.size] = perk;
		}
	}
	if (perks.size > 0) {
		perks = SArrayRandomize(perks, "zm_perks_lose");
		perk = perks[0];
		perk_str = perk + "_stop";
		self notify(perk_str);
		if (zm_perks::use_solo_revive() && perk == "specialty_quickrevive") {
			self.lives--;
		}
	}
}

detour zm_perks<scripts\zm\_zm_perks.gsc>::perk_machine_spawn_init()
{
	match_string = "";
	location = level.scr_zm_map_start_location;
	if (location == "default" || location == "" && IsDefined(level.default_start_location)) {
		location = level.default_start_location;
	}
	match_string = (level.scr_zm_ui_gametype + "_perks_") + location;
	a_s_spawn_pos = [];
	if (IsDefined(level.override_perk_targetname)) {
		structs = struct::get_array(level.override_perk_targetname, "targetname");
	}
	else {
		structs = struct::get_array("zm_perk_machine", "targetname");
	}
	foreach (struct in structs) {
		if (IsDefined(struct.script_string)) {
			tokens = StrTok(struct.script_string, " ");
			foreach (token in tokens) {
				if (token == match_string) {
					a_s_spawn_pos[a_s_spawn_pos.size] = struct;
				}
			}
			continue;
		}
		a_s_spawn_pos[a_s_spawn_pos.size] = struct;
	}
	if (a_s_spawn_pos.size == 0) {
		return;
	}
	if (IS_TRUE(level.randomize_perk_machine_location)) {
		a_s_random_perk_locs = struct::get_array("perk_random_machine_location", "targetname");
		if (a_s_random_perk_locs.size > 0) {
			a_s_random_perk_locs = SArrayRandomize(a_s_random_perk_locs, "zm_perks_location");
		}
		n_random_perks_assigned = 0;
	}
	foreach (s_spawn_pos in a_s_spawn_pos) {
		perk = s_spawn_pos.script_noteworthy;
		if (IsDefined(perk) && IsDefined(s_spawn_pos.model)) {
			if (IS_TRUE(level.randomize_perk_machine_location) && a_s_random_perk_locs.size > 0 && IsDefined(s_spawn_pos.script_notify)) {
				s_new_loc = a_s_random_perk_locs[n_random_perks_assigned];
				s_spawn_pos.origin = s_new_loc.origin;
				s_spawn_pos.angles = s_new_loc.angles;
				if (IsDefined(s_new_loc.script_int)) {
					s_spawn_pos.script_int = s_new_loc.script_int;
				}
				if (IsDefined(s_new_loc.target)) {
					s_tell_location = struct::get(s_new_loc.target);
					if (IsDefined(s_tell_location)) {
						util::spawn_model("p7_zm_perk_bottle_broken_" + perk, s_tell_location.origin, s_tell_location.angles);
					}
				}
				n_random_perks_assigned++;
			}
			t_use = Spawn("trigger_radius_use", s_spawn_pos.origin + VectorScale((0, 0, 1), 60), 0, 40, 80);
			t_use.targetname = "zombie_vending";
			t_use.script_noteworthy = perk;
			if (IsDefined(s_spawn_pos.script_int)) {
				t_use.script_int = s_spawn_pos.script_int;
			}
			t_use TriggerIgnoreTeam();
			perk_machine = Spawn("script_model", s_spawn_pos.origin);
			if (!IsDefined(s_spawn_pos.angles)) {
				s_spawn_pos.angles = (0, 0, 0);
			}
			perk_machine.angles = s_spawn_pos.angles;
			perk_machine SetModel(s_spawn_pos.model);
			if (IS_TRUE(level._no_vending_machine_bump_trigs)) {
				bump_trigger = undefined;
			}
			else {
				bump_trigger = Spawn("trigger_radius", s_spawn_pos.origin + VectorScale((0, 0, 1), 20), 0, 40, 80);
				bump_trigger.script_activated = 1;
				bump_trigger.script_sound = "zmb_perks_bump_bottle";
				bump_trigger.targetname = "audio_bump_trigger";
			}
			if (IS_TRUE(level._no_vending_machine_auto_collision)) {
				collision = undefined;
			}
			else {
				collision = Spawn("script_model", s_spawn_pos.origin, 1);
				collision.angles = s_spawn_pos.angles;
				collision SetModel("zm_collision_perks1");
				collision.script_noteworthy = "clip";
				collision DisconnectPaths();
			}
			t_use.clip = collision;
			t_use.machine = perk_machine;
			t_use.bump = bump_trigger;
			if (IsDefined(s_spawn_pos.script_notify)) {
				perk_machine.script_notify = s_spawn_pos.script_notify;
			}
			if (IsDefined(s_spawn_pos.target)) {
				perk_machine.target = s_spawn_pos.target;
			}
			if (IsDefined(s_spawn_pos.blocker_model)) {
				t_use.blocker_model = s_spawn_pos.blocker_model;
			}
			if (IsDefined(s_spawn_pos.script_int)) {
				perk_machine.script_int = s_spawn_pos.script_int;
			}
			if (IsDefined(s_spawn_pos.turn_on_notify)) {
				perk_machine.turn_on_notify = s_spawn_pos.turn_on_notify;
			}
			t_use.script_sound = "mus_perks_speed_jingle";
			t_use.script_string = "speedcola_perk";
			t_use.script_label = "mus_perks_speed_sting";
			t_use.target = "vending_sleight";
			perk_machine.script_string = "speedcola_perk";
			perk_machine.targetname = "vending_sleight";
			if (IsDefined(bump_trigger)) {
				bump_trigger.script_string = "speedcola_perk";
			}
			if (IsDefined(level._custom_perks[perk]) && IsDefined(level._custom_perks[perk].perk_machine_set_kvps)) {
				[[level._custom_perks[perk].perk_machine_set_kvps]](t_use, perk_machine, bump_trigger, collision);
			}
		}
	}
}