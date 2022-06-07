note
	description: "[
		Descendant of [$source EL_WORK_DISTRIBUTER] specialized for procedures.
		`G' is the target type of the procedures you wish to execute. For an example on how to use see
		[$source WORK_DISTRIBUTER_TEST_APP]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-07 9:56:01 GMT (Tuesday 7th June 2022)"
	revision: "6"

class
	EL_PROCEDURE_DISTRIBUTER [G]

inherit
	EL_WORK_DISTRIBUTER [G, PROCEDURE]

create
	make, make_threads

feature {NONE} -- Implementation

	new_completed (procedure: PROCEDURE): G
		do
			if attached {G} procedure.target as target then
				Result := target
			end
		end
end