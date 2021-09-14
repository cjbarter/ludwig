procedure code_discard (
	var     code_head : code_ptr);
function code_compile (
	var     span      : span_object;
		from_span : boolean)
	: boolean;
function code_interpret (
		rept      : leadparam;
		count     : integer;
		code_head : code_ptr;
		from_span : boolean)
	: boolean;
