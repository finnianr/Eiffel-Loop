note
	description: "Table of procedures with latin-1 encoded keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 6:17:47 GMT (Monday 23rd September 2024)"
	revision: "9"

class
	EL_PROCEDURE_TABLE [K -> STRING_GENERAL create make end]

inherit
	EL_STRING_HASH_TABLE [PROCEDURE, K]

create
	default_create, make, make_equal, make_assignments, make_one

feature -- Basic operations

	set_targets (target: ANY)
		local
			i: INTEGER
		do
			from i := 0 until i = content.count loop
				content.item (i).set_target (target)
				i := i + 1
			end
		end
end