procedure file_name (
		fp      : file_ptr;
		max_len : integer;
	var     act_fnm : file_name_str;
	var     act_len : integer);
procedure file_table;
procedure file_fix_eop (
		eof      : boolean;
		eop_line : line_ptr);
function file_create_open (
		fn       : file_name_str;
		parse    : parse_type;
	var     inputfp  : file_ptr;
	var     outputfp : file_ptr)
	: boolean;
function file_close_delete (
	var     fp     : file_ptr;
		delete : boolean;
		msgs   : boolean)
	: boolean;
function file_read (
		fp         : file_ptr;
		count      : line_range;
		best_try   : boolean;
	var     first,last : line_ptr;
	var     actual_cnt : integer)
	: boolean;
function file_write (
		first_line,
		last_line : line_ptr;
		fp        : file_ptr)
	: boolean;
function file_windthru (
		current   : frame_ptr;
		from_span : boolean)
	: boolean;
function file_rewind (
	var     fp : file_ptr)
	: boolean;
function file_page (
		current_frame : frame_ptr;
	var     exit_abort    : boolean)
	: boolean;
function file_command (
		command   : commands;
		rept      : leadparam;
		count     : integer;
		tparam    : tpar_ptr;
		from_span : boolean)
	: boolean;
