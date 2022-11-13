note
	description: "[
		Text editor that searchs for a grammatical pattern. The pattern event handler is reponsible for
		sending modified text to the output. Unmatched text is automatically sent to output.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-11 17:32:15 GMT (Friday 11th November 2022)"
	revision: "1"

deferred class
	EL_PARSER_TEXT_EDITOR

inherit
	EL_TEXT_EDITOR
		redefine
			make_default
		end

	EL_PARSER
		rename
			new_pattern as delimiting_pattern,
			find_all as put_editions
		redefine
			make_default
		end

	EL_TEXT_PATTERN_FACTORY

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_TEXT_EDITOR}
			Precursor {EL_PARSER}
			set_unmatched_action (agent on_unmatched_text)
		end

feature {NONE} -- Implementation

	on_unmatched_text (start_index, end_index: INTEGER)
			--
		do
			put_string (source_text.substring (start_index, end_index))
		end

	replace (start_index, end_index: INTEGER; new_text: ZSTRING)
			--
		do
			put_string (new_text)
		end

	delete (start_index, end_index: INTEGER)
			--
		do
		end

end