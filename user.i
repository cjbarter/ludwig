function user_key_code_to_name (
		key_code : key_code_range;
	var     key_name : key_name_str)
	: boolean;
function user_key_name_to_code (
		key_name : key_name_str;
	var     key_code : key_code_range)
	: boolean;
procedure user_key_initialize;
function user_command_introducer
	: boolean;
function user_key (
		key   : tpar_object;
		strng : tpar_object)
	: boolean;
function user_parent
	: boolean;
function user_subprocess
	: boolean;
function user_undo
	: boolean;
