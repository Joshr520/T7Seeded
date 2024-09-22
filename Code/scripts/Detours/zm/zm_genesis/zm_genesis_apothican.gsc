detour zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_e550951a()
{
	for (;;) {
		n_delay = SRandomFloatRange("zm_genesis_apothican_margwa_spawn", 360, 480);
		[[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_9ccb8410]](n_delay);
		[[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_ecd2e6b5]]();
		while (![[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_a6e114bc]](self)) {
			wait 1;
		}
		s_spawn = level.var_1a7635e1[SRandomInt("zm_genesis_apothican_margwa_spawn", level.var_1a7635e1.size)];
		s_spawn thread function_fd1e5c6c();
	}
}

detour zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_cc6165b0(str_type = "random", var_6ac86802 = 0)
{
	return function_cc6165b0(str_type, var_6ac86802);
}

function_cc6165b0(str_type = "random", var_6ac86802 = 0)
{
	if (str_type == "random") {
		var_c624cf3b = SRandomInt("zm_genesis_apothican_margwa_type", 100);
		if (var_c624cf3b < 50) {
			str_type = "plain";
		}
		else if (var_c624cf3b < 75) {
            str_type = "fire";
        }
        else {
            str_type = "shadow";
        }
	}
	switch (str_type) {
		case "fire": {
			var_225347e1 = level thread [[@zm_ai_margwa_elemental<scripts\zm\_zm_ai_margwa_elemental.gsc>::function_75b161ab]](undefined, self);
			break;
		}
		case "shadow": {
			var_225347e1 = level thread [[@zm_ai_margwa_elemental<scripts\zm\_zm_ai_margwa_elemental.gsc>::function_26efbc37]](undefined, self);
			break;
		}
		default: {
			var_225347e1 = level thread [[@zm_ai_margwa<scripts\zm\_zm_ai_margwa_no_idgun.gsc>::function_8a0708c2]](self);
		}
	}
	if (IsDefined(var_225347e1)) {
		var_225347e1.var_9f6fbb95 = 1;
		level.var_2306bf38++;
		level.var_71630d50++;
		if (var_6ac86802) {
			var_225347e1.var_6ac86802 = var_6ac86802;
			level.var_c15eb311++;
		}
	}
}

detour zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_2b03ee2a(e_player)
{
	return function_2b03ee2a(e_player);
}

function_2b03ee2a(e_player)
{
	queryresult = PositionQuery_Source_Navigation(e_player.origin + (0, 0, SRandomIntRange("zm_genesis_apothican_swarm_spawn", 40, 100)), 300, 600, 10, 10, "navvolume_small");
	a_points = SArrayRandomize(queryresult.data, "zm_genesis_apothican_swarm_spawn");
	foreach (point in a_points) {
		if (BulletTracePassed(point.origin, e_player.origin, 0, e_player)) {
			return point;
		}
	}
	return a_points[0];
}

detour zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_a2a299a1()
{
	level.var_a3ad836b = 8;
	level flag::wait_till_all(array("power_on1", "power_on2", "power_on3", "power_on4"));
	[[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_9ccb8410]](120);
	level.var_3013498 = level.round_number + 2;
	for (;;) {
		level waittill("between_round_over");
		var_8a82d706 = 0;
		if (level.var_3013498 <= level.round_number) {
			if (level.var_b8b48a73.size > 0) {
				level.var_adca2f3c = 1;
				var_8a82d706 = 1;
				[[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_bd0872bb]](60);
			}
		}
		if (var_8a82d706) {
			level waittill("end_of_round");
			level.var_3013498 = level.round_number + SRandomIntRange("zm_genesis_apothican_spider_round", 4, 6);
		}
	}
}

detour zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_411feb6a()
{
	[[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_9ccb8410]](10);
	s_center = struct::get("apothicon_center", "targetname");
	b_first_time = 1;
	for (;;) {
		if (b_first_time == 1) {
			n_delay = 60;
			b_first_time = 0;
		}
		else {
			n_delay = SRandomIntRange("zm_genesis_apothican_gas", 150, 210);
		}
		[[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_9ccb8410]](n_delay);
		level.var_a5d2ba4 = 1;
		foreach (player in level.var_b8b48a73) {
			player PlayRumbleOnEntity("zm_genesis_apothicon_gas");
			Earthquake(0.7, 3, s_center.origin, 2000);
			PlaySoundAtPosition("evt_belly_digest", (0, 0, 0));
		}
		level clientfield::set("gas_fog_bank_switch", 1);
		exploder::exploder("fxexp_106");
		wait 155;
		exploder::stop_exploder("fxexp_106");
		level clientfield::set("gas_fog_bank_switch", 0);
		level.var_a5d2ba4 = 0;
	}
}

detour zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_3298b25f(s_stub)
{
	self endon("death");
	a_s_spots = struct::get_array(("apothican_exit_" + s_stub.name) + "_pos", "targetname");
	var_a05a47c7 = s_stub [[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_fbd80603]](self);
	while (PositionWouldTelefrag(var_a05a47c7.origin)) {
		util::wait_network_frame();
		var_a05a47c7 = SArrayRandom(a_s_spots, "zm_genesis_apothican_leave");
	}
	self Unlink();
	self SetOrigin(var_a05a47c7.origin);
	self SetPlayerAngles(var_a05a47c7.angles);
	self clientfield::increment_to_player("flinger_land_smash");
}

detour zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_21a5cf5e()
{
	level flag::wait_till_all(array("power_on1", "power_on2", "power_on3", "power_on4"));
	[[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_9ccb8410]](30);
	level.var_973d41cb = 0;
	for (;;) {
		var_22c7539e = [[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_1affd18d]]();
		if (level.var_973d41cb < var_22c7539e) {
			e_player = [[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_551d8f75]]();
			if (IsDefined(e_player)) {
				spawn_point = function_2b03ee2a(e_player);
				if (IsDefined(spawn_point)) {
					v_spawn_origin = spawn_point.origin;
					v_ground = BulletTrace(spawn_point.origin + VectorScale((0, 0, 1), 40), (spawn_point.origin + VectorScale((0, 0, 1), 40)) + (VectorScale((0, 0, -1), 100000)), 0, undefined)["position"];
					if (DistanceSquared(v_ground, spawn_point.origin) < 1600) {
						v_spawn_origin = v_ground + VectorScale((0, 0, 1), 40);
					}
					queryresult = PositionQuery_Source_Navigation(v_spawn_origin, 0, 80, 80, 15, "navvolume_small");
					a_points = SArrayRandomize(queryresult.data, "zm_genesis_apothican_wasp");
					a_spawn_origins = [];
					n_points_found = 0;
					foreach (point in a_points) {
						str_zone = zm_zonemgr::get_zone_from_position(point.origin, 1);
						if (IsDefined(str_zone) && str_zone == "apothicon_interior_zone") {
							if (BulletTracePassed(point.origin, spawn_point.origin, 0, e_player)) {
								if (!IsDefined(a_spawn_origins)) {
									a_spawn_origins = [];
								}
								else if (!IsArray(a_spawn_origins)) {
									a_spawn_origins = array(a_spawn_origins);
								}
								a_spawn_origins[a_spawn_origins.size] = point.origin;
								n_points_found++;
								if (n_points_found >= 1) {
									break;
								}
							}
						}
					}
					if (a_spawn_origins.size >= 1) {
						n_spawn = 0;
						while (n_spawn < 1) {
							for (i = a_spawn_origins.size - 1; i >= 0; i--) {
								v_origin = a_spawn_origins[i];
								level.var_c200ab6[0].origin = v_origin;
								ai = zombie_utility::spawn_zombie(level.var_c200ab6[0]);
								if (IsDefined(ai)) {
									ai [[@parasite<scripts\shared\vehicles\_parasite.gsc>::set_parasite_enemy]](e_player);
									level thread [[@zm_genesis_wasp<scripts\zm\zm_genesis_wasp.gsc>::wasp_spawn_init]](ai, v_origin);
									ArrayRemoveIndex(a_spawn_origins, i);
									ai.ignore_enemy_count = 1;
									ai.var_95494717 = 1;
									ai.no_damage_points = 1;
									ai.deathpoints_already_given = 1;
									ai thread [[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_e45363e3]]();
									if (IsDefined(level.zm_wasp_spawn_callback)) {
										ai thread [[level.zm_wasp_spawn_callback]]();
									}
									level.var_973d41cb++;
									[[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_9ccb8410]](50);
									n_spawn++;
									wait SRandomFloatRange("zm_genesis_apothican_wasp", 0.06666666, 0.1333333);
									break;
								}
								wait SRandomFloatRange("zm_genesis_apothican_wasp", 0.06666666, 0.1333333);
							}
						}
						b_swarm_spawned = 1;
					}
					util::wait_network_frame();
				}
			}
		}
		util::wait_network_frame();
	}
}

detour zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_2af9e8f2()
{
	level flag::wait_till("book_placed");
	var_9c840b49 = struct::get_array("gateworm_egg", "targetname");
	var_9c840b49 = SArrayRandomize(var_9c840b49, "zm_genesis_apothican_eggs");
	level.var_393eea44 = [];
	foreach (var_21e43ff6 in var_9c840b49) {
		if (!IsDefined(level.var_393eea44[var_21e43ff6.script_int])) {
			level.var_393eea44[var_21e43ff6.script_int] = var_21e43ff6;
			var_21e43ff6.var_89bdf56b = var_21e43ff6.origin;
			var_21e43ff6.var_c1c6575b = var_21e43ff6.origin + VectorScale((0, 0, 1), 1000);
			var_21e43ff6 thread [[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_79912fdc]]();
		}
	}
}

detour zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_fd1e5c6c()
{
	return function_fd1e5c6c();
}

function_fd1e5c6c()
{
	[[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_49a0c182]]();
	switch (level.var_71630d50) {
		case 0: {
			self thread function_cc6165b0();
			break;
		}
		case 1: {
			if (level flag::get("apothican_random_boss_first_session_completed")) {
				if (SCoinToss("zm_genesis_apothican_margwa_element")) {
					self thread function_cc6165b0();
				}
				else {
					self thread [[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_57f2485e]]();
				}
			}
			else {
				self thread function_cc6165b0();
			}
			break;
		}
		default: {
			if (level.var_89b9d07e == 0) {
				self thread [[@zm_genesis_apothican<scripts\zm\zm_genesis_apothican.gsc>::function_57f2485e]]();
			}
			else {
				self thread function_cc6165b0();
			}
			break;
		}
	}
}