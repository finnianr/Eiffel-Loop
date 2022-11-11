note
	description: "[
		Eiffel source editor that searchs for grammatical patterns. Defined patterns that match are responsible
		for sending text to output using match event handlers. Unmatched text is automatically sent to output.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-11 16:40:42 GMT (Friday 11th November 2022)"
	revision: "10"

deferred class
	EL_PATTERN_SEARCHING_EIFFEL_SOURCE_EDITOR

inherit
	EL_EIFFEL_SOURCE_EDITOR
		rename
			set_file_path as set_source_path
		undefine
			make_default
		end

	EL_FILE_PARSER_TEXT_EDITOR
		rename
			set_file_path as set_source_path,
			file_path as source_path
		undefine
			is_bom_enabled
		redefine
			make_default, set_source_path, set_source_text
		end

	EL_EIFFEL_TEXT_PATTERN_FACTORY

	EL_MODULE_FILE

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor {EL_FILE_PARSER_TEXT_EDITOR}
			create source_text.make_empty
		end

feature -- Access

	source_text: ZSTRING

feature -- Element Change

  	set_source_path (a_source_path: FILE_PATH)
		do
			source_path := a_source_path
			set_source_text (File.plain_text (a_source_path))
		end

	set_source_text (a_source_text: STRING)
		do
			if a_source_text.starts_with ({UTF_CONVERTER}.Utf_8_bom_to_string_8) then
				create source_text.make_from_utf_8 (a_source_text)
				set_utf_encoding (8)
			else
				create source_text.make_from_general (a_source_text)
				set_latin_encoding (1)
			end
			Precursor (source_text)
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