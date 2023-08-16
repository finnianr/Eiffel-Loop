note
	description: "[$source STRING_8] implementation of [$source EL_CSV_ESCAPER_IMP [STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 14:36:38 GMT (Wednesday 2nd August 2023)"
	revision: "3"

class
	EL_CSV_STRING_8_ESCAPER_IMP

inherit
	EL_CSV_ESCAPER_IMP [STRING_8]
		undefine
			bit_count, make, to_code, to_unicode
		end

	EL_STRING_8_ESCAPER_IMP
		undefine
			append_escape_sequence
		end

create
	make
end