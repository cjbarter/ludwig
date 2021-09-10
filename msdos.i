function fpc_suspend : boolean;
function fpc_shell : boolean;
procedure msdos_exit (
		status : integer);
function cvt_int_str (
		num   : integer;
	var     strng : str_object;
		width : scr_col_range)
	: boolean;
function cvt_str_int (
	var     num   : integer;
	var     strng : str_object)
	: boolean;
function get_environment (
	var     environ : name_str;
	var     reslen  : strlen_range;
	var     result  : str_object)
	: boolean;
procedure init_signals;
procedure exit_handler (
		sig : integer);
function msdos_suspend
	: boolean;
function msdos_shell
	: boolean;
function msdos_bcmp (
		var     str1, str2      ;
			len             : integer)
		: boolean;
