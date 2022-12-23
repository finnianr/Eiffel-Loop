note
	description: "[
		Fields mapping to Rhythmbox XML song data
		
		**Example Entry**
		
			<entry type="song">
				<title>L'Autre Valse d'Am&#xE9;lie</title>
				<genre>Vals (Modern)</genre>
				<artist>Yann Tiersen</artist>
				<album>Le Fabuleux Destin d'Am&#xE9;lie Poulain</album>
				<comment>Composer: Yann Tiersen</comment>
				<album-artist>Composer: Yann Tiersen</album-artist>
				<track-number>6</track-number>
				<duration>93</duration>
				<file-size>2244105</file-size>
				<location>file://$MUSIC/Vals%20(Modern)/Yann%20Tiersen/L'Autre%20Valse%20d'Am%C3%A9lie.02.mp3</location>
				<mtime>1335094508</mtime>
				<first-seen>1358180915</first-seen>
				<last-seen>1382259840</last-seen>
				<bitrate>192</bitrate>
				<date>730486</date>
				<media-type>audio/mpeg</media-type>
				<mb-trackid>CF22F4A6:D9D3:B4A6:674B:3866B6129A3C</mb-trackid>
				<mb-artistsortname>Tiersen, Yann</mb-artistsortname>
				<composer>Yann Tiersen</composer>
			</entry>
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-23 17:10:43 GMT (Friday 23rd December 2022)"
	revision: "9"

deferred class
	RBOX_SONG_FIELDS

feature -- Access

	album_picture_checksum: NATURAL
		do
			if mb_albumid.is_natural then
				Result := mb_albumid.to_natural
			end
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

	last_seen_time: DATE_TIME
		do
			create Result.make_from_epoch (last_seen)
		end

	modification_time: DATE_TIME
		do
			create Result.make_from_epoch (mtime)
		end

feature -- Rhythmbox XML fields

	album_artist: ZSTRING

	bitrate: INTEGER

	comment: ZSTRING

	disc_number: INTEGER

	duration: INTEGER

	file_size: INTEGER

	first_seen: INTEGER

	last_played: INTEGER

	last_seen: INTEGER

	mb_albumartistid: ZSTRING

	mb_albumid: ZSTRING

	mb_artistid: ZSTRING

	mb_artistsortname: ZSTRING

	mtime: INTEGER
		-- Combination of file modification time and file size
		--
		-- rhythmdb.c
		-- /* compare modification time and size to the values in the Database.
		--  * if either has changed, we'll re-read the file.
		--  */
		-- new_mtime = g_file_info_get_attribute_uint64 (event->file_info, G_FILE_ATTRIBUTE_TIME_MODIFIED);
		-- new_size = g_file_info_get_attribute_uint64 (event->file_info, G_FILE_ATTRIBUTE_STANDARD_SIZE);
		-- if (entry->mtime == new_mtime && (new_size == 0 || entry->file_size == new_size)) {
		-- 	rb_debug ("not modified: %s", rb_refstring_get (event->real_uri));
		-- } else {
		-- 	rb_debug ("changed: %s", rb_refstring_get (event->real_uri));

	play_count: INTEGER

	replaygain_album_gain: DOUBLE

	replaygain_album_peak: DOUBLE

	replaygain_track_gain: DOUBLE

	replaygain_track_peak: DOUBLE

	track_number: INTEGER

	beats_per_minute: INTEGER
		-- If beats per minute <= 3 it indicates silence duration appended to playlist

	composer: ZSTRING

feature -- Element change

	set_album_picture_checksum (picture_checksum: NATURAL)
			-- Set this if album art changes to affect the main checksum
		do
			mb_albumid := picture_checksum.out
		end

	set_beats_per_minute (a_beats_per_minute: like beats_per_minute)
			--
		do
			beats_per_minute := a_beats_per_minute
		end

	set_bitrate (a_bitrate: like bitrate)
			--
		do
			bitrate := a_bitrate
		end

	set_comment (a_comment: like comment)
			--
		do
			comment := a_comment
		end

	set_composer (a_composer: like composer)
			--
		do
			Composer_set.put (a_composer)
			composer := Composer_set.found_item
		end

	set_duration (a_duration: like duration)
		do
			duration := a_duration
		end

	set_last_seen_time (a_last_seen_time: DATE_TIME)
		local
			time: EL_TIME_ROUTINES
		do
			last_seen := time.unix_date_time (a_last_seen_time)
		end

	set_modification_time (a_modification_time: DATE_TIME)
		local
			time: EL_TIME_ROUTINES
		do
			mtime := time.unix_date_time (a_modification_time)
		end

	set_track_number (a_track_number: like track_number)
		do
			track_number := a_track_number
		end

feature {NONE} -- Implementation

	node: EL_DOCUMENT_NODE_STRING
		deferred
		end

feature {NONE} -- Constants

	Composer_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (100)
		end

end