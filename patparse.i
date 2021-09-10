function pattern_parser (
	var     pattern             : tpar_object;
	var     nfa_table           : nfa_table_type;
	var     first_pattern_start,
		pattern_final_state,
		left_context_end,
		middle_context_end  : nfa_state_range;
	var     pattern_definition  : pattern_def_type;
	var     states_used         : nfa_state_range)
	: boolean;
