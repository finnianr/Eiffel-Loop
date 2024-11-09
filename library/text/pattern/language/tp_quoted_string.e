note
	description: "Match quoted string with escaping for specified coding language"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-08 11:44:05 GMT (Friday 8th November 2024)"
	revision: "7"

deferred class
	TP_QUOTED_STRING

inherit
	TP_PATTERN
		redefine
			internal_call_actions, action_count
		end

	TP_SHARED_OPTIMIZED_FACTORY

	EL_STRING_32_CONSTANTS

	EL_SHARED_STRING_32_BUFFER_POOL

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
			escape_sequence := new_escape_sequence
		end

feature -- Access

	language_name: STRING
		deferred
		end

	quote: CHARACTER_32

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

	internal_call_actions (start_index, end_index: INTEGER; repeated: detachable TP_REPEATED_PATTERN)
		do
			Precursor (start_index, end_index, repeated)
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
			offset, text_count, sequence_count: INTEGER;
			quote_closed, collecting_text, escape_sequence_found: BOOLEAN
			quote_code, escape_code: NATURAL; escape_pattern: like new_escape_sequence
			l_string: STRING_GENERAL
		do
			text_count := text.count; offset := a_offset
			quote_code := as_code (quote); escape_code := as_code (escape_character)

			if i_th_code (offset + 1, text) = quote_code and then attached string_pool.borrowed_item as borrowed then
				escape_pattern := new_escape_sequence
				collecting_text := attached unescaped_action
				offset := offset + 1

				l_string := borrowed.empty
				from until offset = text_count or quote_closed loop
					if i_th_code (offset + 1, text) = escape_code then
						escape_pattern.match (offset, text)
						escape_sequence_found := escape_pattern.is_matched
					else
						escape_sequence_found := False
					end
					if escape_sequence_found then
						sequence_count := escape_pattern.count
						if collecting_text then
							l_string.append_code (unescaped_code (text, offset + 1, offset + sequence_count, sequence_count))
						end
						offset := offset + sequence_count

					elseif i_th_code (offset + 1, text) = quote_code then
						quote_closed := True
						offset := offset + 1
					else
						if collecting_text then
							l_string.append_code (i_th_code (offset + 1, text))
						end
						offset := offset + 1
					end
				end
				if quote_closed then
					if collecting_text then
						unescaped_string := l_string.twin
					end
					Result := offset - a_offset
					if Result <= 2 then
						Result := Match_fail
					end
				else
					Result := Match_fail
				end
				borrowed.return
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
			if i_th_code (a_offset + 1, text) = as_code (quote) then
				Result := i_th_code (a_offset + count, text) = as_code (quote)
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

	as_code (uc: CHARACTER_32): NATURAL
		do
			Result := uc.natural_32_code
		end

	string_pool: EL_STRING_BUFFER_POOL [EL_STRING_BUFFER [STRING_GENERAL, READABLE_STRING_GENERAL]]
		-- string buffer scope
		do
			Result := String_32_pool
		end

	core: TP_OPTIMIZED_FACTORY
		do
			Result := Factory_general
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

	name_inserts: TUPLE
		do
			Result := [language_name, quote]
		end

feature {NONE} -- Deferred

	escape_character: CHARACTER_32
		deferred
		end

	new_escape_sequence: TP_PATTERN
		deferred
		end

	unescaped_code (text: READABLE_STRING_GENERAL; start_index, end_index, sequence_count: INTEGER): NATURAL_32
		deferred
		end

feature {TP_QUOTED_STRING} -- Internal attributes

	escape_sequence: like new_escape_sequence

	unescaped_action: detachable PROCEDURE [STRING_GENERAL]

	unescaped_string: STRING_GENERAL

feature {NONE} -- Constants

	Name_template: ZSTRING
		once
			Result := "quoted %S string (%S)"
		end
end