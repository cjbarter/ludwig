function exec_compute_line_range (
		frame      : frame_ptr;
		rept       : leadparam;
		count      : integer;
	var     first_line : line_ptr;
	var     last_line  : line_ptr)
	: boolean;
function execute (
		command   : commands;
		rept      : leadparam;
		count     : integer;
		tparam    : tpar_ptr;
		from_span : boolean)
	: boolean;
