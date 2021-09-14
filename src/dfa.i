function pattern_dfa_table_kill (
	var     pattern_ptr : dfa_table_ptr)
	: boolean;
function pattern_dfa_table_initialize (
	var     pattern_ptr        : dfa_table_ptr;
		pattern_definition : pattern_def_type)
	:  boolean;
function pattern_dfa_convert (
	var     nfa_table            : nfa_table_type;
		dfa_table_pointer    : dfa_table_ptr;
	var     nfa_start,
		nfa_end              : nfa_state_range;
		middle_context_start,
		right_context_start  : nfa_state_range;
	var     dfa_start,
		dfa_end              : dfa_state_range)
	: boolean;
