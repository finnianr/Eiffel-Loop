note
	description: "Apply routine with reference argument"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-14 11:51:48 GMT (Wednesday 14th November 2018)"
	revision: "1"

class
	EL_ROUTINE_REFERENCE_APPLICATOR [G]

inherit
	EL_ROUTINE_APPLICATOR [G]
		redefine
			set_operands
		end

create
	make

feature -- Element change

	set_operands (a_operands: like operands; argument: G)
		do
			a_operands.put_reference (argument, 1)
		end

end
