note
	description: "File parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-25 8:10:34 GMT (Sunday 25th August 2024)"
	revision: "6"

deferred class
	EL_FILE_PARSER

inherit
	EL_PARSER
		export
			{NONE} all
			{ANY}	match_full, call_actions, is_reset, fully_matched, set_source_text, set_pattern_changed
		redefine
			make_default, default_source_text
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
			Precursor {EL_PARSER}
		end

feature {NONE} -- Implementation

	default_source_text: ZSTRING
		do
			Result := Empty_string
		end

end