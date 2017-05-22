note
	description: "Summary description for {EL_PROCEDURE_TABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_PROCEDURE_TABLE

inherit
	EL_HASH_TABLE [PROCEDURE, STRING]

create
	make_equal, make, default_create
end
