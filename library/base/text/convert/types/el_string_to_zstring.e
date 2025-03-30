note
	description: "Convert ${READABLE_STRING_GENERAL} to type ${EL_ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-30 13:50:46 GMT (Sunday 30th March 2025)"
	revision: "12"

class
	EL_STRING_TO_ZSTRING

inherit
	EL_TO_STRING_GENERAL_TYPE [ZSTRING]
		redefine
			is_latin_1
		end

	EL_STRING_GENERAL_ROUTINES_I
		rename
			as_zstring as as_type
		export
			{ANY} as_type
		end

create
	make

feature -- Status query

	is_latin_1: BOOLEAN = False
		-- `True' if type can be always be represented by Latin-1 encoded string

feature -- Conversion

	substring_as_type (str: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): ZSTRING
		do
			create Result.make (end_index - start_index + 1)
			Result.append_substring_general (str, start_index, end_index)
		end

end