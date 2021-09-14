procedure tpar_clean_object (
	var     tp_o : tpar_object);
procedure tpar_duplicate (
		from_tp : tpar_ptr;
	var     to_tp   : tpar_ptr);
function tpar_to_mark (
	var     strng : tpar_object;
	var     mark  : integer)
	: boolean;
function tpar_to_int (
	var     strng : tpar_object;
	var     chpos,
		int   : integer)
	: boolean;
function tpar_analyse (
		cmd   : user_commands;
	var     tran  : tpar_object;
		depth : integer;
		this_tp : tpcount_type)
	: boolean;
function tpar_get_1 (
		tpar : tpar_ptr;
		cmd  : user_commands;
	var     tran : tpar_object)
	: boolean;
function tpar_get_2 (
		tpar : tpar_ptr;
		cmd  : user_commands;
	var     trn1,
		trn2 : tpar_object)
	: boolean;
