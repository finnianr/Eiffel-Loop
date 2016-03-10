note
	description: "[
		Object representing Rhythmbox 2.99.1 song entry in rhythmdb.xml
	]"

	notes: "[
		Support has been partially added for unstable 3.00 version with 'composer' field.

	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-25 22:12:29 GMT (Thursday 25th July 2013)"
	revision: "5"

class
	RBOX_SONG

inherit
	RBOX_IGNORED_ENTRY
		rename
			on_context_exit as update_checksum, -- Called when the parser leaves the current context
			make as make_entry,
			location as mp3_path,
			set_location as set_mp3_path
		undefine
			update_checksum
		redefine
			building_action_table, getter_function_table, Template
		end

	EL_MODULE_TAG

create
	make

feature {NONE} -- Initialization

	make (a_mp3_root_location: like mp3_root_location)
			--
		do
			make_entry
			mp3_root_location := a_mp3_root_location
			create mp3_path
			create last_copied_mp3_path
			create artist.make_empty
			create album.make_empty
			create comment.make_empty
			composer := Unknown_string
			create music_brainz_info
			create album_artists_list.make_empty
			create album_artists_prefix.make_empty
			first_seen_time := Time.Unix_origin.twin
		end

feature -- Artist

	artist: EL_ASTRING

	album_artists_prefix: EL_ASTRING
		-- Singer, Performer etc

	title_and_album: EL_ASTRING
		do
			Result := String.template ("$S ($S)").substituted (<< title, album >>)
		end

	lead_artist: EL_ASTRING
		do
			Result := artist
		end

	album_artists: EL_ASTRING
		do
			if album_artists_list.is_empty then
				create Result.make_empty
			else
				create Result.make (
					album_artists_prefix.count + album_artists_list.character_count + 2 + album_artists_list.count
				)
				if not album_artists_prefix.is_empty then
					Result.append (album_artists_prefix)
					Result.append (": ")
				end
				Result.append (album_artists_list.comma_separated)
			end
		end

	artists_list: EL_STRING_LIST [EL_ASTRING]
			-- All artists including album
		do
			create Result.make (1 + album_artists_list.count)
			Result.extend (artist)
			Result.append (album_artists_list)
		end

	album_artists_list: like artists_list

feature -- Tags

	album: EL_ASTRING

	composer: EL_ASTRING

	comment: EL_ASTRING

	recording_date: INTEGER
		-- Recording date in days

	recording_year: INTEGER
			--
		do
			Result := recording_date // Days_in_year
		end

	track_number: INTEGER

	disc_number: INTEGER

	beats_per_minute: INTEGER
		-- Beats per minute used to indicate silence duration appended to playlist

	duration: INTEGER

feature -- Access

	id3_info: EL_ID3_INFO
		do
			create Result.make (mp3_path)
		end

	formatted_duration_time: STRING
			--
		local
			l_time: TIME
		do
			create l_time.make_by_seconds (duration)
			Result := l_time.formatted_out ("mi:[0]ss")
		end

	unique_normalized_mp3_path: EL_FILE_PATH
			--
		require
			not_hidden: not is_hidden
		do
			Result := unique_extension (normalized_mp3_base_path)
		end

	track_id: NATURAL_64
			-- id based on audio sampling
			-- with exception for cortina which have identical audio
		local
			header: EL_ID3_HEADER
			l_file: RAW_FILE
			data_size: INTEGER
			crc: EL_CYCLIC_REDUNDANCY_CHECK_32
		do
			if actual_track_id = 0 and then mp3_path.exists then
				create l_file.make_open_read (mp3_path.unicode)
				create header.make_from_file (l_file)
				if header.is_valid then
					data_size := l_file.count - header.total_size
					l_file.go (header.total_size + data_size // 10)

					l_file.read_natural_64
					actual_track_id := l_file.last_natural_64

					from until not is_padding (actual_track_id) loop
						l_file.move (8 * 30)
						l_file.read_natural_64
						actual_track_id := l_file.last_natural_64
					end
					-- Combine 4 samples
--					from i := 1 until i > 4 loop
--						l_file.read_natural_16
--						actual_track_id := (actual_track_id  |<< 16) | l_file.last_natural_16
--						i := i + 1
--						if i <= 4 then
--							l_file.move (data_size // 200)
--						end
--					end
				end
				l_file.close

				if is_genre_cortina or is_genre_silence then
					create crc
					crc.add_string (title)
					actual_track_id := actual_track_id + crc.checksum
				end
			end
			Result := actual_track_id
		end

	album_picture_checksum: NATURAL
		do
			music_brainz_info.search ("albumid")
			if music_brainz_info.found and then music_brainz_info.found_item.is_natural then
				Result := music_brainz_info.found_item.to_natural
			end
		end

	bitrate: INTEGER

	file_size: INTEGER

	first_seen_time: DATE_TIME

	play_count: INTEGER

	last_played: INTEGER

	gain: DOUBLE

	peak: DOUBLE

	music_brainz_info: EL_ASTRING_HASH_TABLE [EL_ASTRING]

	last_checksum: NATURAL

feature -- Locations

	mp3_root_location: EL_DIR_PATH

	mp3_relative_path_steps: EL_PATH_STEPS
			-- path steps relative to root
		do
			Result := mp3_path.relative_path (mp3_root_location).steps
		end

	exportable_mp3_path: EL_FILE_PATH
			-- path with NTFS with non compatible characters chnaged to '.'
		do
			Result:=  mp3_path.twin
			Result.set_base (valid_ntfs_name (Result.base))
		end

	last_copied_mp3_path: EL_FILE_PATH

feature -- Status query

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
			l_extension, l_actual_path, l_normalized_path: EL_ASTRING

		do
			l_actual_path := mp3_path.relative_path (mp3_root_location).without_extension
			l_normalized_path := normalized_path_steps.as_file_path
			if l_actual_path.starts_with (l_normalized_path) then
				l_extension := l_actual_path.substring (l_normalized_path.count + 1, l_actual_path.count) -- .00
				Result := l_extension.count = 3 and then l_extension.substring (2, 3).is_integer
			end
		end

	has_other_artists: BOOLEAN
			--
		do
			Result := not album_artists_list.is_empty
		end

	has_track_id: BOOLEAN
		do
			Result := track_id > 0
		end

	is_genre_cortina: BOOLEAN
			-- Is genre a short clip used to separate a dance set (usually used in Tango dances)
		do
			Result := genre ~ Rhythmbox.Genre_cortina
		end

	is_genre_silence: BOOLEAN
			-- Is genre a short silent clip used to pad a song
		do
			Result := genre ~ Rhythmbox.Genre_silence
		end

feature -- Element change

	set_title (a_title: like title)
			--
		do
			title := a_title
		end

	set_album (a_album: like album)
			--
		do
			album := a_album
		end

	set_artist (a_artist: like artist)
			--
		do
			artist := a_artist
		end

	set_album_artists_list (a_album_artists: EL_ASTRING)
			--
		local
			pos_colon: INTEGER
			text: EL_ASTRING
		do
			pos_colon := a_album_artists.index_of (':', 1)
			if pos_colon > 0 then
				album_artists_prefix := a_album_artists.substring (1, pos_colon - 1)
				text := a_album_artists.substring (pos_colon + 1, a_album_artists.count)
				text.left_adjust
			else
				text := a_album_artists
				album_artists_prefix := Empty_string
			end
			album_artists_list.wipe_out
			album_artists_list.append_split (text, ',', True)
			comment := album_artists
		ensure
			is_set: a_album_artists.has_substring (": ") implies a_album_artists ~ album_artists
		end

	set_bitrate (a_bitrate: like bitrate)
			--
		do
			bitrate := a_bitrate
		end

	set_genre (a_genre: like genre)
			--
		do
			genre := a_genre
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

	set_recording_date (a_recording_date: like recording_date)
			--
		do
			recording_date := a_recording_date
		end

	set_recording_year (a_year: INTEGER)
		do
			recording_date := a_year * Days_in_year
		end

	set_track_number (a_track_number: like track_number)
		do
			track_number := a_track_number
		end

	set_album_picture_checksum (picture_checksum: NATURAL)
			-- Set this if album art changes to affect the main checksum
		do
			set_musicbrainz_field ("albumid", picture_checksum.out)
		end

	set_musicbrainz_field (a_name: STRING; a_value: EL_ASTRING)
		require
			valid_name: Music_brainz_fields.has (a_name)
		do
			music_brainz_info [a_name] := a_value
		end

	set_first_seen_time (a_first_seen_time: like first_seen_time)
		do
			first_seen_time := a_first_seen_time
		end

	update_checksum
			--
		do
			last_checksum := main_fields_checksum
		end

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
			File_system.move (old_mp3_path, mp3_path)
			if old_mp3_path.parent.exists then
				File_system.delete_empty_steps (old_mp3_path.parent.steps)
			end
			log.exit
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
		local
			musicbrainz_field_name: EL_ASTRING
		do
			a_id3_info.set_title (title)
			a_id3_info.set_artist (artist)
			a_id3_info.set_genre (genre)
			a_id3_info.set_album (album)
			a_id3_info.set_album_artist (album_artists)

--			Not yet ready for unstable Rhythmbox Ver 3.0.1
--			if composer ~ Unknown_string then
--				a_id3_info.remove_basic_field (Tag.composer)
--			else
--				a_id3_info.set_composer (composer)
--			end

			if track_number > 0 then
				a_id3_info.set_track (track_number)
			end

			a_id3_info.set_year_from_days (recording_date)
			a_id3_info.set_comment (Rhythmbox.ID3_comment_description, comment)
			across music_brainz_info as mb loop
				musicbrainz_field_name := "musicbrainz_"
				musicbrainz_field_name.append (mb.key)
				a_id3_info.set_user_text (musicbrainz_field_name, mb.item)
			end
			a_id3_info.update
		end

 	put_m3u_entry (
 		m3u_file: PLAIN_TEXT_FILE; a_relative_steps: like mp3_relative_path_steps; a_playlist_directory_prefix: EL_DIR_PATH
 	)
 		local
 			l_artists: EL_ASTRING
 		do
 			l_artists := lead_artist.twin
 			if not album_artists_list.is_empty then
 				l_artists.append (" (")
 				l_artists.append (album_artists)
 				l_artists.append_character (')')
 			end
 			Playlist_template.set_variables_from_array (<<
 				["duration", duration.out],
				["genre", genre.as_upper],
				["title", title],
				["artists", l_artists],
				["location_path", m3u_location (a_relative_steps, a_playlist_directory_prefix).to_string]
 			>>)
			m3u_file.put_string (Playlist_template.substituted.to_utf8)
			m3u_file.put_new_line
 		end

 	put_nokia_m3u_entry (
 		m3u_file: PLAIN_TEXT_FILE; a_relative_steps: like mp3_relative_path_steps; a_playlist_directory_prefix: EL_DIR_PATH
 	)
 		do
			m3u_file.put_string (m3u_location (a_relative_steps, a_playlist_directory_prefix).as_windows.to_string.to_utf8)
			m3u_file.put_new_line
 		end

feature {NONE} -- Implementation

 	m3u_location (a_relative_steps: like mp3_relative_path_steps; a_playlist_directory_prefix: EL_DIR_PATH): EL_FILE_PATH
 		do
 			if a_playlist_directory_prefix.is_empty then
	 			Result := a_relative_steps.as_file_path
	 		else
	 			Result := a_playlist_directory_prefix.joined_file_steps (a_relative_steps)
 			end
 		end

	normalized_mp3_base_path: EL_FILE_PATH
			-- normalized path <mp3_root_location>/<genre>/<artist>/<title>[<- vocalists>]
		do
			Result := mp3_root_location.joined_file_steps (normalized_path_steps)
		end

	normalized_path_steps: EL_PATH_STEPS
			-- normalized path steps <genre>,<artist>,<title>
		do
			Result := << genre, artist, title >>
			-- Remove problematic characters from last step of name
			across Problem_file_name_characters as problem_character loop
				if Result.last.has (problem_character.item) then
					String.subst_all_characters (Result.last, problem_character.item, '-')
				end
			end
		end

	unique_extension (base_path: EL_FILE_PATH): EL_FILE_PATH
			--
		local
			version: INTEGER
			next_version_found: BOOLEAN
		do
			from
				version := 1
			until
				next_version_found
			loop
				Result := versioned_file_path (base_path, version)
				next_version_found := not Result.exists
				version := version + 1
			end
		end

	versioned_file_path (base_path: EL_FILE_PATH; version: INTEGER): EL_FILE_PATH
			--
		local
			integer_string: FORMAT_INTEGER
		do
			create integer_string.make (2)
			integer_string.zero_fill
			Result := base_path.twin
			Result.add_extension (integer_string.formatted (version))
			Result.add_extension ("mp3")
		end

	main_fields_checksum: NATURAL
			--
		local
			crc_32: EL_CYCLIC_REDUNDANCY_CHECK_32
			l_picture_checksum: NATURAL
		do
			create crc_32
			crc_32.add_string (artists_list.comma_separated)
			crc_32.add_string (album)
			crc_32.add_string (title)
			crc_32.add_string (genre)
			crc_32.add_string (comment)
			crc_32.add_integer (recording_date)

			l_picture_checksum := album_picture_checksum
			if l_picture_checksum > 0 then
				crc_32.add_natural (l_picture_checksum)
			end

			Result := crc_32.checksum
		end

	is_padding (n: NATURAL_64): BOOLEAN
			-- True if all hexadecimal digits are the same
		local
			first, hex_digit: NATURAL_64
			i: INTEGER
		do
			first := n & 0xF
			hex_digit := first
			from i := 1 until hex_digit /= first or i > 15 loop
				hex_digit := n.bit_shift_right (i * 4) & 0xF
				i := i + 1
			end
			Result := i = 16 and then hex_digit = first
		end

	valid_ntfs_name (a_name: EL_ASTRING): EL_ASTRING
		local
			substitute_dots: EL_ASTRING
		do
			create substitute_dots.make_filled ('.', Invalid_chars_on_fat_or_ntfs.count)
			Result := a_name.translated (Invalid_chars_on_fat_or_ntfs, substitute_dots)
		end

	first_seen: INTEGER
		do
			Result := Time.unix_date_time (first_seen_time)
		end

	integer_fields: EL_ASTRING_HASH_TABLE [INTEGER]
		do
			create Result.make (<<
				["track-number", track_number],
				["disc-number", disc_number],
				["duration", duration],
				["bitrate", bitrate],
				["date", recording_date],
				["file-size", file_size],
				["mtime", mtime],
				["last-seen", last_seen],
				["first-seen", first_seen],
				["play-count", play_count],
				["last-played", last_played]
			>>)
		end

feature {NONE} -- Implementation: Attributes

	actual_track_id: NATURAL_64

feature {NONE} -- Build from XML

	building_action_table: like Type_building_actions
			--
		local
			mb_xpath: STRING
		do
			create Result.make (<<
				["artist/text()", 					agent do artist := node.to_string end],
				["album-artist/text()", 			agent do set_album_artists_list (node.to_string) end],
				["album/text()", 						agent do album := node.to_string end],
				["composer/text()", 					agent do set_composer (node.to_string) end],
				["comment/text()", 					agent do comment := node.to_string end],

				["track-number/text()", 			agent do track_number := node.to_integer end],
				["date/text()", 						agent do recording_date := node.to_integer end],
				["disc-number/text()", 				agent do disc_number := node.to_integer end],
				["beats-per-minute/text()", 		agent do beats_per_minute := node.to_integer end],
				["duration/text()", 					agent do duration := node.to_integer end],
				["bitrate/text()", 					agent do bitrate := node.to_integer end],
				["file-size/text()", 				agent do file_size := node.to_integer end],
				["first-seen/text()", 				agent do create first_seen_time.make_from_epoch (node.to_integer) end],
				["play-count/text()", 				agent do play_count := node.to_integer end],
				["last-played/text()", 				agent do last_played := node.to_integer end],

				["replaygain-track-gain/text()",	agent do gain := node.to_double end],
				["replaygain-track-peak/text()",	agent do peak := node.to_double end],
				["hidden/text()", 					agent do is_hidden := node.to_integer = 1 end]

			>>)
			Result.merge (Precursor)
			across Music_brainz_fields as name loop
				mb_xpath := "mb-" + name.item + "/text()"
				Result [mb_xpath] := agent (a_name: STRING) do music_brainz_info [a_name] := node.to_string end (name.item)
			end
		end

feature {NONE} -- Evolicity reflection

	get_music_brainz_info: like music_brainz_info
			--
		do
			create Result.make_with_count (music_brainz_info.count)
			Result.compare_objects
			Result.merge (music_brainz_info)
			Result.search (Field_artistsortname)
			if Result.found then
				Result [Field_artistsortname] := Xml.basic_escaped (Result.found_item)
			end
		end

	get_integer_fields: EL_ASTRING_HASH_TABLE [INTEGER_REF]
			-- Non zero integer fields
		do
			create Result.make_with_count (10)
			across integer_fields as field loop
				if field.item > 0 then
					Result.extend (field.item.to_reference, field.key)
				end
			end
		end

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["artists", 			agent: EL_ASTRING do Result := Xml.basic_escaped (artists_list.comma_separated) end],
				["artist", 				agent: EL_ASTRING do Result := Xml.basic_escaped (artist) end],
				["lead_artist", 		agent: EL_ASTRING do Result := Xml.basic_escaped (lead_artist) end],
				["album_artists", 	agent: EL_ASTRING do Result := Xml.basic_escaped (album_artists) end],
				["album", 				agent: EL_ASTRING do Result := Xml.basic_escaped (album) end],
				["composer", 			agent: EL_ASTRING do Result := Xml.basic_escaped (composer) end],
				["comment", 			agent: EL_ASTRING do Result := Xml.basic_escaped (comment) end],
				["track_id", 			agent: STRING do Result := track_id.to_hex_string end],

				["artist_list", 		agent: ITERABLE [EL_ASTRING] do Result := artists_list end],
				["integer_fields", 	agent get_integer_fields],
				["music_brainz_info",agent get_music_brainz_info],
				["duration_time", 	agent formatted_duration_time],

				["gain", 				agent: DOUBLE_REF do Result := gain.to_reference end],
				["peak", 				agent: DOUBLE_REF do Result := peak.to_reference end],

				["last_checksum", 	agent: NATURAL_32_REF do Result := last_checksum.to_reference end],

				["is_hidden", 			agent: BOOLEAN_REF do Result := is_hidden.to_reference end],
				["has_other_artists",agent: BOOLEAN_REF do Result := has_other_artists.to_reference end]
			>>)
		end

feature -- Constants

	Days_in_year: INTEGER = 365

	Template: STRING = "[
		<entry type="song">
			<title>$title</title>
			<genre>$genre</genre>
			<artist>$artist</artist>
			<album>$album</album>
			<location>$location_uri</location>
			#if not ($gain = 0.0) then
			<replaygain-track-gain>$gain</replaygain-track-gain>
			<replaygain-track-peak>$peak</replaygain-track-peak>
			#end
			<comment>$comment</comment>
			<album-artist>$album_artists</album-artist>
			<media-type>audio/mpeg</media-type>
		#across $music_brainz_info as $field loop
			<mb-$field.key>$field.item</mb-$field.key>
		#end
		#across $integer_fields as $field loop
			<$field.key>$field.item</$field.key>
		#end
		
			#if $is_hidden then
			<hidden>1</hidden>
			#end
		</entry>
	]"
--			<composer>$composer</composer>

	Music_brainz_fields: ARRAY [STRING]
		once
			Result := << "trackid", "artistid", "albumid", "albumartistid", "artistsortname" >>
			Result.compare_objects
		end

	Field_artistsortname: STRING = "artistsortname"

	Playlist_template: EL_SUBSTITUTION_TEMPLATE [EL_ASTRING]
		once
			create Result.make (Rhythmbox.Playlist_template)
		end

	Invalid_chars_on_fat_or_ntfs: EL_ASTRING
		once
			Result := "/?<>\:*|%""
		end

	Empty_string: EL_ASTRING
		once
			create Result.make_empty
		end

	Unknown_string: EL_ASTRING
		once
			Result := "Unknown"
		end

	Album_artist_prefix_list: ARRAY [EL_ASTRING]
			-- Field headings in ID3 'c0' comment, used to indicate other artists
		local
			l_result: ARRAYED_LIST [EL_ASTRING]
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

	Format_double_digit: FORMAT_INTEGER
		once
			create Result.make (2)
			Result.zero_fill
		end

	Problem_file_name_characters: ARRAY [CHARACTER]
		once
			Result := << '\', '/' >>
		end

end
