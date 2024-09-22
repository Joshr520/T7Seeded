detour zm_zod_sword<scripts\zm\zm_zod_sword_quest.gsc>::function_7922af5f(player, trig_stub, index, str_endon)
{
	level endon(str_endon);
	level endon("magic_circle_failed");
	var_181b74a5 = trig_stub.n_char_index;
	for (;;) {
		var_cf8830de = SArrayRandom(trig_stub.var_2330d68c, "zm_zod_sword_quest_margwa_spawn");
		ArrayRemoveValue(trig_stub.var_2330d68c, var_cf8830de);
		trig_stub.ai_defender[index] = [[@zm_ai_margwa<scripts\zm\_zm_ai_margwa.gsc>::function_8a0708c2]](var_cf8830de);
		trig_stub.ai_defender[index].no_powerups = 1;
		trig_stub.ai_defender[index].var_89905c65 = 1;
		trig_stub.ai_defender[index].deathpoints_already_given = 1;
		trig_stub.ai_defender[index].var_2d5d7413 = 1;
		trig_stub.ai_defender[index].var_de609f65 = player;
		trig_stub.ai_defender[index] waittill("death", attacker, mod, var_13b27531);
		if (IsDefined(var_13b27531 === level.sword_quest.weapons[player.characterindex][1])) {
			player.sword_quest_2.kills[var_181b74a5]++;
			trig_stub.var_87b7360--;
			break;
		}
		else {
			if (!IsDefined(trig_stub.var_2330d68c)) {
				trig_stub.var_2330d68c = [];
			}
			else if (!IsArray(trig_stub.var_2330d68c)) {
				trig_stub.var_2330d68c = array(trig_stub.var_2330d68c);
			}
			trig_stub.var_2330d68c[trig_stub.var_2330d68c.size] = var_cf8830de;
			wait 4 ;
		}
	}
}