
note
	description: "Summary description for {EL_CHARACTER_STATE_MACHINE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_CHARACTER_STATE_MACHINE [C]

inherit
	EL_STATE_MACHINE [C]

feature {NONE} -- Implementation

	parse (initial: like state; string: TO_SPECIAL [C])
			--
		local
			sequence: ARRAY [C]
		do
			create sequence.make_from_special (string.area)
			traverse (initial, create {ARRAYED_LIST [C]}.make_from_array (sequence))
		end

end
