detour zm_temple_traps<scripts\zm\zm_temple_traps.gsc>::pick_random_path_index()
{
	startindex = 0;
	for (i = 0; i < level.mazecells.size; i++) {
		if (level.mazecells[i] == self) {
			startindex = i;
			break;
		}
	}
	path_indexes = [];
	for (i = 0; i < level.mazepaths.size; i++) {
		path_indexes[i] = i;
	}
	path_indexes = SArrayRandomize(path_indexes, "zm_temple_traps_path");
	returnindex = -1;
	for (i = 0; i < path_indexes.size; i++) {
		index = path_indexes[i];
		path = level.mazepaths[index].path;
		if (level.mazepaths[index].loopback) {
			if (level.mazepathcounter < 3) {
				continue;
			}
			if (SRandomFloat("zm_temple_traps_path", 100) > 40) {
				continue;
			}
		}
		if (IsDefined(level.mazepathlaststart) && IsDefined(level.mazepathlastend)) {
			if (level.mazepathlaststart == path[0] && level.mazepathlastend == (path[path.size - 1])) {
				continue;
			}
		}
		if (startindex == path[0]) {
			returnindex = index;
			break;
		}
	}
	return returnindex;
}