note
	description: "[
		Parses artist field with format: "(<country>) <artist> - <title>" for album: Awards for World Music
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:19 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	AWARDS_FOR_WORLD_MUSIC_TITLE_EDITOR

inherit
	EL_STRING_EDITOR
		rename
			delimiting_pattern as country_artist_title_pattern
		redefine
			edit_text, make, country_artist_title_pattern
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			create artist_from_title.make_empty
			create country_from_title.make_empty
		end

feature -- Access

	artist_from_title: STRING

	country_from_title: STRING

feature -- Basic operations

	edit_text
			--
		do
			country_from_title.wipe_out
			artist_from_title.wipe_out

			output := new_output
			match_full
			if full_match_succeeded then
				write_new_text
			end
			close
		end

feature {NONE} -- Implementation		

	country_artist_title_pattern: EL_TEXTUAL_PATTERN
			--
		do
			Result := all_of (<<
				character_literal ('('),
				country_pattern,
				character_literal (' '),
				artist_pattern,
				title_pattern
			>>)
		end

	country_pattern: EL_MATCH_TP1_UNTIL_TP2_MATCH_TP
			--
		do
			Result := repeat_pattern_1_until_pattern_2 (
				any_character,
				character_literal (')')
			)
			Result.set_action_on_combined_repeated_match (agent on_country)

		end

	artist_pattern: EL_MATCH_TP1_UNTIL_TP2_MATCH_TP
			--
		do
			Result := repeat_pattern_1_until_pattern_2 (
				any_character,
				string_literal (" - ")
			)
			Result.set_action_on_combined_repeated_match (agent on_artist)
		end

	title_pattern: EL_MATCH_TP1_UNTIL_TP2_MATCH_TP
			--
		do
			Result := repeat_pattern_1_until_pattern_2 (
				any_character,
				end_of_line_character
			)
			Result.set_action_on_combined_repeated_match (agent on_title)
		end

feature {NONE} -- Title parsing actions

	on_title (matched_text: EL_STRING_VIEW)
			--
		do
			log.enter_with_args ("on_title", << matched_text >>)
			put_string (matched_text)
			log.exit
		end

	on_country (matched_text: EL_STRING_VIEW)
			--
		do
			log.enter_with_args ("on_country", << matched_text >>)
			country_from_title := matched_text
			log.exit
		end

	on_artist (matched_text: EL_STRING_VIEW)
			--
		do
			log.enter_with_args ("on_artist", << matched_text >>)
			artist_from_title := matched_text
			log.exit
		end

end
