note
	description: "Eiffel class note field name and text"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 13:47:17 GMT (Wednesday 17th October 2018)"
	revision: "2"

class
	NOTE_FIELD

inherit
	NOTE_CONSTANTS

	EL_ZSTRING_CONSTANTS

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
