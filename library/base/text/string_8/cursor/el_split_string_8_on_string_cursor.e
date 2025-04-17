note
	description: "[
		${EL_SPLIT_ON_STRING_CURSOR} implemented for strings conforming to  ${READABLE_STRING_8}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:33:14 GMT (Wednesday 16th April 2025)"
	revision: "2"

class
	EL_SPLIT_STRING_8_ON_STRING_CURSOR [RSTRING -> READABLE_STRING_8]

inherit
	EL_SPLIT_ON_STRING_CURSOR [RSTRING, CHARACTER_8]
		redefine
			is_i_th_white_space
		end

create
	make_adjusted

feature {NONE} -- Implementation

	is_i_th_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := a_target [i].is_space
		end

	i_th_character (a_target: like target; i: INTEGER): CHARACTER_8
		-- i'th character of `a_target'
		do
			Result := a_target [i]
		end

end