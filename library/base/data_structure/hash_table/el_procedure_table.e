note
	description: "Table of procedures with latin-1 encoded keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-03 13:49:19 GMT (Friday 3rd March 2023)"
	revision: "7"

class
	EL_PROCEDURE_TABLE [K -> STRING_GENERAL create make end]

inherit
	EL_STRING_HASH_TABLE [PROCEDURE, K]

create
	make_size, make, default_create

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