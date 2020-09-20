note
	description: "Table of procedures with latin-1 encoded keys"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-20 10:44:56 GMT (Sunday 20th September 2020)"
	revision: "5"

class
	EL_PROCEDURE_TABLE [K -> STRING_GENERAL create make end]

inherit
	EL_STRING_HASH_TABLE [PROCEDURE, K]

create
	make_equal, make, default_create

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