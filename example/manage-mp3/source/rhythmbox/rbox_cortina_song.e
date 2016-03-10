note
	description: "Summary description for {RBOX_CORTINA_SONG}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	RBOX_CORTINA_SONG

inherit
	RBOX_SONG
		rename
			make as make_song
		end

create
	make

feature {NONE} -- Initialization

	make (
		a_mp3_root_location: like mp3_root_location; a_full_length_song: RBOX_SONG
		tanda_genre: EL_ASTRING; a_track_number, a_duration, tanda_count: INTEGER
	)
			--
		local
			file_name: EL_ASTRING
		do
			make_song (a_mp3_root_location)
			full_length_song := a_full_length_song
			track_number := a_track_number
			duration := a_duration

			if track_number = tanda_count then
				title := "--- THE END ---"
				duration := duration * 4
			else
				title := String.template ("--- Tanda $S: $S ---").substituted (<< Double_digits.formatted (track_number), tanda_genre >>)
			end
			file_name := title + ".mp3"; file_name.prune_all (':')
			artist := full_length_song.artist
			genre := Rhythmbox.Genre_cortina

			mp3_path := mp3_root_location.joined_file_steps (<< genre, artist, file_name >>)

			album := full_length_song.album
		end

feature -- Access

	full_length_song: RBOX_SONG

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
			create clip_saver.make (full_length_song.mp3_path, wav_path)
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

	Double_digits: FORMAT_INTEGER
		once
			create Result.make (2)
			Result.zero_fill
		end
end
