note
	description: "Audio command test set"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-03-10 17:33:46 GMT (Friday 10th March 2023)"
	revision: "15"

class
	AUDIO_COMMAND_TEST_SET

inherit
	EL_FILE_DATA_TEST_SET

	EL_MODULE_AUDIO_COMMAND

	EL_MODULE_CONSOLE

create
	make

feature {NONE} -- Initialization

	make
		-- initialize `test_table'
		do
			make_named (<<
				["mp3_audio", agent test_mp3_audio]
			>>)
		end

feature -- Tests

	test_mp3_audio
		local
			generation_cmd: like Audio_command.new_wave_generation
			mp3_cmd: like Audio_command.new_wav_to_mp3
			properties_cmd: like Audio_command.new_audio_properties
			mp3: TL_MPEG_FILE
		do
			if {PLATFORM}.is_unix then
				generation_cmd := Audio_command.new_wave_generation (Mp3_file_path.with_new_extension ("wav"))
				generation_cmd.set_duration (20)
				generation_cmd.execute

				mp3_cmd := Audio_command.new_wav_to_mp3 (Mp3_file_path.with_new_extension ("wav"), Mp3_file_path)
				mp3_cmd.set_album (Id3_album)
				mp3_cmd.set_artist (Id3_artist)
				mp3_cmd.set_title (Id3_title)
				mp3_cmd.execute

				create mp3.make (Mp3_file_path)
				assert ("same album", Id3_album.same_string_general (mp3.tag.album))
				assert ("same artist", Id3_artist.same_string_general (mp3.tag.artist))

				assert ("UTF-8 code page", Console.code_page ~ "UTF-8")
				assert ("same title", Id3_title.same_string_general (mp3.tag.title))

				properties_cmd := Audio_command.new_audio_properties (Mp3_file_path)
				assert ("valid bitrate", properties_cmd.bit_rate = 128)
				assert ("valid sampling frequency", properties_cmd.sampling_frequency = 22050)
				assert ("valid duration", properties_cmd.duration.seconds_count = 20)
			end
		end

feature {NONE} -- Constants

	Id3_album: STRING = "Poema"

	Id3_artist: STRING = "Franciso Canaro"

	Id3_title: STRING = "La Copla Porte�a"

	Mp3_file_path: FILE_PATH
		once
			Result := Work_area_dir + (Id3_title + ".mp3")
		end

end