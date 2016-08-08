note
	description: "[
		Eiffel source editor that searchs for grammatical patterns. Defined patterns that match are responsible
		for sending text to output using match event handlers. Unmatched text is automatically sent to output.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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

	EL_EIFFEL_TEXT_PATTERN_FACTORY

feature {NONE} -- Factory

 	new_input_lines (a_file_path: EL_FILE_PATH): EL_FILE_LINE_SOURCE
 		do
 			create Result.make_latin (1, a_file_path)
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
