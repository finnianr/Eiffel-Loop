note
	description: "Match quoted string with escaping"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-10-31 18:09:43 GMT (Monday 31st October 2022)"
	revision: "3"

deferred class
	EL_MATCH_QUOTED_STRING_TP

inherit
	EL_TEXT_PATTERN
		redefine
			copy, make_default, internal_call_actions
		end

	EL_TEXT_PATTERN_FACTORY
		export
			{NONE} all
		undefine
			copy
		end

feature {NONE} -- Initialization

	make (a_quote: CHARACTER_32; a_unescaped_action: like unescaped_action)
			--
		do
			make_default
			quote := a_quote; unescaped_action := a_unescaped_action
		end

	make_default
		do
			Precursor
			escape_sequence := new_escape_sequence
--			unescaped_string
		end

feature -- Access

	name: STRING
		do
			Result := "quoted " + language_name + " string ()"
			Result.insert_character (quote.to_character_8, name.count)
		end

	quote: CHARACTER_32

feature {NONE} -- Implementation

	internal_call_actions (start_index, end_index: INTEGER)
		do
			Precursor (start_index, end_index)
			if attached unescaped_action as action then
			end
		end

	match_count (a_offset: INTEGER; text: READABLE_STRING_GENERAL): INTEGER
			--
		local
			offset, text_count: INTEGER; done: BOOLEAN
			l_quote: CHARACTER_32; l_escape_sequence: like new_escape_sequence
		do
			text_count := text.count; l_quote := quote; l_escape_sequence := new_escape_sequence
			unescaped_string.keep_head (0)
			from offset := a_offset until offset = text_count or done loop
				l_escape_sequence.match (offset, text)
				if l_escape_sequence.is_matched then
--					unescaped_string.extend (offset + 1, offset + l_escape_sequence.count)
					offset := offset + l_escape_sequence.count
					Result := Result + l_escape_sequence.count

				elseif i_th_is_quote (offset + 1, text, l_quote) then
					done := True
					Result := Result + 1
				else
					Result := Result + 1
					offset := offset + 1
				end
			end
		end

	meets_definition (a_offset: INTEGER; text: READABLE_STRING_GENERAL): BOOLEAN
		-- contract support
		do
		end

feature {NONE} -- Duplication

	copy (other: like Current)
		do
			Precursor (other)
			unescaped_string := other.unescaped_string.twin
		end

feature {NONE} -- Implementation

	i_th_is_quote (i: INTEGER_32; text: READABLE_STRING_GENERAL; a_quote: CHARACTER_32): BOOLEAN
			-- `True' if i'th character exhibits property
		do
			Result := text [i] = a_quote
		end

feature {NONE} -- Deferred

	language_name: STRING
		deferred
		end

	new_escape_sequence: EL_TEXT_PATTERN
		deferred
		end

	unescaped (text: READABLE_STRING_GENERAL; start_index, end_index: INTEGER): CHARACTER_32
		deferred
		end

feature {EL_MATCH_QUOTED_STRING_TP} -- Internal attributes

	escape_sequence: like new_escape_sequence

	unescaped_action: detachable PROCEDURE [READABLE_STRING_GENERAL]

	unescaped_string: STRING_GENERAL

feature {NONE} -- Constants

	Once_buffer: EL_STRING_BUFFER [STRING_GENERAL, READABLE_STRING_GENERAL]
		once
			create {EL_STRING_32_BUFFER} Result
		end

end