detour zm_craftables<scripts\zm\_zm_craftables.gsc>::piece_allocate_spawn(piecestub)
{
	self.current_spawn = 0;
	self.managed_spawn = 1;
	self.piecestub = piecestub;
	if (self.spawns.size >= 1 && self.spawns.size > 1) {
		any_good = 0;
		any_okay = 0;
		totalweight = 0;
		spawnweights = [];
		for (i = 0; i < self.spawns.size; i++) {
			if (IsDefined(piecestub.piece_allocated[i]) && piecestub.piece_allocated[i]) {
				spawnweights[i] = 0;
			}
			else if (zm_craftables::is_point_in_craft_trigger(self.spawns[i].origin)) {
                any_okay = 1;
                spawnweights[i] = 0.01;
            }
            else {
                any_good = 1;
                spawnweights[i] = 1;
            }
			totalweight = totalweight + spawnweights[i];
		}
		if (any_good) {
			totalweight = Float(Int(totalweight));
		}
		r = SRandomFloat("zm_craftables_piece_spawn", totalweight);
		for (i = 0; i < self.spawns.size; i++) {
			if (!any_good || spawnweights[i] >= 1) {
				r = r - spawnweights[i];
				if (r < 0) {
					self.current_spawn = i;
					piecestub.piece_allocated[self.current_spawn] = 1;
					return;
				}
			}
		}
		self.current_spawn = SRandomInt("zm_craftables_piece_spawn", self.spawns.size);
		piecestub.piece_allocated[self.current_spawn] = 1;
	}
}