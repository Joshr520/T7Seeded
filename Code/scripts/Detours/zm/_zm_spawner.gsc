detour zm_spawner<scripts\zm\_zm_spawner.gsc>::zombie_spawn_init(animname_set = 0)
{
	self.targetname = "zombie";
	self.script_noteworthy = undefined;
	zm_utility::recalc_zombie_array();
	if (!animname_set) {
		self.animname = "zombie";
	}
	if (Isdefined(zm_utility::get_gamemode_var("pre_init_zombie_spawn_func"))) {
		self [[zm_utility::get_gamemode_var("pre_init_zombie_spawn_func")]]();
	}
	self thread zm_spawner::play_ambient_zombie_vocals();
	self thread zm_audio::zmbaivox_notifyconvert();
	self.zmb_vocals_attack = "zmb_vocals_zombie_attack";
	self.ignoreme = 0;
	self.allowdeath = 1;
	self.force_gib = 1;
	self.is_zombie = 1;
	self AllowedStances("stand");
	self.attackercountthreatscale = 0;
	self.currentenemythreatscale = 0;
	self.recentattackerthreatscale = 0;
	self.coverthreatscale = 0;
	self.fovcosine = 0;
	self.fovcosinebusy = 0;
	self.zombie_damaged_by_bar_knockdown = 0;
	self.gibbed = 0;
	self.head_gibbed = 0;
	self SetPhysParams(15, 0, 72);
	self.goalradius = 32;
	self.disablearrivals = 1;
	self.disableexits = 1;
	self.grenadeawareness = 0;
	self.badplaceawareness = 0;
	self.ignoresuppression = 1;
	self.suppressionthreshold = 1;
	self.nododgemove = 1;
	self.dontshootwhilemoving = 1;
	self.pathenemylookahead = 0;
	self.holdfire = 1;
	self.badplaceawareness = 0;
	self.chatinitialized = 0;
	self.missinglegs = 0;
	if (!Isdefined(self.zombie_arms_position)) {
		if (SRandomInt("zm_spawner_spawn_init", 2) == 0) {
			self.zombie_arms_position = "up";
		}
		else {
			self.zombie_arms_position = "down";
		}
	}
	if (SRandomInt("zm_spawner_spawn_init", 100) < 25) {
		self.canstumble = 1;
	}
	self.a.disablepain = 1;
	self zm_utility::disable_react();
	if (Isdefined(level.zombie_health)) {
		self.maxhealth = level.zombie_health;
		if (Isdefined(level.a_zombie_respawn_health[self.archetype]) && level.a_zombie_respawn_health[self.archetype].size > 0) {
			self.health = level.a_zombie_respawn_health[self.archetype][0];
			ArrayRemoveValue(level.a_zombie_respawn_health[self.archetype], level.a_zombie_respawn_health[self.archetype][0]);
		}
		else {
			self.health = level.zombie_health;
		}
	}
	else {
		self.maxhealth = level.zombie_vars["zombie_health_start"];
		self.health = self.maxhealth;
	}
	self.freezegun_damage = 0;
	self SetAvoidanceMask("avoid none");
	self PathMode("dont move");
	level thread zm_spawner::zombie_death_event(self);
	self zm_utility::init_zombie_run_cycle();
	self thread zm_spawner::zombie_think();
	self thread zombie_utility::zombie_gib_on_damage();
	self thread zm_spawner::zombie_damage_failsafe();
	self thread zm_spawner::enemy_death_detection();
	if (Isdefined(level._zombie_custom_spawn_logic)) {
		if (IsArray(level._zombie_custom_spawn_logic)) {
			for (i = 0; i < level._zombie_custom_spawn_logic.size; i++) {
				self thread [[level._zombie_custom_spawn_logic[i]]]();
			}
		}
		else {
			self thread [[level._zombie_custom_spawn_logic]]();
		}
	}
	if (!IS_TRUE(self.no_eye_glow)) {
		if (!IS_TRUE(self.is_inert)) {
			self thread zombie_utility::delayed_zombie_eye_glow();
		}
	}
	self.deathfunction = zm_spawner::zombie_death_animscript;
	self.flame_damage_time = 0;
	self.meleedamage = 60;
	self.no_powerups = 1;
	self zm_spawner::zombie_history(("zombie_spawn_init -> Spawned = ") + self.origin);
	self.thundergun_knockdown_func = level.basic_zombie_thundergun_knockdown;
	self.tesla_head_gib_func = zm_spawner::zombie_tesla_head_gib;
	self.team = level.zombie_team;
	self.updatesight = 0;
	self.heroweapon_kill_power = 2;
	self.sword_kill_power = 2;
	if (Isdefined(level.achievement_monitor_func)) {
		self [[level.achievement_monitor_func]]();
	}
	if (Isdefined(zm_utility::get_gamemode_var("post_init_zombie_spawn_func"))) {
		self [[zm_utility::get_gamemode_var("post_init_zombie_spawn_func")]]();
	}
	if (Isdefined(level.zombie_init_done)) {
		self [[level.zombie_init_done]]();
	}
	self.zombie_init_done = 1;
	self notify("zombie_init_done");
}

detour zm_spawner<scripts\zm\_zm_spawner.gsc>::do_a_taunt()
{
	self endon("death");
	if (self.missinglegs) {
		return false;
	}
	if (!self.first_node.zbarrier ZBarrierSupportsZombieTaunts()) {
		return;
	}
	self.old_origin = self.origin;
	if (GetDvarString("zombie_taunt_freq") == "") {
		SetDvar("zombie_taunt_freq", "5");
	}
	freq = GetDvarInt("zombie_taunt_freq");
	if (freq >= SRandomInt("zm_spawner_taunt", 100)) {
		self notify("bhtn_action_notify", "taunt");
		tauntstate = "zm_taunt";
		if (Isdefined(self.first_node.zbarrier) && self.first_node.zbarrier GetZBarrierTauntAnimState() != "") {
			tauntstate = self.first_node.zbarrier GetZBarrierTauntAnimState();
		}
		self AnimScripted("taunt_anim", self.origin, self.angles, "ai_zombie_taunts_4");
		self zm_spawner::taunt_notetracks("taunt_anim");
	}
}

detour zm_spawner<scripts\zm\_zm_spawner.gsc>::should_attack_player_thru_boards()
{
	if (self.missinglegs) {
		return false;
	}
	if (Isdefined(self.first_node.zbarrier)) {
		if (!self.first_node.zbarrier ZBarrierSupportsZombieReachThroughAttacks()) {
			return false;
		}
	}
	if (GetDvarString("zombie_reachin_freq") == "") {
		SetDvar("zombie_reachin_freq", "50");
	}
	freq = GetDvarInt("zombie_reachin_freq");
	players = GetPlayers();
	attack = 0;
	self.player_targets = [];
	for (i = 0; i < players.size; i++) {
		if (IsAlive(players[i]) && !Isdefined(players[i].revivetrigger) && Distance2D(self.origin, players[i].origin) <= level.attack_player_thru_boards_range && !IS_TRUE(players[i].zombie_vars["zombie_powerup_zombie_blood_on"])) {
			self.player_targets[self.player_targets.size] = players[i];
			attack = 1;
		}
	}
	if (!attack || freq < SRandomInt("zm_spawner_attack_barrier", 100)) {
		return false;
	}
	self.old_origin = self.origin;
	attackanimstate = "zm_window_melee";
	if (Isdefined(self.first_node.zbarrier) && self.first_node.zbarrier GetZBarrierReachThroughAttackAnimState() != "") {
		attackanimstate = self.first_node.zbarrier GetZBarrierReachThroughAttackAnimState();
	}
	self notify("bhtn_action_notify", "attack");
	self AnimScripted("window_melee_anim", self.origin, self.angles, "ai_zombie_window_attack_arm_l_out");
	self zm_spawner::window_notetracks("window_melee_anim");
	return true;
}

detour zm_spawner<scripts\zm\_zm_spawner.gsc>::get_attack_spot_index(node)
{
	indexes = [];
	if (!Isdefined(node.attack_spots)) {
		node.attack_spots = [];
	}
	for (i = 0; i < node.attack_spots.size; i++) {
		if (!node.attack_spots_taken[i]) {
			indexes[indexes.size] = i;
		}
	}
	if (indexes.size == 0) {
		return undefined;
	}
	return indexes[SRandomInt("zm_spawner_attack_spot", indexes.size)];
}

detour zm_spawner<scripts\zm\_zm_spawner.gsc>::zombie_damage(mod, hit_location, hit_origin, player, amount, team, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel)
{
	if (zm_utility::is_magic_bullet_shield_enabled(self)) {
		return;
	}
	player.use_weapon_type = mod;
	if (Isdefined(self.marked_for_death)) {
		return;
	}
	if (!Isdefined(player)) {
		return;
	}
	if (Isdefined(hit_origin)) {
		self.damagehit_origin = hit_origin;
	}
	else {
		self.damagehit_origin = player GetWeaponMuzzlePoint();
	}
	if (self zm_spawner::check_zombie_damage_callbacks(mod, hit_location, hit_origin, player, amount, weapon, direction_vec, tagname, modelname, partname, dflags, inflictor, chargelevel)) {
		return;
	}
	if (!player zm_spawner::player_can_score_from_zombies()) {

	}
	else if (Isdefined(weapon) && weapon.isriotshield) {

    }
    else if (self zm_spawner::zombie_flame_damage(mod, player)) {
        if (self zm_spawner::zombie_give_flame_damage_points()) {
            player zm_score::player_add_points("damage", mod, hit_location, self.isdog, team);
        }
    }
    else {
        if (zm_spawner::player_using_hi_score_weapon(player)) {
            damage_type = "damage";
        }
        else {
            damage_type = "damage_light";
        }
        if (!IS_TRUE(self.no_damage_points)) {
            player zm_score::player_add_points(damage_type, mod, hit_location, self.isdog, team, weapon);
        }
    }
	if (Isdefined(self.zombie_damage_fx_func)) {
		self [[self.zombie_damage_fx_func]](mod, hit_location, hit_origin, player, direction_vec);
	}
	if ("MOD_IMPACT" != mod && zm_utility::is_placeable_mine(weapon)) {
		if (Isdefined(self.zombie_damage_claymore_func)) {
			self [[self.zombie_damage_claymore_func]](mod, hit_location, hit_origin, player);
		}
		else if (Isdefined(player) && IsAlive(player)) {
            self DoDamage(level.round_number * SRandomIntRange("zm_spawner_zombie_damage", 100, 200), self.origin, player, self, hit_location, mod, 0, weapon);
        }
        else {
            self DoDamage(level.round_number * SRandomIntRange("zm_spawner_zombie_damage", 100, 200), self.origin, undefined, self, hit_location, mod, 0, weapon);
        }
	}
	else if (mod == "MOD_GRENADE" || mod == "MOD_GRENADE_SPLASH") {
        if (Isdefined(player) && IsAlive(player)) {
            player.grenade_multiattack_count++;
            player.grenade_multiattack_ent = self;
            self DoDamage(level.round_number + SRandomIntRange("zm_spawner_zombie_damage", 100, 200), self.origin, player, self, hit_location, mod, 0, weapon);
        }
        else {
            self DoDamage(level.round_number + SRandomIntRange("zm_spawner_zombie_damage", 100, 200), self.origin, undefined, self, hit_location, mod, 0, weapon);
        }
    }
    else if (mod == "MOD_PROJECTILE" || mod == "MOD_EXPLOSIVE" || mod == "MOD_PROJECTILE_SPLASH") {
        if (Isdefined(player) && IsAlive(player)) {
            self DoDamage(level.round_number * SRandomIntRange("zm_spawner_zombie_damage", 0, 100), self.origin, player, self, hit_location, mod, 0, weapon);
        }
        else {
            self DoDamage(level.round_number * SRandomIntRange("zm_spawner_zombie_damage", 0, 100), self.origin, undefined, self, hit_location, mod, 0, weapon);
        }
    }
	if (IS_TRUE(self.gibbed)) {
		if (IS_TRUE(self.missinglegs) && IsAlive(self)) {
			if (Isdefined(player)) {
				player zm_audio::create_and_play_dialog("general", "crawl_spawn");
			}
		}
		else if (Isdefined(self.a.gib_ref) && (self.a.gib_ref == "right_arm" || self.a.gib_ref == "left_arm")) {
			if (!self.missinglegs && IsAlive(self)) {
				if (Isdefined(player)) {
					rand = SRandomIntRange("zm_spawner_zombie_damage", 0, 100);
					if (rand < 7) {
						player zm_audio::create_and_play_dialog("general", "shoot_arm");
					}
				}
			}
		}
	}
	self thread zm_powerups::check_for_instakill(player, mod, hit_location);
}

detour zm_spawner<scripts\zm\_zm_spawner.gsc>::zombie_pathing()
{
	self endon("death");
	self endon("zombie_acquire_enemy");
	level endon("intermission");
	self._skip_pathing_first_delay = 1;
	self thread zm_spawner::zombie_follow_enemy();
	self waittill("bad_path");
	level.zombie_pathing_failed++;
	if (Isdefined(self.enemyoverride)) {
		zm_utility::debug_print(("Zombie couldn't path to point of interest at origin: " + self.enemyoverride[0]) + " Falling back to breadcrumb system");
		if (Isdefined(self.enemyoverride[1])) {
			self.enemyoverride = self.enemyoverride[1] zm_utility::invalidate_attractor_pos(self.enemyoverride, self);
			self.zombie_path_timer = 0;
			return;
		}
	}
	else {
		if (Isdefined(self.favoriteenemy)) {
			zm_utility::debug_print(("Zombie couldn't path to player at origin: " + self.favoriteenemy.origin) + " Falling back to breadcrumb system");
		}
		else {
			zm_utility::debug_print("Zombie couldn't path to a player (the other 'prefered' player might be ignored for encounters mode). Falling back to breadcrumb system");
		}
	}
	if (!Isdefined(self.favoriteenemy)) {
		self.zombie_path_timer = 0;
		return;
	}
	self.favoriteenemy endon("disconnect");
	players = GetPlayers();
	valid_player_num = 0;
	for (i = 0; i < players.size; i++) {
		if (zm_utility::is_player_valid(players[i], 1)) {
			valid_player_num = valid_player_num + 1;
		}
	}
	if (players.size > 1) {
		if (Isdefined(level._should_skip_ignore_player_logic) && [[level._should_skip_ignore_player_logic]]()) {
			self.zombie_path_timer = 0;
			return;
		}
		if (!IsInArray(self.ignore_player, self.favoriteenemy)) {
			self.ignore_player[self.ignore_player.size] = self.favoriteenemy;
		}
		if (self.ignore_player.size < valid_player_num) {
			self.zombie_path_timer = 0;
			return;
		}
	}
	crumb_list = self.favoriteenemy.zombie_breadcrumbs;
	bad_crumbs = [];
	for (;;) {
		if (!zm_utility::is_player_valid(self.favoriteenemy, 1)) {
			self.zombie_path_timer = 0;
			return;
		}
		goal = zm_spawner::zombie_pathing_get_breadcrumb(self.favoriteenemy.origin, crumb_list, bad_crumbs, SRandomInt("zm_spawner_pathing", 100) < 20);
		if (!Isdefined(goal)) {
			zm_utility::debug_print("Zombie exhausted breadcrumb search");
			level.zombie_breadcrumb_failed++;
			goal = self.favoriteenemy.spectator_respawn.origin;
		}
		zm_utility::debug_print("Setting current breadcrumb to " + goal);
		self.zombie_path_timer = self.zombie_path_timer + 100;
		self SetGoal(goal);
		self waittill("bad_path");
		zm_utility::debug_print(("Zombie couldn't path to breadcrumb at " + goal) + " Finding next breadcrumb");
		for (i = 0; i < crumb_list.size; i++) {
			if (goal == crumb_list[i]) {
				bad_crumbs[bad_crumbs.size] = i;
				break;
			}
		}
	}
}

detour zm_spawner<scripts\zm\_zm_spawner.gsc>::zombie_pathing_get_breadcrumb(origin, breadcrumbs, bad_crumbs, pick_random)
{
	for (i = 0; i < breadcrumbs.size; i++) {
		if (pick_random) {
			crumb_index = SRandomInt("zm_spawner_breadcrumb", breadcrumbs.size);
		}
		else {
			crumb_index = i;
		}
		if (zm_spawner::crumb_is_bad(crumb_index, bad_crumbs)) {
			continue;
		}
		return breadcrumbs[crumb_index];
	}
	return undefined;
}

detour zm_spawner<scripts\zm\_zm_spawner.gsc>::zombie_follow_enemy()
{
	self endon("death");
	self endon("zombie_acquire_enemy");
	self endon("bad_path");
	level endon("intermission");
	if (!Isdefined(level.repathnotifierstarted)) {
		level.repathnotifierstarted = 1;
		level thread zm_spawner::zombie_repath_notifier();
	}
	if (!Isdefined(self.zombie_repath_notify)) {
		self.zombie_repath_notify = "zombie_repath_notify_" + (self GetEntityNumber() % 4);
	}
	for (;;) {
		if (!Isdefined(self._skip_pathing_first_delay)) {
			level waittill(self.zombie_repath_notify);
		}
		else {
			self._skip_pathing_first_delay = undefined;
		}
		if (!IS_TRUE(self.ignore_enemyoverride) && Isdefined(self.enemyoverride) && Isdefined(self.enemyoverride[1])) {
			if (DistanceSquared(self.origin, self.enemyoverride[0]) > 1) {
				self OrientMode("face motion");
			}
			else {
				self OrientMode("face point", self.enemyoverride[1].origin);
			}
			self.ignoreall = 1;
			goalpos = self.enemyoverride[0];
			if (Isdefined(level.adjust_enemyoverride_func)) {
				goalpos = self [[level.adjust_enemyoverride_func]]();
			}
			self SetGoal(goalpos);
		}
		else if (Isdefined(self.favoriteenemy)) {
			self.ignoreall = 0;
			if (Isdefined(level.enemy_location_override_func)) {
				goalpos = [[level.enemy_location_override_func]](self, self.favoriteenemy);
				if (Isdefined(goalpos)) {
					self SetGoal(goalpos);
				}
				else {
					self zm_behavior::zombieupdategoal();
				}
			}
			else {
				if (IS_TRUE(self.is_rat_test)) {

				}
				else if (zm_behavior::zombieshouldmoveawaycondition(self)) {
					wait 0.05;
					continue;
				}
				else if (Isdefined(self.favoriteenemy.last_valid_position)) {
					self SetGoal(self.favoriteenemy.last_valid_position);
				}
			}
			if (!Isdefined(level.ignore_path_delays)) {
				distsq = DistanceSquared(self.origin, self.favoriteenemy.origin);
				if (distsq > 10240000) {
					wait 2 + SRandomFloat("zm_spawner_follow_enemy", 1);
				}
				else if (distsq > 4840000) {
					wait 1 + SRandomFloat("zm_spawner_follow_enemy", 0.5);
				}
				else if (distsq > 1440000) {
					wait 0.5 + SRandomFloat("zm_spawner_follow_enemy", 0.5);
				}
			}
		}
		if (Isdefined(level.inaccesible_player_func)) {
			self [[level.inaccessible_player_func]]();
		}
	}
}

detour zm_spawner<scripts\zm\_zm_spawner.gsc>::damage_on_fire(player)
{
	self endon("death");
	self endon("stop_flame_damage");
	wait 2;
	while (IS_TRUE(self.is_on_fire)) {
		if (level.round_number < 6) {
			dmg = level.zombie_health * SRandomFloatRange("zm_spawner_fire_damage", 0.2, 0.3);
		}
		else if (level.round_number < 9) {
			dmg = level.zombie_health * SRandomFloatRange("zm_spawner_fire_damage", 0.15, 0.25);
		}
		else if (level.round_number < 11) {
			dmg = level.zombie_health * SRandomFloatRange("zm_spawner_fire_damage", 0.1, 0.2);
		}
		else {
			dmg = level.zombie_health * SRandomFloatRange("zm_spawner_fire_damage", 0.1, 0.15);
		}
		if (Isdefined(player) && isalive(player)) {
			self DoDamage(dmg, self.origin, player);
		}
		else {
			self DoDamage(dmg, self.origin, level);
		}
		wait SRandomFloatRange("zm_spawner_fire_damage", 1, 3);
	}
}

detour zm_spawner<scripts\zm\_zm_spawner.gsc>::do_zombie_spawn()
{
	self endon("death");
	spots = [];
	if (Isdefined(self._rise_spot)) {
		spot = self._rise_spot;
		self thread zm_spawner::do_zombie_rise(spot);
		return;
	}
	if (IS_TRUE(level.use_multiple_spawns) && Isdefined(self.script_int)) {
		foreach (loc in level.zm_loc_types["zombie_location"]) {
			if (!(IsDefined(level.spawner_int) && (level.spawner_int == self.script_int)) && !(IsDefined(loc.script_int) || IsDefined(level.zones[loc.zone_name].script_int))) {
				continue;
			}
			if (Isdefined(loc.script_int) && loc.script_int != self.script_int) {
				continue;
			}
			else if (Isdefined(level.zones[loc.zone_name].script_int) && level.zones[loc.zone_name].script_int != self.script_int) {
				continue;
			}
			spots[spots.size] = loc;
		}
	}
	else {
		spots = level.zm_loc_types["zombie_location"];
	}
	if (GetDvarInt("scr_zombie_spawn_in_view")) {
		player = GetPlayers()[0];
		spots = [];
		max_dot = 0;
		look_loc = undefined;
		foreach (loc in level.zm_loc_types["zombie_location"]) {
			player_vec = VectorNormalize(AnglesToForward(player GetPlayerAngles()));
			player_vec_2d = (player_vec[0], player_vec[1], 0);
			player_spawn = VectorNormalize(loc.origin - player.origin);
			player_spawn_2d = (player_spawn[0], player_spawn[1], 0);
			dot = VectorDot(player_vec_2d, player_spawn_2d);
			dist = Distance(loc.origin, player.origin);
			if (dot > 0.707 && dist <= GetDvarInt("scr_zombie_spawn_in_view_dist")) {
				if (dot > max_dot) {
					look_loc = loc;
					max_dot = dot;
				}
			}
		}
		if (Isdefined(look_loc)) {
			spots[spots.size] = look_loc;
		}
		if (spots.size <= 0) {
			spots[spots.size] = level.zm_loc_types["zombie_location"][0];
		}
	}
	if (Isdefined(level.zm_custom_spawn_location_selection)) {
		spot = [[level.zm_custom_spawn_location_selection]](spots);
	}
	else {
		spot = SArrayRandom(spots, "zm_spawner_spawn_location");
	}
	self.spawn_point = spot;
	self thread [[level.move_spawn_func]](spot);
}