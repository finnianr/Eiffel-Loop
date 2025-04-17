note
	description: "[
		Implementation of ${EL_SPLIT_STRING_32_ON_STRING_CURSOR} optimized for ${ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-16 22:36:42 GMT (Wednesday 16th April 2025)"
	revision: "9"

class
	EL_SPLIT_ZSTRING_ON_STRING_CURSOR

inherit
	EL_SPLIT_STRING_32_ON_STRING_CURSOR [ZSTRING]
		redefine
			is_i_th_white_space
		end

create
	make_adjusted

feature {NONE} -- Implementation

	is_i_th_white_space (a_target: like target; i: INTEGER): BOOLEAN
		do
			Result := a_target.is_space_item (i)
		end

end