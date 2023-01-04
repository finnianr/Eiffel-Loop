note
	description: "[$source STRING_32] implementation of [$source XML_ESCAPER_IMP [STRING_GENERAL]]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-04 17:59:14 GMT (Wednesday 4th January 2023)"
	revision: "16"

class
	XML_STRING_32_ESCAPER_IMP

inherit
	XML_ESCAPER_IMP [STRING_32]
		undefine
			make, to_code, to_unicode
		end

	EL_STRING_32_ESCAPER_IMP
		undefine
			append_escape_sequence, is_escaped
		end

create
	make
end