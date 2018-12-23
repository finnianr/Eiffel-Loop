note
	description: "Verbatim note field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 17:07:10 GMT (Thursday 12th October 2017)"
	revision: "1"

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

	make (a_name: like name)
		do
			make_field (a_name, create {like text}.make_empty)
		end

feature -- Access

	lines: EL_ZSTRING_LIST
		do
			create Result.make (text.occurrences ('%N') + 3)
			Result.extend (name + Colon_space + Verbatim_string_start)
			text.split ('%N').do_all (agent Result.extend)
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

	Colon_space: ZSTRING
		once
			Result := ": "
		end

end
