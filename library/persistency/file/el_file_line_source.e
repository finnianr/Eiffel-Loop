note
	description: "Summary description for {EL_FILE_STRING_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-28 11:32:17 GMT (Sunday 28th July 2013)"
	revision: "3"

class
	EL_FILE_LINE_SOURCE

inherit
	EL_LINE_SOURCE [PLAIN_TEXT_FILE]
		rename
			make as make_from_file,
			source as text_file,
			source_copy as text_file_copy
		export
			{ANY} text_file
		redefine
			default_create
		end

create
	default_create, make, make_from_file

feature {NONE} -- Initialization

	default_create
			--
		do
			Precursor
			create text_file.make_with_name ("any")
		end

	make (a_file_path: EL_FILE_PATH)
		do
			default_create
			create text_file.make_with_name (a_file_path.unicode)
			make_from_file (text_file)
			close_on_after := True
		end

feature -- Access

	byte_count: INTEGER
		do
			Result := text_file.count
		end

	file_path: EL_FILE_PATH
		do
			Result := text_file.path
		end

feature -- Status query

	is_utf8: BOOLEAN
		do
		end

feature -- Status setting

	delete_file
			--
		do
			if text_file.is_open_read then
				text_file.close
			end
			text_file.delete
		end

feature {EL_LINE_SOURCE_ITERATION_CURSOR} -- Implementation

	text_file_copy: PLAIN_TEXT_FILE
		do
			create Result.make_with_path (text_file.path)
		end

end