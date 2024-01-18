note
	description: "${TP_CHARACTER_IN_SET} optimized for ${ZSTRING} source text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:58 GMT (Monday 21st November 2022)"
	revision: "3"

class
	TP_ZSTRING_CHARACTER_IN_SET

inherit
	TP_CHARACTER_IN_SET
		redefine
			i_th_in_set
		end

	TP_OPTIMIZED_FOR_ZSTRING

create
	make

feature {NONE} -- Implementation

	i_th_in_set (i: INTEGER; text: ZSTRING): BOOLEAN
		-- `True' if i'th character is in `set'
		do
			Result := set.has_z_code (text.z_code (i))
		end

end

