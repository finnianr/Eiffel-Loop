note
	description: "[$source ZSTRING] implementation of [$source EL_CSV_ESCAPER_IMP [STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-05 9:49:46 GMT (Thursday 5th January 2023)"
	revision: "1"

class
	EL_CSV_ZSTRING_ESCAPER_IMP

inherit
	EL_CSV_ESCAPER_IMP [ZSTRING]
		undefine
			make, to_code, to_unicode
		end

	EL_ZSTRING_ESCAPER_IMP
		undefine
			append_escape_sequence
		end

create
	make
end