function charcmd_insert (
		cmd       : commands;
		rept      : leadparam;
		count     : integer;
		from_span : boolean)
	: boolean;
function charcmd_delete (
		cmd       : commands;
		rept      : leadparam;
		count     : integer;
		from_span : boolean)
	: boolean;
function charcmd_rubout (
		cmd       : commands;
		rept      : leadparam;
		count     : integer;
		from_span : boolean)
	: boolean;
