note
	description: "Parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-22 7:12:44 GMT (Tuesday 22nd November 2022)"
	revision: "13"

deferred class
	EL_PARSER

obsolete "Use EL_PARSER from text-process.ecf"

inherit
	EL_STRING_8_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		do
			source_view := Default_source_view
			unmatched_action := default_action
			internal_pattern := Void
			reset
		end

feature -- Element change

	reset
			--
		do
			is_reset := true
			fully_matched := false
		end

	set_source_text (a_source_text: READABLE_STRING_GENERAL)
			--
		do
			is_zstring_source := attached {ZSTRING} a_source_text
			source_view := pattern.new_text_view (a_source_text)
 			reset
		end

	set_source_text_from_substring (a_source_text: READABLE_STRING_GENERAL; start_index, end_index: INTEGER)
			--
		do
			set_source_text (a_source_text)
			source_view.prune_leading (start_index - 1)
			source_view.set_count (end_index - start_index + 1)
		end

	set_unmatched_action (a_unmatched_action: like default_action)
		do
			unmatched_action := a_unmatched_action
		end

feature -- Basic operations

	call_actions
		do
			pattern.call_actions (source_view)
		end

	find_all
		do
			pattern.internal_find_all (source_view, unmatched_action)
		end

	match_full
			-- Match pattern against full source_text
		require
			parser_initialized: is_reset
		local
			name_list: like pattern.name_list
			old_count: INTEGER
		do
			if attached pattern as pat then
				name_list := pat.name_list
				old_count := source_view.count
				pat.match (source_view)
				fully_matched := pat.count = old_count
			end
		end

	parse
		do
			match_full
			if fully_matched then
				call_actions
			end
		end

feature -- Status query

	fully_matched: BOOLEAN

	is_reset: BOOLEAN

	is_zstring_source: BOOLEAN

feature -- Status setting

	set_pattern_changed
			--
		do
			internal_pattern := Void
		end

feature {NONE} -- Implementation

	default_action: like pattern.Default_action
		deferred
		end

	new_pattern: EL_TEXT_PATTERN
			--
		deferred
		end

	pattern: EL_TEXT_PATTERN
		do
			if attached internal_pattern as p then
				Result := p
			else
				Result := new_pattern
				internal_pattern := Result
			end
		end

feature {NONE} -- Internal attributes

	internal_pattern: detachable EL_TEXT_PATTERN

	source_view: EL_STRING_VIEW

	unmatched_action: like default_action

feature {NONE} -- Constants

	Default_source_view: EL_STRING_8_VIEW
		once
			create Result.make (Empty_string_8)
		end

end