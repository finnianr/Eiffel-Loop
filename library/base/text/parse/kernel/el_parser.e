note
	description: "Parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

deferred class
	EL_PARSER

inherit
	EL_STRING_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		do
			source_text := Empty_string_8
			create {EL_STRING_8_VIEW} source_view.make (Empty_string_8)
			unmatched_action := default_action
			set_pattern_changed
			reset
		end

feature -- Access

	source_text: READABLE_STRING_GENERAL

feature -- Element change

	reset
			--
		do
			is_reset := true
			fully_matched := false
			reassign_pattern_if_changed
		end

	set_source_text (a_source_text: like source_text)
			--
		do
			source_text := a_source_text
			source_view := pattern.new_text_view (a_source_text)
 			reset
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
		do
			reassign_pattern_if_changed
			name_list := pattern.name_list
			pattern.match (source_view)
			if pattern.count = source_text.count then
				fully_matched := true
			else
				fully_matched := false
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

	has_pattern_changed: BOOLEAN

	is_reset: BOOLEAN

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

	reassign_pattern_if_changed
			--
		do
			if has_pattern_changed then
				pattern := new_pattern
				has_pattern_changed := false
			end
		end

	default_action: like pattern.Default_action
		deferred
		end

feature {NONE} -- Internal attributes

	unmatched_action: like default_action

	pattern: EL_TEXT_PATTERN

	source_view: EL_STRING_VIEW

end