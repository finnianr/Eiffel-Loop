note
	description: "File parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 12:26:08 GMT (Tuesday 15th April 2025)"
	revision: "7"

deferred class
	EL_FILE_PARSER

inherit
	EL_ZSTRING_PARSER
		export
			{NONE} all
			{ANY}	match_full, call_actions, is_reset, fully_matched, set_source_text, set_pattern_changed
		redefine
			make_default
		end

	EL_FILE_SOURCE_TEXT
		rename
			source_text as file_source_text
		undefine
			set_source_text
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_FILE_SOURCE_TEXT}
			Precursor {EL_ZSTRING_PARSER}
		end

end