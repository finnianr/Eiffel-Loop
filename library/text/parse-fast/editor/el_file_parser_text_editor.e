note
	description: "[
		Text editor that searchs for a grammatical pattern. The pattern event handler is reponsible for
		sending modified text to the output. Unmatched text is automatically sent to output.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 6:07:26 GMT (Tuesday 15th November 2022)"
	revision: "2"

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
			new_pattern as delimiting_pattern
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