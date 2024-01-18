note
	description: "${ZSTRING} implementation of ${XML_ESCAPER_IMP [STRING_GENERAL]}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 14:36:10 GMT (Wednesday 2nd August 2023)"
	revision: "18"

class
	XML_ZSTRING_ESCAPER_IMP

inherit
	XML_ESCAPER_IMP [ZSTRING]
		undefine
			bit_count, make, to_code, to_unicode
		end

	EL_ZSTRING_ESCAPER_IMP
		undefine
			append_escape_sequence, is_escaped
		end

create
	make
end