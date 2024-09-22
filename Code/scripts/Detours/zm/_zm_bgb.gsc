detour bgb<scripts\zm\_zm_bgb.gsc>::function_d51db887()
{
	keys = SArrayRandomize(GetArrayKeys(level.bgb), "bgb_random_bgb");
	for (i = 0; i < keys.size; i++) {
		if (level.bgb[keys[i]].rarity != 1) {
			continue;
		}
		if (level.bgb[keys[i]].dlc_index > 0) {
			continue;
		}
		return keys[i];
	}
}