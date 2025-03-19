note
	description: "Evolicity serializeable text value"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:40 GMT (Tuesday 18th March 2025)"
	revision: "13"

class
	EVC_SERIALIZEABLE_TEXT_VALUE

inherit
	EVC_SERIALIZEABLE
		redefine
			make_default
		end

	EL_ZSTRING_CONSTANTS

create
	make, make_default

feature {NONE} -- Initialization

	make (a_text: ZSTRING)
			--
		do
			make_default
			text := a_text
		end

	make_default
		do
			text := Empty_string
			Precursor
		end

feature -- Access

	text: ZSTRING

feature -- Element change

	set_text (a_text: like text)
		do
			text := a_text
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make_assignments (<<
				["text", agent: ZSTRING do Result := text end]
			>>)
		end

feature {NONE} -- Constants

	Template: READABLE_STRING_GENERAL
		once
			Result := "$text"
		end

end