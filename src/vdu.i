procedure vdu_movecurs (
		x,
		y : scr_col_range);

procedure vdu_flush (
		wait : boolean);

procedure vdu_beep;

procedure vdu_cleareol;

procedure vdu_displaystr (
		strlen : scr_col_range;
	 var    str    : char;
		opts   : integer);

procedure vdu_displaych (
		ch : char);

procedure vdu_clearscr;

procedure vdu_cleareos;

procedure vdu_redrawscr;

procedure vdu_scrollup (
		n : integer);

procedure vdu_deletelines (
		n         : integer;
		clear_eos : boolean);

procedure vdu_insertlines (
		n     : integer);

procedure vdu_insertchars (
		n : scr_col_range);

procedure vdu_deletechars (
		n : scr_col_range);

procedure vdu_displaycrlf;

procedure vdu_take_back_key (
		key : key_code_range);

procedure vdu_new_introducer (
		key : key_code_range);

function vdu_get_key
	: key_code_range;

procedure vdu_get_input (
	var     prompt     : str_object;
		prompt_len : strlen_range;
	var     get        : str_object;
		get_len    : strlen_range;
	var     outlen     : strlen_range);

procedure vdu_insert_mode (
		turn_on : boolean);

procedure vdu_get_text (
		str_len : integer;
	var     str     : str_object;
	var     outlen  : strlen_range);

procedure vdu_keyboard_init (
	var     nr_key_names      : key_names_range;
	var     key_name_list_ptr : key_name_array_ptr;
	var     key_introducers   : accept_set_type;
	var     terminal_info     : terminal_info_type);

function vdu_init (
		outbuflen     : integer;
	var     capabilities  : terminal_capabilities;
	var     terminal_info : terminal_info_type;
	var     ctrl_c_flag   : boolean;
	var     winchange_flag: boolean)
	: boolean;

procedure vdu_free;

procedure vdu_get_new_dimensions (
	var     new_x : scr_col_range;
	var     new_y : scr_row_range);
