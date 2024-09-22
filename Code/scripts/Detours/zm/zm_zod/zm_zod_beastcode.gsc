detour cbeastcode<scripts\zm\zm_zod_beastcode.gsc>::generate_random_code()
{
    a_n_numbers = array(0, 1, 2, 3, 4, 5, 6, 7, 8);
    a_code = [];
    for (i = 0; i < 3; i++) {
        a_n_numbers = SArrayRandomize(a_n_numbers, "zm_zod_beastcode_order");
        n_number = array::pop_front(a_n_numbers);
        if (!IsDefined(a_code)) {
            a_code = [];
        }
        else if (!IsArray(a_code)) {
            a_code = array(a_code);
        }
        a_code[a_code.size] = n_number;
    }
    return a_code;
}