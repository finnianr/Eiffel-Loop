note
	description: "[
		Object representing Rhythmbox 2.99.1 song entry in rhythmdb.xml
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-17 14:21:31 GMT (Wednesday 17th October 2018)"
	revision: "14"

class
	RBOX_SONG

inherit
	RBOX_IGNORED_ENTRY
		rename
			location as mp3_path,
			set_location as set_mp3_path
		redefine
			make, building_action_table, getter_function_table, on_context_exit,
			Except_fields, Template
		end

	MEDIA_ITEM
		rename
			id as audio_id,
			relative_path as mp3_relative_path,
			checksum as last_checksum
		undefine
			is_equal
		end

	EL_MODULE_OS
		undefine
			is_equal
		end

	EL_MODULE_TAG
		undefine
			is_equal
		end

	EL_ZSTRING_CONSTANTS
		undefine
			is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (a_database: like database)
			--
		do
			Precursor (a_database)
			audio_id := Default_audio_id
			create mp3_path
			create last_copied_mp3_path
			create mp3_path
			create album_artists_list.make_empty
			create album_artists_prefix.make_empty
			set_first_seen_time (Time.Unix_origin)
		end

feature -- Rhythmbox XML fields

	album_artist: ZSTRING

	artist: ZSTRING

	album: ZSTRING

	beats_per_minute: INTEGER
		-- If beats per minute <= 3 it indicates silence duration appended to playlist

	bitrate: INTEGER

	comment: ZSTRING

	composer: ZSTRING

	disc_number: INTEGER

	duration: INTEGER

	date: INTEGER
		-- Recording date in days

	file_size: INTEGER

	first_seen: INTEGER

	last_played: INTEGER

	mb_artistid: ZSTRING

	mb_albumid: ZSTRING

	mb_albumartistid: ZSTRING

	mb_artistsortname: ZSTRING

	play_count: INTEGER

	track_number: INTEGER

	rating: INTEGER

	replaygain_track_gain: DOUBLE

	replaygain_track_peak: DOUBLE

feature -- Artist

	album_artists_list: like artists_list

	album_artists_prefix: ZSTRING
		-- Singer, Performer etc

	artists_list: EL_STRING_LIST [ZSTRING]
			-- All artists including album
		do
			create Result.make (1 + album_artists_list.count)
			Result.extend (artist)
			Result.append (album_artists_list)
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

	id3_info: EL_ID3_INFO
		do
			create Result.make (mp3_path)
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
			Result := database.silence_intervals [index]
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
			Result := not album_artists_list.is_empty
		end

	has_silence_specified: BOOLEAN
			-- true if mp3 track does not have enough silence at end and has some extra silence
			-- specified by beats_per_minute
		do
			Result := database.silence_intervals.valid_index (beats_per_minute)
		end

	is_cortina: BOOLEAN
			-- Is genre a short clip used to separate a dance set (usually used in Tango dances)
		do
			Result := genre ~ Genre_cortina
		end

	is_genre_silence: BOOLEAN
			-- Is genre a short silent clip used to pad a song
		do
			Result := genre ~ Genre_silence
		end

	is_hidden: BOOLEAN

	is_modified: BOOLEAN
			--
		do
			Result := last_checksum /= main_fields_checksum
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

	set_album (a_album: like album)
			--
		do
			album := a_album
		end

	set_album_artists_list (a_album_artists: ZSTRING)
			--
		local
			pos_colon: INTEGER
			text: ZSTRING
		do
			pos_colon := a_album_artists.index_of (':', 1)
			if pos_colon > 0 then
				album_artists_prefix := a_album_artists.substring (1, pos_colon - 1)
				text := a_album_artists.substring_end (pos_colon + 1)
				text.left_adjust
			else
				text := a_album_artists
				album_artists_prefix := Empty_string
			end
			album_artists_list.wipe_out
			album_artists_list.append_split (text, ',', True)
			comment := album_artist
		ensure
			is_set: a_album_artists.has_substring (": ") implies a_album_artists ~ album_artist
		end

	set_album_picture_checksum (picture_checksum: NATURAL)
			-- Set this if album art changes to affect the main checksum
		do
			mb_albumid := picture_checksum.out
		end

	set_artist (a_artist: like artist)
			--
		do
			artist := a_artist
		end

	set_bitrate (a_bitrate: like bitrate)
			--
		do
			bitrate := a_bitrate
		end

	set_beats_per_minute (a_beats_per_minute: like beats_per_minute)
			--
		do
			beats_per_minute := a_beats_per_minute
		end

	set_comment (a_comment: like comment)
			--
		do
			comment := a_comment
		end

	set_composer (a_composer: like composer)
			--
		do
			if a_composer ~ Unknown_string then
				composer := Unknown_string
			else
				composer := a_composer
			end
		end

	set_duration (a_duration: like duration)
		do
			duration := a_duration
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

	set_recording_year (a_year: INTEGER)
		do
			date := a_year * Days_in_year
		end

	set_track_number (a_track_number: like track_number)
		do
			track_number := a_track_number
		end

	update_checksum
			--
		do
			last_checksum := main_fields_checksum
		end

	update_audio_id
		local
			l_id3_info: like id3_info; mp3: MP3_IDENTIFIER
		do
			create mp3.make (mp3_path)
			audio_id := mp3.audio_id
			l_id3_info := id3_info
--			l_id3_info.remove_unique_id ("RBOX"); l_id3_info.remove_unique_id ("UFID")
			l_id3_info.set_music_brainz_track_id (music_brainz_track_id)
			l_id3_info.update
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
			is_hidden := True
		end

	show
		do
			is_hidden := False
		end

feature -- Basic operations

	save_id3_info
		do
			write_id3_info (id3_info)
		end

	write_id3_info (a_id3_info: EL_ID3_INFO)
			--
		do
			a_id3_info.set_title (title)
			a_id3_info.set_artist (artist)
			a_id3_info.set_genre (genre)
			a_id3_info.set_album (album)
			a_id3_info.set_album_artist (album_artist)

			if composer ~ Unknown_string then
				a_id3_info.remove_basic_field (Tag.composer)
			else
				a_id3_info.set_composer (composer)
			end

			if track_number > 0 then
				a_id3_info.set_track (track_number)
			end
			if beats_per_minute > 0 then
				a_id3_info.set_beats_per_minute (beats_per_minute)
			end

			a_id3_info.set_year_from_days (recording_date)
			a_id3_info.set_comment (ID3_comment_description, comment)

			a_id3_info.set_music_brainz_field ("albumartistid", mb_albumartistid)
			a_id3_info.set_music_brainz_field ("albumid", mb_albumid)
			a_id3_info.set_music_brainz_field ("artistid", mb_artistid)
			a_id3_info.set_music_brainz_field ("artistsortname", mb_artistsortname)

			a_id3_info.update
			update_file_info
		end

feature {NONE} -- Implementation

	main_fields_checksum: NATURAL
			--
		local
			crc: like crc_generator; l_picture_checksum: NATURAL
		do
			crc := crc_generator
			across << artists_list.comma_separated, album, title, genre, comment >> as field loop
				crc.add_string (field.item)
			end
			crc.add_integer (recording_date)

			l_picture_checksum := album_picture_checksum
			if l_picture_checksum > 0 then
				crc.add_natural (l_picture_checksum)
			end
			Result := crc.checksum
		end

	music_brainz_track_id: STRING
		do
			Result := audio_id.out
			if not audio_id.is_null then
				set_uuid_delimiter (Result, ':')
			end
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

	set_uuid_delimiter (uuid: STRING; delimiter: CHARACTER)
		do
			across << 9, 14, 19, 24 >> as pos loop
				uuid.put (delimiter, pos.item)
			end
		end

feature {NONE} -- Build from XML

	on_context_exit
			-- Called when the parser leaves the current context
		do
			Precursor
			update_checksum
			set_album_artists_list (album_artist)
		end

	set_audio_id_from_node
		local
			id: STRING
		do
			id := node.to_string_8
			if id.occurrences (':') = 4 then
				set_uuid_delimiter (id, '-')
				create audio_id.make_from_string (id)
			end
		end

	building_action_table: EL_PROCEDURE_TABLE
			--
		do
			Result := Precursor
			Result.merge (building_actions_for_type ({DOUBLE}, Text_element_node))
			Result := Result + 	["hidden/text()", agent do is_hidden := node.to_integer = 1 end] +
										["mb-trackid/text()", agent set_audio_id_from_node]
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor +
				["audio_id", 						agent: STRING do Result := audio_id.out end] +

				["artists", 						agent: ZSTRING do Result := Xml.escaped (artists_list.comma_separated) end] +
				["lead_artist", 					agent: ZSTRING do Result := Xml.escaped (lead_artist) end] +
				["album_artists", 				agent: ZSTRING do Result := Xml.escaped (album_artist) end] +
				["artist_list", 					agent: ITERABLE [ZSTRING] do Result := artists_list end] +

				["mb_trackid",						agent music_brainz_track_id] +
				["duration_time", 				agent formatted_duration_time] +

				["replaygain_track_gain", 		agent: DOUBLE_REF do Result := replaygain_track_gain.to_reference end] +
				["replaygain_track_peak", 		agent: DOUBLE_REF do Result := replaygain_track_peak.to_reference end] +

				["last_checksum", 				agent: NATURAL_32_REF do Result := last_checksum.to_reference end] +
				["recording_year", 				agent: INTEGER_REF do Result := recording_year.to_reference end] +

				["is_hidden", 						agent: BOOLEAN_REF do Result := is_hidden.to_reference end] +
				["is_cortina",						agent: BOOLEAN_REF do Result := is_cortina.to_reference end] +
				["has_other_artists",			agent: BOOLEAN_REF do Result := has_other_artists.to_reference end]
		end

feature -- Constants

	Album_artist_prefix_list: ARRAY [ZSTRING]
			-- Field headings in ID3 'c0' comment, used to indicate other artists
		local
			l_result: ARRAYED_LIST [ZSTRING]
		once
			Result := << "Singer", "Artist", "Soloist", "Performer", "Composer" >>
			create l_result.make_from_array (Result)

			-- Add plural
			across Result as name loop
				l_result.extend (name.item.twin)
				l_result.last.append_character ('s')
			end
			Result := l_result.to_array
			Result.compare_objects
		end

	Days_in_year: INTEGER = 365

	Default_audio_id: EL_UUID
		once
			create Result.make_default
		end

	Except_fields: STRING
			-- Object attributes that are not stored in Rhythmbox database
		once
			Result := Precursor + ", album_artists_prefix"
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
		#across $non_empty_string_fields as $field loop
			<$field.key>$field.item</$field.key>
		#end
			<location>$location_uri</location>
			#if not ($replaygain_track_gain = 0.0) then
			<replaygain-track-gain>$replaygain_track_gain</replaygain-track-gain>
			<replaygain-track-peak>$replaygain_track_peak</replaygain-track-peak>
			#end
			<mb-trackid>$mb_trackid</mb-trackid>
		#across $non_zero_integer_fields as $field loop
			<$field.key>$field.item</$field.key>
		#end
			#if $is_hidden then
			<hidden>1</hidden>
			#end
		</entry>
	]"

end
