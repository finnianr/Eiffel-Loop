note
	description: "[
		Fields mapping to Rhythmbox XML song data
		
		**Example**
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
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-12 16:42:48 GMT (Sunday 12th April 2020)"
	revision: "3"

deferred class
	RBOX_SONG_FIELDS

feature -- Rhythmbox XML fields

	album: ZSTRING

	album_artist: ZSTRING

	artist: ZSTRING

	bitrate: INTEGER

	comment: ZSTRING

	date: INTEGER
		-- Recording date in days

	disc_number: INTEGER

	duration: INTEGER

	file_size: INTEGER

	first_seen: INTEGER

	last_played: INTEGER

	mb_albumartistid: ZSTRING

	mb_albumid: ZSTRING

	mb_artistid: ZSTRING

	mb_artistsortname: ZSTRING

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

	set_album (a_album: like album)
			--
		do
			Album_set.put (a_album)
			album := Album_set.found_item
		end

	set_album_picture_checksum (picture_checksum: NATURAL)
			-- Set this if album art changes to affect the main checksum
		do
			mb_albumid := picture_checksum.out
		end

	set_artist (a_artist: like artist)
			--
		do
			Artist_set.put (a_artist)
			artist := Artist_set.found_item
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

	set_recording_year (a_year: INTEGER)
		do
			date := a_year * Days_in_year
		end

	set_track_number (a_track_number: like track_number)
		do
			track_number := a_track_number
		end

feature {NONE} -- Implementation

	node: EL_XML_NODE
		deferred
		end

feature {NONE} -- Constants

	Album_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (100)
		end

	Artist_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (100)
		end

	Composer_set: EL_HASH_SET [ZSTRING]
		once
			create Result.make (100)
		end

	Days_in_year: INTEGER = 365

end
