detour zm_castle_characters<scripts\zm\zm_castle_characters.gsc>::initcharacterstartindex()
{
	level.characterstartindex = SRandomInt("character", 4);
}

detour zm_castle_characters<scripts\zm\zm_castle_characters.gsc>::assign_lowest_unused_character_index()
{
	charindexarray = [];
	charindexarray[0] = 0;
	charindexarray[1] = 1;
	charindexarray[2] = 2;
	charindexarray[3] = 3;
	players = GetPlayers();
	if (players.size == 1) {
		charindexarray = SArrayRandomize(charindexarray, "character");
		if (charindexarray[0] == 2) {
			level.has_richtofen = 1;
		}
		return charindexarray[0];
	}
	n_characters_defined = 0;
	foreach (player in players) {
		if (IsDefined(player.characterindex)) {
			arrayremovevalue(charindexarray, player.characterindex, 0);
			n_characters_defined++;
		}
	}
	if (charindexarray.size > 0) {
		if (n_characters_defined == (players.size - 1)) {
			if (!IS_TRUE(level.has_richtofen)) {
				level.has_richtofen = 1;
				return 2;
			}
		}
		charindexarray = SArrayRandomize(charindexarray, "character");
		if (charindexarray[0] == 2) {
			level.has_richtofen = 1;
		}
		return charindexarray[0];
	}
	return 0;
}