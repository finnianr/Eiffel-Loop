note
	description: "Verbatim note field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-10-05 10:01:52 GMT (Saturday 5th October 2024)"
	revision: "5"

class
	VERBATIM_NOTE_FIELD

inherit
	NOTE_FIELD
		rename
			make as make_field
		redefine
			lines
		end

create
	make

feature {NONE} -- Initialization

	make (a_name: IMMUTABLE_STRING_8)
		do
			make_field (a_name, create {like text}.make_empty)
		end

feature -- Access

	lines: EL_ZSTRING_LIST
		do
			create Result.make (text.occurrences ('%N') + 3)
			Result.extend (Verbatim_field #$ [name])
			across text.split ('%N') as split loop
				Result.extend (split.item_copy)
			end
			Result.extend (Verbatim_string_end.twin)
		end

feature -- Element change

	append_text (str: ZSTRING)
		do
			if not text.is_empty then
				text.append_character ('%N')
			end
			text.append (str)
		end

feature {NONE} -- Constants

	Verbatim_field: ZSTRING
		once
			Result := "%S: %"["
		end

end