note
	description: "Evolicity free text directive"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:01:17 GMT (Tuesday 18th March 2025)"
	revision: "8"

class
	EVC_FREE_TEXT_DIRECTIVE

inherit
	EVC_DIRECTIVE

create
	make

feature {NONE} -- Initialization

	make (a_text: like text)
		do
			text := a_text
		end

feature -- Access

	text: ZSTRING

feature -- Basic operations

	execute (context: EVC_CONTEXT; output: EL_OUTPUT_MEDIUM)
			--
		do
			output.put_string (text)
		end

end