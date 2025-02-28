note
	description: "[
		Helper class to iterate a ${EL_PLAIN_TEXT_FILE} as decoded ${ZSTRING} lines.
		Use routine ${EL_PLAIN_TEXT_FILE}.decoded.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-28 16:22:01 GMT (Friday 28th February 2025)"
	revision: "1"

class
	EL_DECODED_TEXT_FILE_LINES

inherit
	ITERABLE [ZSTRING]

create
	make

feature {NONE} -- Initialization

	make (a_file: EL_PLAIN_TEXT_FILE)
		do
			file := a_file
		end

feature -- Factory

	new_cursor: EL_TEXT_FILE_DECODED_LINE_CURSOR
		do
			create Result.make (file)
		end

feature {NONE} -- Internal attributes

	file: EL_PLAIN_TEXT_FILE

end