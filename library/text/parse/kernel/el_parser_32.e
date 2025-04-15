note
	description: "${EL_PARSER} implemented for source text conforming to {STRING_32}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 15:13:28 GMT (Tuesday 15th April 2025)"
	revision: "1"

deferred class
	EL_PARSER_32

inherit
	EL_PARSER
		redefine
			default_source_text
		end

	EL_STRING_32_CONSTANTS

feature {NONE} -- Implementation

	default_source_text: STRING_32
		do
			Result := Empty_string_32
		end

end