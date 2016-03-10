note
	description: "Summary description for {EL_STRING_ASSIGN_EDITION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_STRING_ASSIGN_EDITION

inherit
	EL_STRING_INSERT_EDITION
		rename
			insertion as assignment,
			make as make_insertion
		redefine
			apply
		end

create
	make

feature {NONE} -- Initialization

	make (a_caret_position: INTEGER; a_assignment: like assignment)
		do
			make_insertion (a_caret_position, 1 |..| a_assignment.count, a_assignment)
		end

feature -- Basic operations

	apply (target: EL_ASTRING)
		do
			target.wipe_out
			target.append (assignment)
		end

end
