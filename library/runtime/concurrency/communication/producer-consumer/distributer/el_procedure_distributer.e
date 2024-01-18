note
	description: "[
		Descendant of ${EL_WORK_DISTRIBUTER} specialized for procedures.
		`G' is the target type of the procedures you wish to execute.
	]"
	notes: "[
		For an example on how to use it see class ${NOTE_EDITOR_COMMAND}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "8"

class
	EL_PROCEDURE_DISTRIBUTER [G]

inherit
	EL_WORK_DISTRIBUTER [G, PROCEDURE]
		rename
			valid_routine as valid_procedure
		end

create
	make, make_threads

feature -- Contract Support

	valid_procedure (procedure: PROCEDURE): BOOLEAN
		do
			Result := attached {G} procedure.target as target
		end

feature {NONE} -- Implementation

	new_completed (procedure: PROCEDURE): G
		do
			if attached {G} procedure.target as target then
				Result := target
			end
		end
end