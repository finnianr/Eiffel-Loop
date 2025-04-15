note
	description: "${EL_PARSER} implemented for source text conforming to {ZSTRING}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 12:24:23 GMT (Tuesday 15th April 2025)"
	revision: "1"

deferred class
	EL_ZSTRING_PARSER

inherit
	EL_PARSER
		redefine
			default_source_text
		end

feature {NONE} -- Implementation

	default_source_text: ZSTRING
		do
			Result := Empty_string
		end

end