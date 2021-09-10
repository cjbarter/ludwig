procedure screen_message (
		message : msg_str);
procedure screen_str_message (
		message : str_object);
procedure screen_unix_message (
		        var     message : str_object)
{#if fpc}
                cdecl
{#endif}
                ;
procedure screen_draw_line (
                line : line_ptr);
procedure screen_redraw;
procedure screen_slide (
		dist : integer);
procedure screen_unload;
procedure screen_scroll (
		count  : integer;
		expand : boolean);
procedure screen_lines_extract (
		first_line : line_ptr;
		last_line  : line_ptr);
procedure screen_lines_inject (
		first_line  : line_ptr;
		count       : line_range;
		before_line : line_ptr);
procedure screen_load (
		line : line_ptr;
		col  : col_range);
procedure screen_position (
		new_line : line_ptr;
		new_col  : col_range);
procedure screen_pause;
procedure screen_clear_msgs (
		pause : boolean);
procedure screen_fixup;
procedure screen_getlinep (
		prompt     : str_object;
		prompt_len : strlen_range;
	var     outbuf     : str_object;
	var     outlen     : strlen_range;
		max_tp,
		this_tp    : tpcount_type);
procedure screen_free_bottom_line;
function screen_verify (
		prompt     : str_object;
		prompt_len : strlen_range)
	: verify_response;
procedure screen_beep;
procedure screen_home (
		clear:boolean);
procedure screen_write_int (
		int   : integer;
		width : scr_col_range);
procedure screen_write_ch (
		indent : scr_col_range;
		ch     : char);
procedure screen_write_str (
		indent : scr_col_range;
		str    : string;
		width  : scr_col_range);
procedure screen_write_name_str (
		indent : scr_col_range;
		str    : name_str;
		width  : scr_col_range);
procedure screen_write_file_name_str (
		indent : scr_col_range;
		str    : file_name_str;
		width  : scr_col_range);
procedure screen_writeln;
procedure screen_writeln_clel;
procedure screen_help_prompt (
		prompt     : write_str;
		prompt_len : strlen_range;
	var     reply      : key_str;
	var     reply_len  : integer);
procedure screen_resize;
