note
	description: "[$source STRING_32] implementation of [$source EL_STRING_ESCAPER_IMP [STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 10:37:55 GMT (Thursday 5th January 2023)"
	revision: "15"

class
	EL_STRING_32_ESCAPER_IMP

inherit
	EL_STRING_ESCAPER_IMP [STRING_32]

create
	make

feature -- Access

	empty_buffer: like buffer
		do
			Result := buffer
			Result.wipe_out
		end

feature -- Basic operations

	prepend_character (str: STRING_32; uc: CHARACTER_32)
		do
			str.prepend_character (uc)
		end

end