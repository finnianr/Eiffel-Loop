note
	description: "Summary description for {EL_EIFFEL_SOURCE_EDITING_PROCESSOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-01-19 16:51:32 GMT (Tuesday 19th January 2016)"
	revision: "8"

deferred class
	EIFFEL_SOURCE_EDITING_PROCESSOR

inherit
	EL_FILE_EDITING_PROCESSOR

	EL_EIFFEL_TEXT_PATTERN_FACTORY

feature {NONE} -- Implementation

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
				identifier, optional (character_literal (':')),
				white_space
			>>) |to| agent on_unmatched_text
		end


end
