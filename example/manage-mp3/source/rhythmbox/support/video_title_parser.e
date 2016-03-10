note
	description: "[
		Parse video title for album and segment information
		
			"<title> [<album-artist>](<album>) {<time-from>-<time-to>}.mp3"
		
		where time-from has format:
		
			mm:ss
			
		and time-to has format:
			mm:ss
			OR
			end
			
		eg.
			"Patienca(Singer: Louis Scalon){2:16-end}"

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:04 GMT (Monday 22nd July 2013)"
	revision: "4"

class
	VIDEO_TITLE_PARSER

inherit
	EL_STRING_EDITOR
		rename
			edit as parse,
			make as make_editor
		redefine
			parse
		end

create
	make

feature {NONE} -- Initialization

	make (a_time_duration: TIME)
			--
		do
			make_editor
			time_duration := a_time_duration
			create time_from.make_by_compact_time (0)
			create time_to.make_by_compact_time (0)
			create album.make_empty
			create album_artists.make_empty
			create title.make_empty
		end

feature -- Basic operations

	parse (a_text: EL_ASTRING)
			--
		do
			Precursor (a_text)
			if at_least_one_match_found then
				title := edited_text
				title.right_adjust
			elseif attached {EL_ASTRING} source_text as l_title then
				title := l_title
			end
		end

feature -- Access

	song: RBOX_SONG

	album: EL_ASTRING

	album_artists: EL_ASTRING

	title: EL_ASTRING

	time_duration: TIME

	time_from: TIME

	time_to: TIME

	year: INTEGER

feature {NONE} -- Patterns

	delimiting_pattern: EL_TEXTUAL_PATTERN
			--
		do
			Result := one_of (<<
				bracketed_pattern (agent on_album, "[]"),
				bracketed_pattern (agent on_album_artists, "()"),
				time_interval,
				year_pattern
			>>)
		end

	bracketed_pattern (a_action: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]; brackets: STRING): like all_of
		local
			name_pattern: like repeat_pattern_1_until_pattern_2
		do
			name_pattern := repeat_pattern_1_until_pattern_2 (
				any_character, character_literal (brackets [2])
			)
			name_pattern.set_action_on_combined_repeated_match (a_action)
			Result := all_of (<< character_literal (brackets [1]), name_pattern >>)
		end

	time_interval: EL_MATCH_ALL_IN_LIST_TP
		do
			Result := all_of (<<
				character_literal ('{'),
				time_pattern (time_from), character_literal ('-'),
				one_of (<<
					time_pattern (time_to),
					string_literal ("end") |to| agent on_end
				>>),
				character_literal ('}')
			>>)
		end

	time_pattern (a_time: TIME): EL_MATCH_ALL_IN_LIST_TP
		do
			Result := all_of (<<
				integer |to| agent on_digits (?, agent a_time.minute_add),
				character_literal (':'),
				double_digits |to| agent on_digits (?, agent a_time.second_add)
			>>)
		end

	year_pattern: EL_MATCH_ALL_IN_LIST_TP
		do
			Result := all_of (<<
				character_literal (' '),
				year_digits |to| agent on_year
			>>)
		end

	double_digits: EL_MATCH_COUNT_WITHIN_BOUNDS_TP
		do
			Result := digit #occurs (2 |..| 2)
		end

	year_digits: EL_MATCH_COUNT_WITHIN_BOUNDS_TP
		do
			Result := digit #occurs (4 |..| 4)
		end

feature {NONE} -- Match actions

	on_album (matched_text: EL_STRING_VIEW)
			--
		do
			album := matched_text
		end

	on_year (matched_text: EL_STRING_VIEW)
			--
		local
			str: EL_ASTRING
		do
			str := matched_text
			if str.is_integer then
				year := str.to_integer
			end
		end

	on_album_artists (matched_text: EL_STRING_VIEW)
			--
		do
			album_artists := matched_text
		end

	on_digits (matched_text: EL_STRING_VIEW; setter_action: PROCEDURE [TIME, TUPLE [INTEGER]])
			--
		local
			digits: STRING
		do
			digits := matched_text
			if digits.is_integer then
				setter_action.call ([digits.to_integer])
			end
		end

	on_end (matched_text: EL_STRING_VIEW)
		do
			time_to := time_duration
		end

end
