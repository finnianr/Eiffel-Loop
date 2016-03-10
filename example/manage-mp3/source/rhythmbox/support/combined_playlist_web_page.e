note
	description: "Summary description for {COMBINED_PLAYLIST_WEB_PAGE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-15 21:42:04 GMT (Saturday 15th June 2013)"
	revision: "3"

class
	COMBINED_PLAYLIST_WEB_PAGE

inherit
	EVOLICITY_SERIALIZEABLE
		rename
			make as make_serializer,
			Empty_template as template
		end

	EL_MODULE_LOG

create
	make

feature {NONE} -- Initiliazation

	make (a_event: MUSIC_EVENT; a_template_path: like template_path)
			--
		do
			make_from_template (a_template_path)
			play_event := a_event
			create genre_set_list.make
			divider_genre := "Cortina"
			create total_duration.make_by_seconds (0)
		end

feature -- Element change

	set_website_name (a_website_name: like website_name)
			--
		do
			website_name := a_website_name
		end

	extend_genre_set_list (playlist: RBOX_PLAYLIST)
			--
		do
			if genre_set_list.is_empty then
				genre_set_list.extend (create {MP3_GENRE_SONG_SET}.make)
			end
			across playlist as song loop
				extend_genre_set_list_with_grouping (
					song.item, song.cursor_index, playlist.count, play_event.omitted_indices (playlist)
				)
			end
		end

feature {NONE} -- Implementation

	extend_genre_set_list_with_grouping (song: RBOX_SONG; index, count: INTEGER; omitted_indices: like play_event.omitted_indices)
			--
		local
			formatted_start_time: STRING
			is_song_ommitted: BOOLEAN
		do
			log.enter ("extend_genre_set_list_with_grouping")

			log.put_string_field ("GENRE", song.genre)
			log.put_string_field (" ARTIST", song.artist)
			log.put_string_field (" VOCALISTS", song.album_artists_list.comma_separated)
			log.put_new_line
			log.put_string_field ("TITLE", song.title)
			log.put_integer_field (" YEAR",song.recording_year)
			log.put_string_field (" ALBUM", song.album)
			log.put_new_line
			song.mp3_path.enable_out_abbreviation
			log_or_io.put_string_field ("LOCATION", song.mp3_path.out)
			log_or_io.put_new_line

			if not genre_set_list.last.is_empty and then genre_set_list.last.last_genre /~ song.genre_main then
				genre_set_list.extend (create {MP3_GENRE_SONG_SET}.make)
			end

			is_song_ommitted := across omitted_indices as interval some interval.item.has (index) end
			if song.genre /~ divider_genre then
				formatted_start_time := (play_event.start_time + total_duration).formatted_out ("[0]hh:[0]mi")
				genre_set_list.last.extend (song, formatted_start_time, not is_song_ommitted)
			end
			if not (song.genre ~ divider_genre or is_song_ommitted) then
				total_duration.second_add (song.duration)
			end
			log.exit
		end

	spell_date: STRING
			--
		do
			Result := play_event.spell_date
		end

feature {NONE} -- Implementation: attributes

	divider_genre: STRING
		-- Genre used as musical interlude ('Cortina' in tango speak)

	website_name: STRING

	milonga_date: DATE

	genre_set_list: LINKED_LIST [MP3_GENRE_SONG_SET]

	play_event: MUSIC_EVENT
		-- Musical event during which a sequence of playlists were played

	total_duration: TIME_DURATION

feature {NONE} -- Evolicity fields

	get_genre_set_list: ITERABLE [MP3_GENRE_SONG_SET]
			--
		do
			Result := genre_set_list
		end

	get_disk_jockey_name: STRING
			--
		do
			Result := play_event.disk_jockey_name
		end

	get_title: STRING
			--
		do
			Result := play_event.title
		end

	get_venue: STRING
			--
		do
			Result := play_event.venue
		end

	get_start_time: STRING
			--
		do
			Result := play_event.start_time.formatted_out ("hh:[0]mi")
		end

	get_website_name: STRING
			--
		do
			Result := website_name
		end

	get_play_event: MUSIC_EVENT
			--
		do
			Result := play_event
		end

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["play_event", agent get_play_event],
				["genre_set_list", agent get_genre_set_list],
				["venue", agent get_venue],
				["title", agent get_title],
				["start_time", agent get_start_time],
				["disk_jockey_name", agent get_disk_jockey_name],
				["website_name", agent get_website_name],
				["spell_date", agent spell_date]
			>>)
		end


end
