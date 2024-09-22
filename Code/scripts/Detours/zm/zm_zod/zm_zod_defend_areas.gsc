detour careadefend<scripts\zm\zm_zod_defend_areas.gsc>::get_unused_spawn_point()
{
    a_valid_spawn_points = [];
    b_all_points_used = 0;
    while (!a_valid_spawn_points.size) {
        foreach (s_spawn_point in self.m_e_spawn_points) {
            if (!IsDefined(s_spawn_point.spawned_zombie) || b_all_points_used) {
                s_spawn_point.spawned_zombie = 0;
            }
            if (!s_spawn_point.spawned_zombie) {
                array::add(a_valid_spawn_points, s_spawn_point, 0);
            }
        }
        if (!a_valid_spawn_points.size) {
            b_all_points_used = 1;
        }
    }
    s_spawn_point = SArrayRandom(a_valid_spawn_points, "zm_zod_defend_areas_spawn_location");
    s_spawn_point.spawned_zombie = 1;
    return s_spawn_point;
}

detour careadefend<scripts\zm\zm_zod_defend_areas.gsc>::function_877a7365()
{
    self endon("death");
    for (;;) {
        var_c7ca004c = [];
        foreach (player in level.activeplayers) {
            if (zm_utility::is_player_valid(player) && IS_TRUE(player.is_in_defend_area)) {
                if (!IsDefined(var_c7ca004c)) {
                    var_c7ca004c = [];
                }
                else if (!IsArray(var_c7ca004c)) {
                    var_c7ca004c = array(var_c7ca004c);
                }
                var_c7ca004c[var_c7ca004c.size] = player;
            }
        }
        e_target_player = SArrayRandom(var_c7ca004c, "zm_zod_defend_areas_target");
        while (IsAlive(e_target_player) && !IS_TRUE(e_target_player.beastmode) && !e_target_player laststand::player_is_in_laststand()) {
            self SetGoal(e_target_player);
            self waittill("goal");
        }
        wait(0.1);
    }
}