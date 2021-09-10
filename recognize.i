function pattern_recognize (
		dfa_table_pointer : dfa_table_ptr;
		line              : line_ptr;
		start_col         : col_range;
	var     mark_flag         : boolean;
	var     start_pos         : col_range;
	var     finish_pos        : col_range)
	: boolean;
