detour zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::spawn_mechz(s_location, flyin = 0)
{
	if (IsDefined(level.mechz_spawners[0])) {
		if (IsDefined(level.var_7f2a926d)) {
			[[level.var_7f2a926d]]();
		}
		level.mechz_spawners[0].script_forcespawn = 1;
		ai = zombie_utility::spawn_zombie(level.mechz_spawners[0], "mechz", s_location);
		if (IsDefined(ai)) {
			ai DisableAimAssist();
			ai thread [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::function_ef1ba7e5]]();
			ai thread [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::function_949a3fdf]]();
			ai.actor_damage_func = @mechzserverutils<scripts\shared\ai\mechz.gsc>::mechzdamagecallback;
			ai.damage_scoring_function = @zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::function_b03abc02;
			ai.mechz_melee_knockdown_function = @zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::function_55483494;
			ai.health = level.mechz_health;
			ai.faceplate_health = level.mechz_faceplate_health;
			ai.powercap_cover_health = level.mechz_powercap_cover_health;
			ai.powercap_health = level.mechz_powercap_health;
			ai.left_knee_armor_health = level.var_2cbc5b59;
			ai.right_knee_armor_health = level.var_2cbc5b59;
			ai.left_shoulder_armor_health = level.var_2cbc5b59;
			ai.right_shoulder_armor_health = level.var_2cbc5b59;
			ai.heroweapon_kill_power = 10;
			e_player = zm_utility::get_closest_player(s_location.origin);
			v_dir = e_player.origin - s_location.origin;
			v_dir = VectorNormalize(v_dir);
			v_angles = VectorToAngles(v_dir);
			var_89f898ad = zm_utility::flat_angle(v_angles);
			s_spawn_location = s_location;
			queryresult = PositionQuery_Source_Navigation(s_spawn_location.origin, 0, 32, 20, 4);
			if (queryresult.data.size) {
				v_ground_position = SArrayRandom(queryresult.data, "zm_ai_mechz_spawn_location").origin;
			}
			if (!IsDefined(v_ground_position)) {
				trace = bullettrace(s_spawn_location.origin, s_spawn_location.origin + (vectorscale((0, 0, -1), 256)), 0, s_location);
				v_ground_position = trace["position"];
			}
			var_1750e965 = v_ground_position;
			if (IsDefined(level.var_e1e49cc1)) {
				ai thread [[level.var_e1e49cc1]]();
			}
			ai forceteleport(var_1750e965, var_89f898ad);
			if (flyin === 1) {
				ai thread [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::function_d07fd448]]();
				ai thread scene::play("cin_zm_castle_mechz_entrance", ai);
				ai thread [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::function_c441eaba]](var_1750e965);
				ai thread [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::function_bbdc1f34]](var_1750e965);
			}
			else {
				if (IsDefined(level.var_7d2a391d)) {
					ai thread [[level.var_7d2a391d]]();
				}
				ai.b_flyin_done = 1;
			}
			ai thread [[@zm_ai_mechz<scripts\zm\_zm_ai_mechz.gsc>::function_bb048b27]]();
			ai.ignore_round_robbin_death = 1;
			return ai;
		}
	}
	return undefined;
}