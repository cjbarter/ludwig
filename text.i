function text_return_col (
		cur_line  : line_ptr;
		cur_col   : col_range;
		splitting : boolean)
	: col_range;
function text_realize_null (
		old_null : line_ptr)
	: boolean;
function text_insert (
		update_screen : boolean;
		count         : integer;
		buf           : str_object;
		buf_len       : strlen_range;
		dst           : mark_ptr)
	: boolean;
function text_overtype (
		update_screen : boolean;
		count         : integer;
		buf           : str_object;
		buf_len       : strlen_range;
	var     dst           : mark_ptr)
	: boolean;
function text_insert_tpar (
		tp          : tpar_object;
		before_mark : mark_ptr;
	var     equals_mark : mark_ptr)
	: boolean;
function text_remove (
		mark_one,
		mark_two : mark_ptr)
	: boolean;
function text_move (
		copy      : boolean;
		count     : integer;
		mark_one  : mark_ptr;
		mark_two  : mark_ptr;
		dst       : mark_ptr;
	var     new_start : mark_ptr;
	var     new_end   : mark_ptr)
	: boolean;
function text_split_line (
		before_mark : mark_ptr;
		new_col     : integer;
	var     equals_mark : mark_ptr)
	: boolean;
