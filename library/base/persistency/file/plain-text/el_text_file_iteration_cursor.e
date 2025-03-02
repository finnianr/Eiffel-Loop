note
	description: "Abstract cursor to iterate lines of a ${EL_PLAIN_TEXT_FILE} file"
	descendants: "[
			EL_TEXT_FILE_ITERATION_CURSOR* [S -> ${STRING_GENERAL}]
				${EL_TEXT_FILE_LINE_CURSOR}
				${EL_TEXT_FILE_DECODED_LINE_CURSOR}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-28 16:32:51 GMT (Friday 28th February 2025)"
	revision: "2"

deferred class
	EL_TEXT_FILE_ITERATION_CURSOR [S -> STRING_GENERAL]

inherit
	ITERATION_CURSOR [S]

feature {NONE} -- Initialization

	make (a_file: EL_PLAIN_TEXT_FILE)
		require
			exists: a_file.exists
			valid_state: a_file.is_open_read or a_file.is_closed
		do
			file := a_file
			if a_file.is_closed then
				a_file.open_read
			end
			forth
		end

feature -- Access

	item: like shared_item
		do
			Result := shared_item.twin
		end

	shared_item: S
		deferred
		end

feature -- Status query

	after: BOOLEAN

feature -- Basic operations

	forth
		do
			file.read_line
			if file.end_of_file then
				after := True
				file.close
			end
		end

feature {NONE} -- Internal attributes

	file: EL_PLAIN_TEXT_FILE
end