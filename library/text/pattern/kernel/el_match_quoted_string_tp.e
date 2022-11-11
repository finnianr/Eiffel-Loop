note
	description: "Match quoted string with escaping for specified coding language"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-11 9:16:22 GMT (Friday 11th November 2022)"
	revision: "8"

deferred class
	EL_MATCH_QUOTED_STRING_TP

inherit
	EL_TEXT_PATTERN
		redefine
			internal_call_actions, action_count
		end

	EL_TEXT_PATTERN_FACTORY
		export
			{NONE} all
		end

	EL_STRING_32_CONSTANTS

	EL_MODULE_REUSEABLE

feature {NONE} -- Initialization

	make (a_quote: CHARACTER_32; a_unescaped_action: like unescaped_action)
			--
		do
			make_default
			quote := a_quote; unescaped_action := a_unescaped_action
		end

	make_default
		do
			unescaped_string := default_unescaped_string
			set_optimal_core (unescaped_string)
			escape_sequence := new_escape_sequence
		end

feature -- Access

	quote: CHARACTER_32

feature -- Status query

	action_count: INTEGER
		do
			if attached unescaped_action then
				Result := Precursor + 1
			else
				Result := Precursor
			end
		end

feature {NONE} -- Implementation

	internal_call_actions (start_index, end_index: INTEGER; repeated: detachable EL_REPEATED_TEXT_PATTERN)
		do
			Precursor (start_index + 1, end_index - 1, repeated)
			if attached unescaped_action as action then
				if attached repeated as l_repeated then
					l_repeated.extend_quoted (action, unescaped_string)
				else
					action (unescaped_string)
				end
			end
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		--
		local
			offset, text_count, sequence_count: INTEGER; quote_closed, collecting_text: BOOLEAN
			l_quote: CHARACTER_32; escape_pattern: like new_escape_sequence
			buffer: STRING_GENERAL
		do
			text_count := text.count; l_quote := quote; offset := a_offset

			if i_th_is_quote (offset + 1, text, l_quote) then
				escape_pattern := new_escape_sequence
				collecting_text := attached unescaped_action
				Result := Result + 1; offset := offset + 1

				across buffer_scope as scope loop
					buffer := scope.item
					from until offset = text_count or quote_closed loop
						escape_pattern.match (offset, text)
						if escape_pattern.is_matched then
							sequence_count := escape_pattern.count
							if collecting_text then
								buffer.append_code (unescaped_code (text, offset + 1, offset + sequence_count))
							end
							offset := offset + sequence_count; Result := Result + sequence_count

						elseif i_th_is_quote (offset + 1, text, l_quote) then
							quote_closed := True
							Result := Result + 1
						else
							if collecting_text then
								buffer.append_code (i_th_code (offset + 1, text))
							end
							Result := Result + 1; offset := offset + 1
						end
					end
					if quote_closed then
						if collecting_text then
							unescaped_string := buffer.twin
						end
					else
						Result := Match_fail
					end
				end
			else
				Result := Match_fail
			end
		end

feature {NONE} -- Contract Support

	escaped_sequence (text: READABLE_STRING_GENERAL): TUPLE [counted, character_count: INTEGER]
		local
			offset, text_count: INTEGER; escape_pattern: like new_escape_sequence
		do
			create Result
			text_count := text.count
			escape_pattern := new_escape_sequence
			from until offset = text_count loop
				escape_pattern.match (offset, text)
				if escape_pattern.is_matched then
					offset := offset + escape_pattern.count
					Result.character_count := Result.character_count + escape_pattern.count
					Result.counted := Result.counted + 1
				else
					offset := offset + 1
				end
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- `True' if matched pattern meets defintion of `Current' pattern
		local
			unescaped: READABLE_STRING_GENERAL
		do
			if i_th_is_quote (a_offset + 1, text, quote) then
				Result := i_th_is_quote (a_offset + count, text, quote)
				if Result and attached unescaped_action then
					unescaped := text.substring (a_offset + 2, a_offset + count - 1)
					if attached escaped_sequence (unescaped) as sequence then
--						Compare count of characters that are not escaped
						Result := unescaped_string.count - sequence.counted = unescaped.count - sequence.character_count
					end
				end
			end
		end

feature {NONE} -- Implementation

	buffer_scope: EL_BORROWED_STRING_SCOPE [STRING_GENERAL, EL_BORROWED_STRING_CURSOR [STRING_GENERAL]]
		do
			Result := Reuseable.string_32
		end

	default_unescaped_string: STRING_GENERAL
		do
			Result := Empty_string_32
		end

	i_th_code (i: INTEGER_32; text: READABLE_STRING_GENERAL): NATURAL
			-- `True' if i'th character exhibits property
		do
			Result := text [i].natural_32_code
		end

	i_th_is_quote (i: INTEGER_32; text: READABLE_STRING_GENERAL; a_quote: CHARACTER_32): BOOLEAN
			-- `True' if i'th character exhibits property
		do
			Result := text [i] = a_quote
		end

	name_inserts: TUPLE
		do
			Result := [language_name, quote]
		end

feature {NONE} -- Deferred

	language_name: STRING
		deferred
		end

	new_escape_sequence: EL_TEXT_PATTERN
		deferred
		end

	unescaped_code (text: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): NATURAL_32
		deferred
		end

feature {EL_MATCH_QUOTED_STRING_TP} -- Internal attributes

	escape_sequence: like new_escape_sequence

	unescaped_action: detachable PROCEDURE [STRING_GENERAL]

	unescaped_string: STRING_GENERAL

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "quoted %S string (%S)"
		end
end