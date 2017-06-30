note
	description: "Summary description for {AUDIO_COMMAND_TEST_SET}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-06-14 10:25:30 GMT (Wednesday 14th June 2017)"
	revision: "2"

class
	AUDIO_COMMAND_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET
		rename
			new_file_tree as new_empty_file_tree
		end

	EL_MODULE_AUDIO_COMMAND
		undefine
			default_create
		end

	EL_EIFFEL_LOOP_TEST_CONSTANTS
		undefine
			default_create
		end

feature -- Tests

	test_mp3_audio
		local
			generation_cmd: like Audio_command.new_wave_generation
			mp3_cmd: like Audio_command.new_wav_to_mp3
			extract_cmd: like Audio_command.new_extract_mp3_info
			properties_cmd: like Audio_command.new_audio_properties
		do
			log.enter ("test_mp3_audio")
			if {PLATFORM}.is_unix then
				generation_cmd := Audio_command.new_wave_generation (Mp3_file_path.with_new_extension ("wav"))
				generation_cmd.set_duration (20)
				generation_cmd.execute

				mp3_cmd := Audio_command.new_wav_to_mp3 (Mp3_file_path.with_new_extension ("wav"), Mp3_file_path)
				mp3_cmd.set_album (Id3_album)
				mp3_cmd.set_artist (Id3_artist)
				mp3_cmd.set_title (Id3_title)
				mp3_cmd.execute

				extract_cmd := Audio_command.new_extract_mp3_info (Mp3_file_path)
				extract_cmd.execute
				assert ("same album", extract_cmd.fields.item ("album").same_string (Id3_album))
				assert ("same artist", extract_cmd.fields.item ("artist").same_string (Id3_artist))

--				If this assert fails, try setting the value for LANG in execution environment to UTF-8
				assert ("same title", extract_cmd.fields.item ("title").same_string (Id3_title))

				properties_cmd := Audio_command.new_audio_properties (Mp3_file_path)
				assert ("valid bitrate", properties_cmd.bit_rate = 128)
				assert ("valid sampling frequency", properties_cmd.sampling_frequency = 22050)
				assert ("valid duration", properties_cmd.duration.seconds_count = 20)
			end
			log.exit
		end

feature {NONE} -- Constants

	Mp3_file_path: EL_FILE_PATH
		once
			Result := Work_area_dir + (Id3_title + ".mp3")
		end

	Id3_album: STRING = "Poema"

	Id3_artist: STRING = "Franciso Canaro"

	Id3_title: STRING = "La Copla Porteña"

end
