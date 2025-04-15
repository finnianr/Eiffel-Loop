note
	description: "${EL_PARSER} implemented for source text conforming to {STRING_8}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 15:16:11 GMT (Tuesday 15th April 2025)"
	revision: "1"

deferred class
	EL_PARSER_8

inherit
	EL_PARSER
		redefine
			default_source_text
		end

feature {NONE} -- Implementation

	default_source_text: STRING_8
		do
			Result := Empty_string_8
		end

end