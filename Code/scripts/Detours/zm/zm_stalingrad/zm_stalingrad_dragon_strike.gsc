detour namespace_19e79ea1<scripts\zm\zm_stalingrad_dragon_strike.gsc>::function_5cb61169()
{
	level flag::wait_till("all_players_connected");
	var_47295c1 = GetEntArray("dragonstrike_ee_banner", "targetname");
	level.var_65d93bca = level.players.size;
	var_47295c1 = SArrayRandomize(var_47295c1, "zm_stalingrad_dragon_strike_banner");
	for (i = level.var_65d93bca; i < var_47295c1.size; i++) {
		var_47295c1[i] Delete();
	}
	var_47295c1 = array::remove_undefined(var_47295c1, 0);
	array::thread_all(var_47295c1, @namespace_19e79ea1<scripts\zm\zm_stalingrad_dragon_strike.gsc>::function_75a7ba2d);
}