note
	description: "Rbox test database"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-22 14:57:46 GMT (Friday 22nd May 2020)"
	revision: "21"

class
	RBOX_TEST_DATABASE

inherit
	RBOX_DATABASE
		export
			{EQA_TEST_SET} make
		redefine
			new_cortina, new_song, extend_with_song, expanded_file_uri, shortened_file_uri
		end

	EL_MODULE_AUDIO_COMMAND

	EL_PROTOCOL_CONSTANTS
		export
			{NONE} all
		end

create
	make

feature -- Element change

	extend_with_song (song: RBOX_SONG)
		do
			if song.duration > 10 then
				song.set_duration (song.duration // 10)
			end
			if not song.is_hidden and then not song.mp3_path.exists then
				File_system.make_directory (song.mp3_path.parent)
				OS.copy_file (cached_song_file_path (song), song.mp3_path)
			end
			Precursor (song)
		end

feature -- Factory

	new_song: RBOX_TEST_SONG
		do
			create Result.make
		end

	new_cortina (
		a_source_song: RBOX_SONG; a_tanda_type: ZSTRING; a_track_number, a_duration: INTEGER
	): RBOX_CORTINA_TEST_SONG
		do
			create Result.make (a_source_song, a_tanda_type, a_track_number, a_duration)
		end

feature {RBOX_IRADIO_ENTRY} -- Implementation

	expanded_file_uri (a_uri: ZSTRING): ZSTRING
		do
			Result := a_uri.twin
			Result.replace_substring_all (Var_music, music_dir.to_string)
		end

	shortened_file_uri (a_uri: STRING): STRING
		do
			Result := a_uri.twin
			Result.replace_substring_all (Encoded_music_dir, Var_music.to_latin_1)
		end

feature {EQA_TEST_SET} -- Access

	cached_song_file_path (song: RBOX_SONG): EL_FILE_PATH
		local
			relative_path: EL_PATH_STEPS
		do
			relative_path := song.mp3_path.relative_path (music_dir)
			relative_path.put_front ("test-mp3")
			Result := File_system.cached (relative_path, agent generate_mp3_file (song, ?))
		end

	generate_mp3_file (song: RBOX_SONG; mp3_path: EL_FILE_PATH)
			-- Path to auto generated mp3 file under build directory
		require
			valid_duration: song.duration > 0
		local
			mp3_writer: like Audio_command.new_wav_to_mp3
			temp_path, wav_path: EL_FILE_PATH; mp3_info: TL_MUSICBRAINZ_MPEG_FILE
			modification_time: DATE_TIME
		do
			temp_path := song.mp3_path
			modification_time := song.modification_time
			song.set_mp3_path (mp3_path)

			File_system.make_directory (mp3_path.parent)
			wav_path := mp3_path.with_new_extension ("wav")

			-- Create a unique Random wav file
			Test_wav_generator.set_output_file_path (wav_path)
			Test_wav_generator.set_frequency_lower (100 + (200 * Random.real_item).rounded)
			Random.forth
			Test_wav_generator.set_frequency_upper (600  + (600 * Random.real_item).rounded)
			Random.forth
			Test_wav_generator.set_cycles_per_sec ((1.0 + Random.real_item.to_double).truncated_to_real)
			Random.forth

			if song.duration > 0 then
				Test_wav_generator.set_duration (song.duration)
			end
			Test_wav_generator.execute

			mp3_writer := Audio_command.new_wav_to_mp3 (wav_path, mp3_path)
			mp3_writer.set_bit_rate_per_channel (48)
			mp3_writer.set_num_channels (1)
			mp3_writer.execute
			File_system.remove_file (wav_path)

			song.update_file_info

			create mp3_info.make (mp3_path)
			song.write_id3_info (mp3_info)
			mp3_info.dispose

			song.set_modification_time (modification_time)
			File_system.set_file_modification_time (mp3_path, song.mtime)
			song.set_mp3_path (temp_path)
		ensure
			file_exists: mp3_path.exists
			song_path_unchange: old song.mp3_path ~ song.mp3_path
		end

	update_mp3_root_location
		do
		end

feature {NONE} -- Constants

	Var_music: ZSTRING
		once
			Result := "$MUSIC"
		end

	Encoded_music_dir: STRING
		once
			Encoded_location.set_from_string (music_dir)
			create Result.make_from_string (Encoded_location)
		end

	Test_wav_generator: EL_WAV_GENERATION_COMMAND_I
		once
			create {EL_WAV_GENERATION_COMMAND_IMP} Result.make ("")
		end

	Random: RANDOM
		once
			create Result.make
		end

end
