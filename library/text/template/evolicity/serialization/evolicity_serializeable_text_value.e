note
	description: "Evolicity serializeable text value"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EVOLICITY_SERIALIZEABLE_TEXT_VALUE

inherit
	EVOLICITY_SERIALIZEABLE
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
			create Result.make (<<
				["text", agent: ZSTRING do Result := text end]
			>>)
		end

feature {NONE} -- Constants

	Template: READABLE_STRING_GENERAL
		once
			Result := "$text"
		end

end