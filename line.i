function line_eop_create (
		inframe : frame_ptr;
	var     group   : group_ptr)
	: boolean;
function line_eop_destroy (
	var     group : group_ptr)
	: boolean;
function lines_create (
		line_count : line_range;
	var     first_line,
		last_line  : line_ptr)
	: boolean;
function lines_destroy (
	var     first_line,
		last_line : line_ptr)
	: boolean;
function lines_inject (
		first_line,
		last_line,
		before_line : line_ptr)
	: boolean;
function lines_extract (
		first_line,
		last_line : line_ptr)
	: boolean;
function line_change_length (
		line       : line_ptr;
		new_length : strlen_range)
	: boolean;
function line_to_number (
		line   : line_ptr;
	var     number : line_range)
	: boolean;
function line_from_number (
		frame  : frame_ptr;
		number : line_range;
	var     line   : line_ptr)
	: boolean;
