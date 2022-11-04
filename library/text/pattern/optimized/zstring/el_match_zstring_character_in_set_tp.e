note
	description: "[$source EL_MATCH_CHARACTER_IN_SET_TP] optimized for [$source ZSTRING] source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 16:35:33 GMT (Monday 31st October 2022)"
	revision: "1"

class
	EL_MATCH_ZSTRING_CHARACTER_IN_SET_TP

inherit
	EL_MATCH_CHARACTER_IN_SET_TP
		redefine
			i_th_in_set
		end

create
	make

feature {NONE} -- Implementation

	i_th_in_set (i: INTEGER; text: ZSTRING): BOOLEAN
		-- `True' if i'th character is in `set'
		do
			Result := set.has_z_code (text.z_code (i))
		end

end