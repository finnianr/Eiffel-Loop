note
	description: "Summary description for {ID3_LATIN1_CLASSICAL_TITLE_FIELD_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	ID3_LATIN1_CLASSICAL_TITLE_FIELD_EDITOR

inherit
	ID3_LATIN1_FIELD_EDITOR
		redefine
			delimiting_pattern, on_default_word
		end

create
	make

feature {NONE} -- Implementation

	delimiting_pattern: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := Precursor
			Result.put_front (roman_numerals)
		end

	roman_numerals: EL_MATCH_TP1_UNTIL_TP2_MATCH_TP
			--
		do
			Result := repeat_pattern_1_until_pattern_2 (one_character_from ("ivxIVX"), not latin1_letter)
			Result.set_action_on_match_begin (agent on_roman_numerals)
		end

feature {NONE} -- Match actions

	on_roman_numerals (matched_text: EL_STRING_VIEW)
			--
		do
			put_string (matched_text.view.as_upper)
		end

feature {NONE} -- Match actions

	on_default_word (matched_text: EL_STRING_VIEW; first_word_in_line: BOOLEAN)
			--
		local
			word: STRING
		do
			word := matched_text
			if word.count = 1 and then word.item (1).is_alpha then
				put_string (word.as_upper)
			else
				Precursor (matched_text, first_word_in_line)
			end
		end

end
