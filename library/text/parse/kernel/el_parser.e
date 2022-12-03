note
	description: "Parses text using text pattern [$source TP_PATTERN]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-03 16:21:45 GMT (Saturday 3rd December 2022)"
	revision: "8"

deferred class
	EL_PARSER

inherit
	TP_FACTORY_SELECTOR
		redefine
			make_default
		end

	EL_STRING_8_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		do
			source_text := default_source_text
			set_optimal_core (source_text)
			internal_pattern := Void
			reset
		end

feature -- Access

	name_list: like pattern.name_list
		do
			Result := pattern.name_list
		end

feature -- Source text substrings

	integer_32_substring (start_index, end_index: INTEGER): INTEGER
		do
			Result := source_substring (start_index, end_index, False).to_integer
		end

	natural_32_substring (start_index, end_index: INTEGER): NATURAL
		do
			Result := source_substring (start_index, end_index, False).to_natural
		end

	real_32_substring, real_substring (start_index, end_index: INTEGER): REAL_32
		do
			Result := source_substring (start_index, end_index, False).to_real_32
		end

	real_64_substring, double_substring (start_index, end_index: INTEGER): REAL_64
		do
			Result := source_substring (start_index, end_index, False).to_real_64
		end

	new_source_substring (start_index, end_index: INTEGER): like default_source_text
		do
			Result := source_text.substring (start_index, end_index)
		end

	source_substring (start_index, end_index: INTEGER; keep_ref: BOOLEAN): like default_source_text
		do
			if keep_ref then
				Result := new_source_substring (start_index, end_index)
			else
				Result := core.copied_substring (source_text, start_index, end_index)
			end
		end

feature -- Element change

	reset
			--
		do
			is_reset := true
			fully_matched := false
		end

	set_source_text (a_source_text: like default_source_text)
			--
		do
--			force refresh of pattern if string type changes
			if not source_text.same_type (a_source_text) then
				reset_pattern
			end
			source_text := a_source_text
			start_offset := 0
 			reset
		end

	set_substring_source_text (a_source_text: like default_source_text; start_index, end_index: INTEGER)
		local
			s_8: EL_STRING_8_ROUTINES; s_32: EL_STRING_32_ROUTINES
			z: EL_ZSTRING_ROUTINES
		do
			if attached {STRING_8} a_source_text as str_8 then
				set_source_text (s_8.shared_substring (str_8, end_index))
				start_offset := start_index - 1

			elseif attached {ZSTRING} a_source_text as z_str then
				set_source_text (z.shared_substring (z_str, end_index))
				start_offset := start_index - 1

			elseif attached {STRING_32} a_source_text as str_32 then
				set_source_text (s_32.shared_substring (str_32, end_index))
				start_offset := start_index - 1

			elseif attached {IMMUTABLE_STRING_8} a_source_text as str_8 then
				set_source_text (str_8.shared_substring (start_index, end_index))

			elseif attached {IMMUTABLE_STRING_32} a_source_text as str_32 then
				set_source_text (str_32.shared_substring (start_index, end_index))
			else
				set_source_text (a_source_text.substring (start_index, end_index))
			end
		ensure
			definition: attached a_source_text.substring (start_index, end_index) as substring
								implies substring.same_string (source_text.substring (start_offset + 1, source_text.count))
		end

feature -- Basic operations

	call_actions
		do
			pattern.call_actions (start_offset + 1, source_text.count)
		end

	find_all (unmatched_action: detachable like pattern.Default_action)
		do
			set_optimal_core (source_text)
			pattern.internal_find_all (0, source_text, unmatched_action)
		end

	match_full
			-- Match pattern against full source_text
		require
			parser_initialized: is_reset
		do
			set_optimal_core (source_text)
			if attached pattern as l_pattern then
				l_pattern.match (start_offset, source_text)
				fully_matched := l_pattern.count = source_text.count - start_offset
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

feature -- Status setting

	set_pattern_changed
			--
		do
			internal_pattern := Void
		end

feature {NONE} -- Implementation

	default_source_text: READABLE_STRING_GENERAL
		do
			Result := Empty_string_8
		end

	new_pattern: TP_PATTERN
			--
		deferred
		end

	pattern: TP_PATTERN
		do
			if attached internal_pattern as p then
				Result := p
			else
				Result := new_pattern
				internal_pattern := Result
			end
		end

	reset_pattern
		do
			internal_pattern := Void
		end

feature {NONE} -- Type definitions

	PARSE_ACTION: PROCEDURE [INTEGER, INTEGER]
		once
			Result := agent (start_index, end_index: INTEGER) do do_nothing end
		end

feature {NONE} -- Internal attributes

	internal_pattern: detachable TP_PATTERN

	frozen source_text: like default_source_text

	start_offset: INTEGER

end