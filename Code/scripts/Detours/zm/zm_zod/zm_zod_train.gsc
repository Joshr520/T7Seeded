detour czmtrain<scripts\zm\zm_zod_train.gsc>::main()
	{
		a_path_names = GetArrayKeys(self.m_a_s_stations);
		a_path_names = SArrayRandomize(a_path_names, "zm_zod_train_init");
		self.m_str_station = a_path_names[0];
		var_97fef807 = self.m_str_station;
		self.m_a_s_stations[self.m_str_station].b_left_path_active = SRandomInt("zm_zod_train_init", 2);
		self.m_str_destination = [[@czmtrain<scripts\zm\zm_zod_train.gsc>::get_current_destination]]();
		self.m_vh_train AttachPath(self.m_a_s_stations[self.m_str_station].start_node);
		b_first_run = 1;
		self thread [[@czmtrain<scripts\zm\zm_zod_train.gsc>::function_876255]]();
		self thread [[@czmtrain<scripts\zm\zm_zod_train.gsc>::watch_players_on_train]]();
		self thread [[@czmtrain<scripts\zm\zm_zod_train.gsc>::function_955e57a7]]();
		wait 1;
		v_front = self.m_vh_train GetTagOrigin("tag_button_front");
		self.m_s_trigger = [[@zm_zod_util<scripts\zm\zm_zod_util.gsc>::spawn_trigger_radius]](v_front, 60, 1);
		self.m_vh_train PlayLoopSound("evt_train_idle_loop", 4);
		[[@czmtrain<scripts\zm\zm_zod_train.gsc>::open_doors]]();
		thread [[@czmtrain<scripts\zm\zm_zod_train.gsc>::run_switch]]();
		for (;;) {
			[[@czmtrain<scripts\zm\zm_zod_train.gsc>::update_use_trigger]]();
			[[@czmtrain<scripts\zm\zm_zod_train.gsc>::enable_train_switches]](1);
			level thread [[@czmtrain<scripts\zm\zm_zod_train.gsc>::function_b0af9dac]]();
			for (;;) {
				self.m_vh_train clientfield::set("train_switch_light", 1);
				self.m_s_trigger waittill("trigger", e_who);
				self.m_vh_train clientfield::set("train_switch_light", 0);
				if (self.m_b_free) {
					self.m_b_free = 0;
					break;
				}
				else if (!e_who zm_score::can_player_purchase(500)) {
                    e_who zm_audio::create_and_play_dialog("general", "transport_deny");
                }
                else {
                    e_who zm_score::minus_to_player_score(500);
                    e_who zm_audio::create_and_play_dialog("train", "start");
                    break;
                }
			}
			level.var_33c4ee76++;
			thread [[@czmtrain<scripts\zm\zm_zod_train.gsc>::function_a377ba46]]();
			wait 0.05;
			self flag::set("moving");
			zm_unitrigger::unregister_unitrigger(self.m_s_trigger);
			self.m_s_trigger = undefined;
			[[@czmtrain<scripts\zm\zm_zod_train.gsc>::close_doors]]();
			self.m_vh_train PlaySound("evt_train_start");
			self.m_vh_train PlayLoopSound("evt_train_loop", 4);
			var_8d722bd4 = [[@czmtrain<scripts\zm\zm_zod_train.gsc>::function_ccd778ab]]();
			if (var_8d722bd4 || b_first_run) {
				self.m_vh_train SetSpeed(32);
			}
			else {
				level.b_host_migration_force_player_respawn = 1;
				thread [[@czmtrain<scripts\zm\zm_zod_train.gsc>::function_a9acf9e2]]();
			}
			[[@czmtrain<scripts\zm\zm_zod_train.gsc>::move]]();
			self.m_vh_train PlayLoopSound("evt_train_idle_loop", 4);
			a_riders = [[@zm_train<scripts\zm\zm_zod_train.gsc>::get_players_on_train]](0);
			if (a_riders.size > 0) {
				level flag::set(self.m_a_s_stations[self.m_str_station].str_zone_flag);
				level flag::set("train_rode_to_" + self.m_str_station);
			}
			if (var_8d722bd4 || b_first_run) {
				self.m_vh_train ResumeSpeed();
			}
			if (b_first_run) {
				b_first_run = 0;
			}
			[[@czmtrain<scripts\zm\zm_zod_train.gsc>::open_doors]]();
			a_riders = [[@zm_train<scripts\zm\zm_zod_train.gsc>::get_players_on_train]](0);
			if (a_riders.size > 0) {
				var_3a349c58 = a_riders[SRandomInt("zm_zod_train_init", a_riders.size)];
				var_3a349c58 zm_audio::create_and_play_dialog("train", "stop");
			}
			v_trig = (0, 0, 0);
			if (!self.m_b_facing_forward) {
				v_trig = self.m_vh_train GetTagOrigin("tag_button_back");
			}
			else {
				v_trig = self.m_vh_train GetTagOrigin("tag_button_front");
			}
			self flag::clear("moving");
			level.b_host_migration_force_player_respawn = 0;
			self [[@czmtrain<scripts\zm\zm_zod_train.gsc>::function_312bb6e1]]();
			if (!self.m_b_free && level.var_33c4ee76 > 0) {
				self flag::set("cooldown");
				[[@czmtrain<scripts\zm\zm_zod_train.gsc>::update_use_trigger]]();
				n_wait = 40;
				wait n_wait;
				self.m_s_trigger = [[@zm_zod_util<scripts\zm\zm_zod_util.gsc>::spawn_trigger_radius]](v_trig, 60, 1);
				self flag::clear("cooldown");
			}
			else {
				self.m_s_trigger = [[@zm_zod_util<scripts\zm\zm_zod_util.gsc>::spawn_trigger_radius]](v_trig, 60, 1);
			}
		}
	}