note
	description: "Eiffel class note field name and text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 16:36:31 GMT (Thursday 12th October 2017)"
	revision: "1"

class
	NOTE_FIELD

inherit
	NOTE_CONSTANTS

	EL_STRING_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make (a_name: like name; a_text: like text)
		do
			name := a_name; text := a_text
		end

feature -- Access

	lines: EL_ZSTRING_LIST
		do
			create Result.make (1)
			Result.extend (Field_line_template #$ [name, text])
		end

	name: STRING

	text: ZSTRING

feature -- Element change

	set_text (a_text: like text)
		do
			text := a_text
		end

feature {NONE} -- Constants

	Field_line_template: ZSTRING
		once
			Result := "%S: %"%S%""
		end

end
