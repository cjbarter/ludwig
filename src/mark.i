function mark_create (
		in_line : line_ptr;
		column  : col_range;
	var     mark    : mark_ptr)
	: boolean;
function mark_destroy (
	var     mark : mark_ptr)
	: boolean;
function marks_squeeze (
		first_line   : line_ptr;
		first_column : col_range;
		last_line    : line_ptr;
		last_column  : col_range)
	: boolean;
function marks_shift (
		source_line   : line_ptr;
		source_column : col_range;
		width         : col_width_range;
		dest_line     : line_ptr;
		dest_column   : col_range)
	: boolean;
