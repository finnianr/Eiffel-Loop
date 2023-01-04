note
	description: "String escaper implementation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-04 11:08:42 GMT (Wednesday 4th January 2023)"
	revision: "13"

deferred class
	EL_STRING_ESCAPER_IMP [S -> STRING_GENERAL create make end]

feature {NONE} -- Initialization

	make
		do
			create buffer.make (0)
		end

feature -- Conversion

	to_code (uc: CHARACTER_32): NATURAL
		do
			Result := uc.natural_32_code
		end

feature -- Access

	empty_buffer: like buffer
		deferred
		end

feature -- Status query

	is_escaped (code: NATURAL; table: HASH_TABLE [NATURAL, NATURAL]): BOOLEAN
		do
			Result := table.has_key (code)
		end

feature -- Basic operations

	append_escape_sequence (str: S; escape_code, code: NATURAL; table: HASH_TABLE [NATURAL, NATURAL])
		do
			str.append_code (escape_code)
			str.append_code (table.found_item)
		end

feature {NONE} -- Internal attributes

	buffer: S

end