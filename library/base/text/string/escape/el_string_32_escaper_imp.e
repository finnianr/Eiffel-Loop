note
	description: "[$source STRING_32] implementation of [$source EL_STRING_ESCAPER_IMP [STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 14:35:54 GMT (Wednesday 2nd August 2023)"
	revision: "17"

class
	EL_STRING_32_ESCAPER_IMP

inherit
	EL_STRING_ESCAPER_IMP [STRING_32]
		undefine
			bit_count
		end

	EL_STRING_32_BIT_COUNTABLE [STRING_32]

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