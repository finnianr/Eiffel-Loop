note
	description: "[
		Text editor that searchs for a grammatical pattern. The pattern event handler is reponsible for
		sending modified text to the output. Unmatched text is automatically sent to output.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-20 9:37:28 GMT (Wednesday 20th January 2016)"
	revision: "1"

deferred class
	EL_FILE_PARSER_TEXT_EDITOR

inherit
	EL_TEXT_FILE_EDITOR
		redefine
			make_default
		end

	EL_PARSER_TEXT_EDITOR
		redefine
			make_default
		end

	EL_FILE_PARSER
		rename
			set_source_text_from_file as set_file_path,
			source_file_path as file_path,
			new_pattern as delimiting_pattern,
			find_all as put_editions
		undefine
			Default_file_path
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_FILE_PARSER}
			Precursor {EL_PARSER_TEXT_EDITOR}
		end

end
