note
	description: "Summary description for {RBOX_CORTINA_SONG}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-17 19:26:11 GMT (Thursday 17th December 2015)"
	revision: "6"

class
	RBOX_CORTINA_SONG

inherit
	RBOX_SONG
		rename
			make as make_song
		end

	RHYTHMBOX_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (
		a_database: like database; a_source_song: RBOX_SONG
		tanda_type: ZSTRING; a_track_number, a_duration: INTEGER
	)
		do
			make_song (a_database)
			source_song := a_source_song; track_number := a_track_number; duration := a_duration
			if tanda_type ~ Tanda_type_the_end then
				title := Tanda_type_the_end
			else
				title := Title_template #$ ['A' + (track_number - 1), tanda_type.as_upper]
				title.append (create {ZSTRING}.make_filled ('_', 30 - title.count))
			end
			artist := source_song.artist
			genre := Genre_cortina
			mp3_path := mp3_root_location.joined_file_steps (<< genre, artist, title + ".mp3" >>)
			album := source_song.album
		end

feature -- Access

	source_song: RBOX_SONG

feature -- Basic operations

	write_clip (a_offset_secs: INTEGER; a_fade_in_duration, a_fade_out_duration: REAL)
			-- Write clip from full length song at offset with fade in and fade out
		local
			clip_saver: EL_MP3_TO_WAV_CLIP_SAVER_COMMAND
			convertor: EL_WAV_TO_MP3_COMMAND; fader: EL_WAV_FADER
			wav_path, faded_wav_path: EL_FILE_PATH
			audio_properties: EL_AUDIO_PROPERTIES_COMMAND
		do
			wav_path := mp3_path.with_new_extension ("wav")
			faded_wav_path := mp3_path.with_new_extension ("faded.wav")

			-- Cutting
			create clip_saver.make (source_song.mp3_path, wav_path)
			clip_saver.set_duration (duration); clip_saver.set_offset (a_offset_secs)

			File_system.make_directory (mp3_path.parent)
			clip_saver.execute

			-- Fading
			create fader.make (wav_path, faded_wav_path)
			fader.set_duration (duration)
			fader.set_fade_in (a_fade_in_duration)
			fader.set_fade_out (a_fade_out_duration)
			fader.execute
			File_system.delete (wav_path)

			-- Compressing
			create convertor.make (faded_wav_path, mp3_path)
			create audio_properties.make (mp3_path)
			convertor.set_bit_rate_per_channel (audio_properties.bit_rate)
			convertor.execute
			File_system.delete (faded_wav_path)

			write_id3_info (id3_info)
		end

feature {NONE} -- Constants

	Title_template: ZSTRING
		once
			Result := "%S. %S tanda "
		end

end
