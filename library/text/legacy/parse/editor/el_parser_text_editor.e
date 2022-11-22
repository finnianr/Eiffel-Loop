note
	description: "[
		Text editor that searchs for a grammatical pattern. The pattern event handler is reponsible for
		sending modified text to the output. Unmatched text is automatically sent to output.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-22 7:13:49 GMT (Tuesday 22nd November 2022)"
	revision: "5"

deferred class
	EL_PARSER_TEXT_EDITOR

obsolete "Use EL_PARSER_TEXT_EDITOR from text-process.ecf"

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

	on_unmatched_text (text: EL_STRING_VIEW)
			--
		do
			put_string (text)
		end

	replace (text: EL_STRING_VIEW; new_text: ZSTRING)
			--
		do
			put_string (new_text)
		end

	delete (text: EL_STRING_VIEW)
			--
		do
		end

end