function span_find (
		span_name : name_str;
	var     ptr,
		oldp      : span_ptr)
	: boolean;
function span_create (
		span_name : name_str;
		first_mark,
		last_mark : mark_ptr)
	: boolean;
function span_destroy (
	var     span : span_ptr)
	: boolean;
function span_index
	: boolean;
