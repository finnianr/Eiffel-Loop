note
	description: "Parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-01-10 15:05:58 GMT (Sunday 10th January 2021)"
	revision: "10"

deferred class
	EL_PARSER

inherit
	EL_STRING_8_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		do
			source_view := Default_source_view
			unmatched_action := default_action
			set_pattern_changed
			reset
		end

feature -- Element change

	reset
			--
		do
			is_reset := true
			fully_matched := false
			reassign_pattern_if_changed
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
			reassign_pattern_if_changed
			name_list := pattern.name_list
			old_count := source_view.count
			pattern.match (source_view)
			fully_matched := pattern.count = old_count
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

	has_pattern_changed: BOOLEAN

	is_reset: BOOLEAN

	is_zstring_source: BOOLEAN

feature -- Status setting

	set_pattern_changed
			--
		do
			has_pattern_changed := true
		end

feature {NONE} -- Factory

	new_pattern: EL_TEXT_PATTERN
			--
		deferred
		end

feature {NONE} -- Implementation

	default_action: like pattern.Default_action
		deferred
		end

	reassign_pattern_if_changed
			--
		do
			if has_pattern_changed then
				pattern := new_pattern
				has_pattern_changed := false
			end
		end

feature {NONE} -- Internal attributes

	pattern: EL_TEXT_PATTERN

	source_view: EL_STRING_VIEW

	unmatched_action: like default_action

feature {NONE} -- Constants

	Default_source_view: EL_STRING_8_VIEW
		once
			create Result.make (Empty_string_8)
		end

end