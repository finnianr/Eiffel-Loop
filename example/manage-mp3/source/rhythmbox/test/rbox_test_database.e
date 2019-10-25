note
	description: "Rbox test database"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-08 15:20:30 GMT (Tuesday   8th   October   2019)"
	revision: "8"

class
	RBOX_TEST_DATABASE

inherit
	RBOX_DATABASE
		redefine
			add_song_entry, new_cortina, new_song, extend_with_song,
			decoded_location, encoded_location_uri
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
			song.set_modification_time (Test_time)
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

feature {RBOX_IRADIO_ENTRY} -- location codecs

	decoded_location (a_path: STRING): EL_FILE_PATH
		local
			path: ZSTRING
		do
			path := Precursor (a_path)
			path.replace_substring_all (Var_music, music_dir.to_string)
			Result := path
		end

	encoded_location_uri (uri: EL_FILE_URI_PATH): STRING
		do
			Result := Precursor (uri)
			Result.replace_substring_all (Encoded_music_dir, Var_music.to_latin_1)
		end

feature {NONE} -- Build from XML

	add_song_entry
			--
		do
			set_next_context (new_song)
		end

feature {TEST_MANAGEMENT_TASK} -- Access

	cached_song_file_path (song: RBOX_SONG): EL_FILE_PATH
			-- Path to auto generated mp3 file under build directory
		require
			valid_duration: song.duration > 0
		local
			mp3_writer: like Audio_command.new_wav_to_mp3
			relative_path, wav_path: EL_FILE_PATH; l_id3_info: EL_ID3_INFO
		do
			relative_path := song.mp3_path.relative_path (music_dir)

			log.put_path_field ("Reading", relative_path)
			log.put_new_line

			Result := Directory.new_path ("build") + relative_path
			if not Result.exists then
				File_system.make_directory (Result.parent)
				wav_path := Result.with_new_extension ("wav")

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

				mp3_writer := Audio_command.new_wav_to_mp3 (wav_path, Result)
				mp3_writer.set_bit_rate_per_channel (48)
				mp3_writer.set_num_channels (1)
				mp3_writer.execute
				File_system.remove_file (wav_path)

				create l_id3_info.make (wav_path.with_new_extension ("mp3"))
				song.write_id3_info (l_id3_info)
			end
		ensure
			file_exists: Result.exists
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
		local
			uri: EL_DIR_URI_PATH
		once
			uri := music_dir
			Result := Url.encoded_uri_custom (uri, Unescaped_location_characters, False)
			Result.remove_head (File_protocol_prefix.count)
		end

	Test_wav_generator: EL_WAV_GENERATION_COMMAND_I
		once
			create {EL_WAV_GENERATION_COMMAND_IMP} Result.make ("")
		end

	Random: RANDOM
		once
			create Result.make
		end

	Test_time: DATE_TIME
		once
			create Result.make (2011, 11, 11, 11, 11, 11)
		end

end
