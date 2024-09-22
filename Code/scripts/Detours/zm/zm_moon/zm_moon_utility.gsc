detour zm_moon_utility<scripts\zm\zm_moon_utility.gsc>::hacker_location_random_init()
{
	hacker_tool_array = [];
	hacker_pos = undefined;
	level.hacker_tool_positions = [];
	hacker = GetEntArray("zombie_equipment_upgrade", "targetname");
	for (i = 0; i < hacker.size; i++) {
		if (IsDefined(hacker[i].zombie_equipment_upgrade) && hacker[i].zombie_equipment_upgrade == "equip_hacker") {
			if (!IsDefined(hacker_tool_array)) {
				hacker_tool_array = [];
			}
			else if (!IsArray(hacker_tool_array)) {
				hacker_tool_array = array(hacker_tool_array);
			}
			hacker_tool_array[hacker_tool_array.size] = hacker[i];
			struct = SpawnStruct();
			struct.trigger_org = hacker[i].origin;
			struct.model_org = GetEnt(hacker[i].target, "targetname").origin;
			struct.model_ang = GetEnt(hacker[i].target, "targetname").angles;
			level.hacker_tool_positions[level.hacker_tool_positions.size] = struct;
		}
	}
	if (hacker_tool_array.size > 1) {
		hacker_pos = hacker_tool_array[SRandomInt("zm_moon_utility_hacker_spawn", hacker_tool_array.size)];
		ArrayRemoveValue(hacker_tool_array, hacker_pos);
		array::thread_all(hacker_tool_array, @zm_moon_utility<scripts\zm\zm_moon_utility.gsc>::hacker_position_cleanup);
	}
}