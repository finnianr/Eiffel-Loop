note
	description: "[
		Eiffel source editor that searchs for grammatical patterns. Defined patterns that match are responsible
		for sending text to output using match event handlers. Unmatched text is automatically sent to output.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-02 17:23:08 GMT (Saturday 2nd January 2021)"
	revision: "5"

deferred class
	EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR

inherit
	EL_EIFFEL_SOURCE_EDITOR
		undefine
			make_default
		end

	EL_FILE_PARSER_TEXT_EDITOR
		undefine
			is_bom_enabled
		redefine
			new_input_lines
		end

	EL_EIFFEL_ZTEXT_PATTERN_FACTORY

feature {NONE} -- Factory

 	new_input_lines (a_file_path: EL_FILE_PATH): EL_PLAIN_TEXT_LINE_SOURCE
 		do
 			create Result.make (Latin_1, a_file_path)
 		end

feature {NONE} -- Patterns

	delimiting_pattern: EL_TEXT_PATTERN
			--
		local
			extra_search_patterns: ARRAYED_LIST [EL_TEXT_PATTERN]
		do
			create extra_search_patterns.make_from_array (search_patterns.to_array)
			Result := one_of (extra_search_patterns.to_array)
		end

	search_patterns: ARRAYED_LIST [EL_TEXT_PATTERN]
		deferred
		end

	unmatched_identifier_plus_white_space: like all_of
			-- pattern used to skip over identifiers or keywords we are not interested in
		do
			Result := all_of (<<
				identifier, optional (character_literal (':')), white_space
			>>) |to| agent on_unmatched_text
		end
end