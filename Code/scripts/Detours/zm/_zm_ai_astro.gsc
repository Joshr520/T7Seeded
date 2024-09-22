detour zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::init()
{
    [[@zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::initastrobehaviorsandasm]]();
	spawner::add_archetype_spawn_function("astronaut", @zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::archetypeastroblackboardinit);
	spawner::add_archetype_spawn_function("astronaut", @zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astrospawnsetup);
	animationstatenetwork::registernotetrackhandlerfunction("headbutt_start", @zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_zombie_headbutt_release);
	animationstatenetwork::registernotetrackhandlerfunction("astro_melee", @zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_zombie_headbutt);
	[[@zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::init_astro_zombie_fx]]();
	if (!IsDefined(level.astro_zombie_enter_level)) {
		level.astro_zombie_enter_level = @zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_zombie_default_enter_level;
	}
	level.num_astro_zombies = 0;
	level.astro_zombie_spawners = GetEntArray("astronaut_zombie", "targetname");
	level.max_astro_zombies = 1;
	level.astro_zombie_health_mult = 4;
	level.min_astro_round_wait = 1;
	level.max_astro_round_wait = 2;
	level.astro_round_start = 1;
	level.next_astro_round = level.astro_round_start + (SRandomIntRange("zm_ai_astro_round", 0, level.max_astro_round_wait + 1));
	level.zombies_left_before_astro_spawn = 1;
	level.zombie_left_before_spawn = 0;
	level.astro_explode_radius = 400;
	level.astro_explode_blast_radius = 150;
	level.astro_explode_pulse_min = 100;
	level.astro_explode_pulse_max = 300;
	level.astro_headbutt_delay = 2000;
	level.astro_headbutt_radius_sqr = 4096;
	level.zombie_total_update = 0;
	level.zombie_total_set_func = ::astro_zombie_total_update;
	zm_spawner::register_zombie_damage_callback(@zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_damage_callback);
	while (!IsDefined(level.custom_ai_spawn_check_funcs)) {
		wait 0.05;
	}
	zm::register_custom_ai_spawn_check("astro", @zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_spawn_check, @zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::get_astro_spawners, @zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::get_astro_locations);
}

detour zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_zombie_total_update()
{
	return astro_zombie_total_update();
}

astro_zombie_total_update()
{
	level.zombie_total_update = 1;
	level.zombies_left_before_astro_spawn = 1;
	if (level.zombie_total > 1) {
		level.zombies_left_before_astro_spawn = SRandomIntRange("zm_ai_astro_spawn", Int(level.zombie_total * 0.25), Int(level.zombie_total * 0.75));
	}
}

detour zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_zombie_die(einflictor, attacker, idamage, smeansofdeath, weapon, vdir, shitloc, psoffsettime)
{
	PlayFXOnTag(level._effect["astro_explosion"], self, "J_SpineLower");
	self StopLoopSound(1);
	self PlaySound("evt_astro_zombie_explo");
	self thread [[@zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_delay_delete]]();
	self thread [[@zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_player_pulse]]();
	level.num_astro_zombies--;
	level.next_astro_round = level.round_number + (SRandomIntRange("zm_ai_astro_round", level.min_astro_round_wait, level.max_astro_round_wait + 1));
	level.zombie_total_update = 0;
	return self zm_spawner::zombie_death_animscript();
}

detour zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_zombie_attack()
{
	self endon("death");
	if (!IsDefined(self.player_to_headbutt)) {
		return;
	}
	player = self.player_to_headbutt;
	perk_list = [];
	vending_triggers = GetEntArray("zombie_vending", "targetname");
	for (i = 0; i < vending_triggers.size; i++) {
		perk = vending_triggers[i].script_noteworthy;
		if (player HasPerk(perk)) {
			perk_list[perk_list.size] = perk;
		}
	}
	take_perk = 0;
	if (perk_list.size > 0 && !IsDefined(player._retain_perks)) {
		take_perk = 1;
		perk_list = SArrayRandomize(perk_list, "zm_ai_astro_perk");
		perk = perk_list[0];
		perk_str = perk + "_stop";
		player notify(perk_str);
		if (level flag::get("solo_game") && perk == "specialty_quickrevive")
		{
			player.lives--;
		}
		player thread [[@zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_headbutt_damage]](self, self.origin);
	}
	if (!take_perk) {
		damage = player.health - 1;
		player DoDamage(damage, self.origin, self);
	}
}

detour zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_zombie_teleport_enemy()
{
	self endon("death");
	player = self.player_to_headbutt;
	black_hole_teleport_structs = struct::get_array("struct_black_hole_teleport", "targetname");
	chosen_spot = undefined;
	if (IsDefined(level._special_blackhole_bomb_structs)) {
		black_hole_teleport_structs = [[level._special_blackhole_bomb_structs]]();
	}
	player_current_zone = player zm_utility::get_current_zone();
	if (!IsDefined(black_hole_teleport_structs) || black_hole_teleport_structs.size == 0 || !IsDefined(player_current_zone)) {
		return;
	}
	black_hole_teleport_structs = SArrayRandomize(black_hole_teleport_structs, "zm_ai_astro_teleport");
	for (i = 0; i < black_hole_teleport_structs.size; i++) {
		volume = level.zones[black_hole_teleport_structs[i].script_string].volumes[0];
		zone_enabled = zm_zonemgr::get_zone_from_position(black_hole_teleport_structs[i].origin, 0);
		if (IsDefined(zone_enabled) && player_current_zone != black_hole_teleport_structs[i].script_string) {
			if (!level flag::get("power_on") || volume.script_string == "lowgravity") {
				chosen_spot = black_hole_teleport_structs[i];
				break;
			}
			else {
				chosen_spot = black_hole_teleport_structs[i];
			}
			continue;
		}
		if (IsDefined(zone_enabled)) {
			chosen_spot = black_hole_teleport_structs[i];
		}
	}
	if (IsDefined(chosen_spot)) {
		player thread [[@zm_ai_astro<scripts\zm\_zm_ai_astro.gsc>::astro_zombie_teleport]](chosen_spot);
	}
}