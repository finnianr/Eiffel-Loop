note
	description: "Summary description for {EL_CHARACTER_STATE_MACHINE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:20:58 GMT (Thursday 12th October 2017)"
	revision: "2"

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