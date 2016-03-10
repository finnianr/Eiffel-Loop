note
	description: "Summary description for {ID3_LATIN1_TITLE_FIELD_EDITOR}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	ID3_LATIN1_TITLE_FIELD_EDITOR

inherit
	ID3_LATIN1_FIELD_EDITOR
		redefine
			delimiting_pattern, edit_text
		end

create
	make

feature -- Access

	recording_date_from_title: INTEGER

feature -- Basic operations

	edit_text
			--
		do
			recording_date_from_title := 0
			Precursor
			if recording_date_from_title /= 0 then
				edited_text.right_adjust
				edited_text.prune_all_trailing ('-')
				edited_text.right_adjust
			end
		end

feature {NONE} -- Implementation

	delimiting_pattern: EL_FIRST_MATCH_IN_LIST_TP
			--
		do
			Result := Precursor
			Result.put_front (bracketed_year_at_line_end)
			Result.put_front (mp3_extension_ending)
		end

	bracketed_year_at_line_end: EL_MATCH_ALL_IN_LIST_TP
			-- Discarded match
		do
			Result := all_of (<<
				one_of (<<
					year_digits,
					encased_with_characters (year_digits, "()"),
					encased_with_characters (year_digits, "[]")
				>>),
				end_of_line_character
			>>)
		end

	year_digits: EL_MATCH_COUNT_WITHIN_BOUNDS_TP
			--
		do
			Result := digit #occurs (4 |..| 4) |to| agent on_year_digits
		end

	mp3_extension_ending: EL_MATCH_ALL_IN_LIST_TP
			-- Discarded match
		do
			Result := all_of (<<
				optional (
					one_of_characters (<<
						character_literal (' '), digit
					>>)
				),
				one_of (<<
					string_literal (".mp3"),
					string_literal (".MP3")
				>>),
				end_of_line_character
			>>)
		end

feature {NONE} -- Match actions

	on_year_digits (matched_text: EL_STRING_VIEW)
			--
		do
			recording_date_from_title := matched_text.view.to_integer * Days_in_year
		end

feature -- Constants

	Days_in_year: INTEGER = 365

end
