note
	description: "[
		Object representing Rhythmbox 2.99.1 song entry in rhythmdb.xml
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-07 11:10:36 GMT (Tuesday 7th April 2020)"
	revision: "36"

class
	RBOX_SONG

inherit
	RBOX_IGNORED_ENTRY
		rename
			location as mp3_path,
			relative_location as relative_mp3_path,
			set_location as set_mp3_path
		redefine
			make, make_default, getter_function_table, on_context_exit,
			Except_fields, Template, Field_sets
		end

	MEDIA_ITEM
		rename
			id as mb_trackid,
			Default_id as Default_audio_id,
			relative_path as mp3_relative_path,
			checksum as last_checksum,
			set_id_from_uuid as set_audio_id_from_uuid
		undefine
			is_equal
		end

	RBOX_SONG_FIELDS undefine is_equal end

	M3U_PLAY_LIST_CONSTANTS

	EL_ZSTRING_CONSTANTS

	EL_MODULE_OS

	EL_MODULE_COLON_FIELD

	EL_MODULE_ZSTRING

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			Precursor
			set_audio_id (Default_audio_id)
			set_first_seen_time (Time.Unix_origin)
		end

	make_default
		do
			Precursor
			album_artists := Default_album_artists
			media_type := Media_types.mpeg
		end

feature -- Artist

	album_artists: like Default_album_artists

	artists_list: EL_ZSTRING_LIST
			-- All artists including album
		do
			create Result.make (1 + album_artists.list.count)
			Result.extend (artist)
			Result.append (album_artists.list)
		end

	lead_artist: ZSTRING
		do
			Result := artist
		end

	title_and_album: ZSTRING
		do
			Result := "%S (%S)"
			Result.substitute_tuple ([title, album])
		end

feature -- Tags

	recording_date: INTEGER
		do
			Result := date
		end

	recording_year: INTEGER
			--
		do
			Result := recording_date // Days_in_year
		end

feature -- Access

	album_picture_checksum: NATURAL
		do
			if mb_albumid.is_natural then
				Result := mb_albumid.to_natural
			end
		end

	audio_id: STRING
		do
			Result := mb_trackid
		end

	file_size_mb: DOUBLE
		do
			Result := File_system.file_megabyte_count (mp3_path)
		end

	first_seen_time: DATE_TIME
		do
			create Result.make_from_epoch (first_seen)
		end

	formatted_duration_time: STRING
			--
		local
			l_time: TIME
		do
			create l_time.make_by_seconds (duration)
			Result := l_time.formatted_out ("mi:[0]ss")
		end

	mp3_info: TL_MUSICBRAINZ_MPEG_FILE
		do
			create Result.make (mp3_path)
		end

	m3u_entry (tanda_index: INTEGER; is_windows_format, is_nokia_phone: BOOLEAN): ZSTRING
			-- For example:

			-- #EXTINF: 182, Te Aconsejo Que me Olvides -- An�bal Troilo (Singers: Francisco Fiorentino)
			-- /storage/sdcard1/Music/Tango/An�bal Troilo/Te Aconsejo Que me Olvides.02.mp3

			-- For Nokia phone:
			-- E:\Music\Tango\An�bal Troilo\Te Aconsejo Que me Olvides.02.mp3
		local
			artists, info: ZSTRING; tanda_name: EL_ZSTRING_LIST
			destination_dir: EL_DIR_PATH; destination_path: EL_FILE_PATH
		do
 			artists := lead_artist.twin
 			if not album_artists.list.is_empty then
 				artists.append (Bracket_template #$ [album_artist])
 			end
			if is_cortina then
				create tanda_name.make_with_words (title)
				tanda_name.start
				if not tanda_name.after and then tanda_name.item.has ('.') then
					tanda_name.remove
				end
				tanda_name.finish
				if not tanda_name.off and then tanda_name.item.has ('_') then
					tanda_name.remove
				end
				info := M3U.info_template #$ [duration, tanda_name.joined_words, Tanda_digits.formatted (tanda_index)]
			else
				info := M3U.info_template #$ [duration, title, artists]
			end
			destination_dir := M3U.play_list_root + Music_directory
			destination_path := destination_dir + exported_relative_path (is_windows_format)
			if is_nokia_phone then
				Result := destination_path.as_windows
			else
				Result := M3U.extinf + info + character_string ('%N') + destination_path
			end
		end

	short_silence: RBOX_SONG
			-- short silence played at end of song to compensate for recorded silence
		local
			index: INTEGER
		do
			if has_silence_specified then
				index := beats_per_minute
			else
				index := 1
			end
			Result := Database.silence_intervals [index]
		end

	unique_normalized_mp3_path: EL_FILE_PATH
			--
		require
			not_hidden: not is_hidden
		do
			Result := normalized_mp3_base_path
			Result.add_extension ("01.mp3")
			Result := Result.next_version_path
		end

feature -- Attributes

	last_checksum: NATURAL

feature -- Locations

	last_copied_mp3_path: EL_FILE_PATH

	mp3_relative_path: EL_FILE_PATH
		do
			Result := mp3_path.relative_path (music_dir)
		end

feature -- Status query

	has_audio_id: BOOLEAN
		do
			Result := audio_id /= Default_audio_id
		end

	has_other_artists: BOOLEAN
			--
		do
			Result := not album_artists.list.is_empty
		end

	has_silence_specified: BOOLEAN
			-- true if mp3 track does not have enough silence at end and has some extra silence
			-- specified by beats_per_minute
		do
			Result := Database.silence_intervals.valid_index (beats_per_minute)
		end

	is_cortina: BOOLEAN
			-- Is genre a short clip used to separate a dance set (usually used in Tango dances)
		do
			Result := genre ~ Extra_genre.cortina
		end

	is_genre_silence: BOOLEAN
			-- Is genre a short silent clip used to pad a song
		do
			Result := genre ~ Extra_genre.silence
		end

	is_hidden: BOOLEAN
		do
			Result := hidden.to_boolean
		end

	is_modified: BOOLEAN
			--
		do
			Result := last_checksum /= main_fields_checksum
		end

	is_mp3_format: BOOLEAN
		do
			Result := mp3_path.extension ~ Mp3_extension
		end

	is_mp3_path_normalized: BOOLEAN
			-- Does the mp3 path conform to:
			-- <mp3_root_location>/<genre>/<artist>/<title>.<version number>.mp3
		require
			not_hidden: not is_hidden
		local
			l_extension, l_actual_path, l_normalized_path: ZSTRING
		do
			l_actual_path := mp3_path.relative_path (music_dir).without_extension
			l_normalized_path := normalized_path_steps.as_file_path
			if l_actual_path.starts_with (l_normalized_path) then
				l_extension := l_actual_path.substring_end (l_normalized_path.count + 1) -- .00
				Result := l_extension.count = 3 and then l_extension.substring (2, 3).is_integer
			end
		end

feature -- Element change

	move_mp3_to_normalized_file_path
			-- move mp3 file to directory relative to root <genre>/<lead artist>
			-- and delete empty directory at source
		require
			not_hidden: not is_hidden
		local
			old_mp3_path: like mp3_path
		do
			log.enter ("move_mp3_to_genre_and_artist_directory")
			old_mp3_path := mp3_path
			mp3_path := unique_normalized_mp3_path

			File_system.make_directory (mp3_path.parent)
			OS.move_file (old_mp3_path, mp3_path)
			if old_mp3_path.parent.exists then
				File_system.delete_empty_branch (old_mp3_path.parent)
			end
			log.exit
		end

	set_album_artists (text: ZSTRING)
			--
		local
			list: EL_ZSTRING_LIST; type: ZSTRING
		do
			if not (text.is_empty or text ~ Unknown_string) then
				type := Colon_field.name (text)
				if type.is_empty then
					create list.make_with_csv (text)
					album_artists := [Unknown_string, list]
				else
					create list.make_with_csv (Colon_field.value (text))
					Artist_type_list.find_first_true (agent ZString.starts_with (type, ?))
					if Artist_type_list.after then
						album_artists := [type, list]
					else
						album_artists := [Artist_type_list.item, list]
					end
				end
			end
		end

	set_audio_id (id: STRING)
		do
			mb_trackid := id
		end

	set_first_seen_time (a_first_seen_time: like first_seen_time)
		do
			first_seen := Time.unix_date_time (a_first_seen_time)
		end

	set_music_dir (a_music_dir: like music_dir)
			--
		do
			music_dir := a_music_dir
		end

	set_recording_date (a_recording_date: like recording_date)
			--
		do
			date := a_recording_date
		end

	update_checksum
			--
		do
			last_checksum := main_fields_checksum
		end

	update_audio_id
		local
			mp3: like mp3_info
		do
			set_audio_id_from_uuid (new_audio_id)
			mp3 := mp3_info
--			mp3.remove_unique_id ("RBOX"); mp3.remove_unique_id ("UFID")
			mp3.set_recording_id (mb_trackid)
			mp3.save
			mp3.dispose
			update_file_info
		end

	update_file_info
		do
			mtime := File_system.file_modification_time (mp3_path)
			file_size := File_system.file_byte_count (mp3_path)
		end

feature -- Status setting

	hide
		do
			hidden := 1
		end

	show
		do
			hidden := 0
		end

feature -- Basic operations

	save_id3_info
		local
			mp3: like mp3_info
		do
			mp3 := mp3_info
			write_id3_info (mp3)
			mp3.dispose
			update_file_info
		end

	write_id3_info (mp3: TL_MUSICBRAINZ_MPEG_FILE)
			--
		do
			mp3.tag.set_title (title)
			mp3.tag.set_artist (artist)
			mp3.tag.set_genre (genre)
			mp3.tag.set_album (album)
			mp3.tag.set_album_artist (album_artist)

			if composer ~ Unknown_string then
				mp3.tag.set_composer (Empty_string)
			else
				mp3.tag.set_composer (composer)
			end

			if track_number > 0 then
				mp3.tag.set_track (track_number)
			end
			if beats_per_minute > 0 then
				mp3.tag.set_beats_per_minute (beats_per_minute)
			end

			mp3.tag.set_year_from_days (recording_date)
			mp3.tag.set_comment_with (ID3_comment_description, comment)

			mp3.set_album_artist_id (mb_albumartistid)
			mp3.set_album_id (mb_albumid)
			mp3.set_artist_id (mb_artistid)
			mp3.set_artist_sort_name (mb_artistsortname)
			mp3.set_recording_id (mb_trackid)

			mp3.save
		end

feature {NONE} -- Implementation

	main_fields_checksum: NATURAL
			--
		local
			crc: like crc_generator; l_picture_checksum: NATURAL
		do
			crc := crc_generator
			crc.add_tuple ([artists_list.comma_separated, album, title, genre, comment, recording_date])

			l_picture_checksum := album_picture_checksum
			if l_picture_checksum > 0 then
				crc.add_natural (l_picture_checksum)
			end
			Result := crc.checksum
		end

	new_audio_id: EL_UUID
		local
			mp3: EL_MP3_IDENTIFIER
		do
			create mp3.make (mp3_path)
			Result := mp3.audio_id
		end

	normalized_mp3_base_path: EL_FILE_PATH
			-- normalized path <mp3_root_location>/<genre>/<artist>/<title>[<- vocalists>]
		do
			Result := music_dir.joined_file_steps (normalized_path_steps)
		end

	normalized_path_steps: EL_PATH_STEPS
			-- normalized path steps <genre>,<artist>,<title>
		do
			Result := << genre, artist, title.translated (Problem_file_name_characters, Problem_file_name_substitutes) >>
			-- Remove problematic characters from last step of name
		end

feature {NONE} -- Build from XML

	on_context_exit
			-- Called when the parser leaves the current context
		do
			update_checksum
			set_album_artists (album_artist)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["artists", 					agent: ZSTRING do Result := Xml.escaped (artists_list.comma_separated) end] +
				["lead_artist", 				agent: ZSTRING do Result := Xml.escaped (lead_artist) end] +
				["album_artists", 			agent: ZSTRING do Result := Xml.escaped (album_artist) end] +
				["artist_list", 				agent: ITERABLE [ZSTRING] do Result := artists_list end] +

				["duration_time", 			agent formatted_duration_time] +

				["replaygain_track_gain", 	agent: DOUBLE_REF do Result := replaygain_track_gain.to_reference end] +
				["replaygain_track_peak", 	agent: DOUBLE_REF do Result := replaygain_track_peak.to_reference end] +

				["last_checksum", 			agent: NATURAL_32_REF do Result := last_checksum.to_reference end] +
				["recording_year", 			agent: INTEGER_REF do Result := recording_year.to_reference end] +

				["is_hidden", 					agent: BOOLEAN_REF do Result := is_hidden.to_reference end] +
				["is_cortina",					agent: BOOLEAN_REF do Result := is_cortina.to_reference end] +
				["has_other_artists",		agent: BOOLEAN_REF do Result := has_other_artists.to_reference end] +
				["string_8_fields",			agent get_string_8_fields]
		end

feature -- Constants

	Except_fields: STRING
			-- Object attributes that are not stored in Rhythmbox Database
		once
			Result := Precursor + ", album_artists"
		end

	Field_sets: EL_HASH_TABLE [EL_HASH_SET [STRING_GENERAL], STRING]
		once
			create Result.make (<<
				["album", Album_set],
				["artist", Artist_set]
			>>)
			Result.merge (Precursor)
		end

	Problem_file_name_characters: ZSTRING
		once
			Result := "\/"
		end

	Problem_file_name_substitutes: ZSTRING
		once
			create Result.make_filled ('-', Problem_file_name_characters.count)
		end

	Template: STRING = "[
		<entry type="song">
		#across $string_8_fields as $field loop
			<$field.key>$field.item</$field.key>
		#end
		#across $non_empty_string_fields as $field loop
			<$field.key>$field.item</$field.key>
		#end
			<location>$location_uri</location>
			#if not ($replaygain_track_gain = 0.0) then
			<replaygain-track-gain>$replaygain_track_gain</replaygain-track-gain>
			<replaygain-track-peak>$replaygain_track_peak</replaygain-track-peak>
			#end
		#across $non_zero_integer_fields as $field loop
			<$field.key>$field.item</$field.key>
		#end
			#if $is_hidden then
			<hidden>1</hidden>
			#end
		</entry>
	]"

end
