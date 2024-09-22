detour zm_island_spores<scripts\zm\zm_island_spores.gsc>::function_ba7a3b74(is_enemy, b_hero_weapon, e_attacker)
{
	if (!IsDefined(self.var_d07c64b6)) {
		self.var_d07c64b6 = 0;
	}
	if (is_enemy) {
		self endon("death");
		if (self.targetname === "zombie") {
			if (!self.var_d07c64b6) {
				self.var_d07c64b6 = 1;
				if (b_hero_weapon) {
					self clientfield::set("spore_trail_enemy_fx", 1);
					self thread [[@zm_island_spores<scripts\zm\zm_island_spores.gsc>::function_94e2552f]]();
					wait 10;
					self.var_d07c64b6 = 0;
					self notify(#"hash_ab24308c");
					self clientfield::set("spore_trail_enemy_fx", 0);
				}
				else {
					self clientfield::set("spore_trail_enemy_fx", 2);
					if (SRandomInt("zm_island_spores_spawn_thrasher", 100) < 15 && [[@zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_6d24956b]](self.origin) && [[@zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_cb4aac76]](self) && !IS_TRUE(self.var_cbbe29a9) && level.var_b5799c7c) {
						var_e3372b59 = [[@zm_ai_thrasher<scripts\zm\_zm_ai_thrasher.gsc>::function_8b323113]](self);
					}
					else {
						self.var_317d58a6 = self.zombie_move_speed;
						self zombie_utility::set_zombie_run_cycle("walk");
						wait 10;
						self zombie_utility::set_zombie_run_cycle(self.var_317d58a6);
						self.var_d07c64b6 = 0;
						self clientfield::set("spore_trail_enemy_fx", 0);
					}
				}
			}
		}
		else if (IS_TRUE(self.b_is_spider)) {
            if (level flag::get("spiders_from_mars_round")) {
                return;
            }
            if (!self.var_d07c64b6) {
                self.var_d07c64b6 = 1;
                if (IsDefined(e_attacker)) {
                    e_attacker notify("update_challenge_3_1");
                }
                if (b_hero_weapon) {
                    a_enemies = array::get_all_closest(self.origin, GetAITeamArray("axis"), undefined, undefined, 128);
                    array::run_all(a_enemies, ::DoDamage, 1000, self.origin);
                }
                else {
                    self Kill();
                }
            }
        }
        else if (IS_TRUE(self.var_61f7b3a0)) {
            if (!self.var_d07c64b6) {
                if (b_hero_weapon) {
                    self.var_d07c64b6 = 1;
                    self DoDamage(self.health / 2, self.origin);
                    wait 10;
                    self.var_d07c64b6 = 0;
                }
            }
        }
	}
	else {
		self endon("disconnect");
		if (IsDefined(self.var_59bd3c5a)) {
			self.var_59bd3c5a Kill();
		}
		else if (!self.var_d07c64b6) {
			self.var_d07c64b6 = 1;
			if (self IsPlayerUnderwater()) {
				self thread [[@zm_island_spores<scripts\zm\zm_island_spores.gsc>::function_703ef5e8]]();
				wait 5;
			}
			else if (b_hero_weapon) {
                self clientfield::set("spore_trail_player_fx", 1);
                self clientfield::set_to_player("spore_camera_fx", 1);
                self thread [[@zm_island_spores<scripts\zm\zm_island_spores.gsc>::function_365b46bb]]();
                wait 10;
            }
			else if (self.var_df4182b1) {
                self notify(#"hash_b56a74a8");
                wait 5;
            }
            else {
                self clientfield::set("spore_trail_player_fx", 2);
                self clientfield::set_to_player("spore_camera_fx", 2);
                self thread [[@zm_island_spores<scripts\zm\zm_island_spores.gsc>::function_6cea25bb]]();
                self thread [[@zm_island_spores<scripts\zm\zm_island_spores.gsc>::function_7fa4a0dd]]();
                self thread [[@zm_island_spores<scripts\zm\zm_island_spores.gsc>::function_afacd209]]();
                self notify(#"hash_ece519d9");
                self waittill("coughing_complete");
                wait 1;
            }
			self.var_d07c64b6 = 0;
			self notify(#"hash_dd8e5266");
			self clientfield::set("spore_trail_player_fx", 0);
			self clientfield::set_to_player("spore_camera_fx", 0);
			self clientfield::set_to_player("play_spore_bubbles", 0);
		}
	}
}

detour zm_island_spores<scripts\zm\zm_island_spores.gsc>::function_3dc43cc5()
{
	self endon(#"hash_dcef79ff");
	if (!IsDefined(self.var_4448f463)) {
		self.var_4448f463 = 0;
	}
	self.var_4448f463 = SRandomIntRange("zm_island_spores_grow", 3, 5);
	self.var_f9f788a6 = 0;
	while (self.var_4448f463 > 0) {
		level waittill("end_of_round");
		self.var_4448f463 = self.var_4448f463 - 1;
		if (self.var_4448f463 < 3) {
			self.var_f9f788a6 = self.var_f9f788a6 + 1;
			wait SRandomFloatRange("zm_island_spores_grow", 3.5, 6.5);
			switch (self.var_f9f788a6) {
				case 1: {
					self clientfield::set("spore_grows", 1);
					self thread [[@zm_island_spores<scripts\zm\zm_island_spores.gsc>::function_523b2f00]]();
					break;
				}
				case 2: {
					self clientfield::set("spore_grows", 2);
					break;
				}
				case 3: {
					self clientfield::set("spore_grows", 3);
					self thread [[@zm_island_spores<scripts\zm\zm_island_spores.gsc>::function_15e20abb]]();
					self thread [[@zm_island_spores<scripts\zm\zm_island_spores.gsc>::function_c77e825c]]();
					self clientfield::set("spore_glow_fx", 1);
					break;
				}
			}
		}
	}
}