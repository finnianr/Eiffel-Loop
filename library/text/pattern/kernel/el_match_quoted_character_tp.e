note
	description: "Match quoted character with escaping for specified coding language"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-13 10:08:37 GMT (Sunday 13th November 2022)"
	revision: "9"

deferred class
	EL_MATCH_QUOTED_CHARACTER_TP

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

	make (a_unescaped_action: like unescaped_action)
			--
		do
			make_default
			unescaped_action := a_unescaped_action
		end

	make_default
		do
			set_optimal_core (default_string)
			escape_sequence := new_escape_sequence
		end

feature -- Access

	language_name: STRING
		deferred
		end

feature -- Measurement

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
		local
			action_twin: PROCEDURE
		do
			Precursor (start_index + 1, end_index - 1, repeated)
			if attached unescaped_action as action then
				if attached repeated as l_repeated then
					action_twin := action.twin
					action_twin.set_operands ([unescaped_character])

					l_repeated.extend (action_twin, 0, 0)
				else
					action (unescaped_character)
				end
			end
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
		--
		local
			offset, text_count, sequence_count: INTEGER;
			quote_closed, collecting_text, escape_sequence_found: BOOLEAN
			escape_pattern: like new_escape_sequence
		do
			text_count := text.count; offset := a_offset

			if i_th_is_single_quote (offset + 1, text) then
				escape_pattern := new_escape_sequence
				collecting_text := attached unescaped_action
				Result := Result + 1; offset := offset + 1

				from until offset = text_count or quote_closed loop
					if text [offset + 1] = escape_character then
						escape_pattern.match (offset, text)
						escape_sequence_found := escape_pattern.is_matched
					else
						escape_sequence_found := False
					end
					if escape_sequence_found then
						sequence_count := escape_pattern.count
						if collecting_text then
							unescaped_character := decoded (text, offset + 1, offset + sequence_count, sequence_count)
						end
						offset := offset + sequence_count; Result := Result + sequence_count

					elseif i_th_is_single_quote (offset + 1, text) then
						quote_closed := True
						Result := Result + 1
					else
						if collecting_text then
							unescaped_character := text [offset + 1]
						end
						Result := Result + 1; offset := offset + 1
					end
				end
				if not quote_closed then
					Result := Match_fail
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
			if i_th_is_single_quote (a_offset + 1, text) then
				Result := i_th_is_single_quote (a_offset + count, text)
				if Result and attached unescaped_action then
					unescaped := text.substring (a_offset + 2, a_offset + count - 1)
					if attached escaped_sequence (unescaped) as sequence then
--						Compare count of characters that are not escaped
						Result := 1 - sequence.counted = unescaped.count - sequence.character_count
					end
				end
			end
		end

feature {NONE} -- Implementation

	default_string: STRING_GENERAL
		do
			Result := Empty_string_32
		end

	i_th_is_single_quote (i: INTEGER_32; text: READABLE_STRING_GENERAL): BOOLEAN
			-- `True' if i'th character exhibits property
		do
			Result := text [i] = '%''
		end

	name_inserts: TUPLE
		do
			Result := [language_name]
		end

feature {NONE} -- Deferred

	escape_character: CHARACTER_32
		deferred
		end

	new_escape_sequence: EL_TEXT_PATTERN
		deferred
		end

	decoded (text: READABLE_STRING_GENERAL; start_index, end_index, sequence_count: INTEGER): CHARACTER_32
		-- decoded escape sequence
		deferred
		end

feature {EL_MATCH_QUOTED_STRING_TP} -- Internal attributes

	escape_sequence: like new_escape_sequence

	unescaped_action: detachable PROCEDURE [CHARACTER_32]

	unescaped_character: CHARACTER_32

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "quoted %S character"
		end
end