note
	description: "Audio command factory  accessible via ${EL_MODULE_AUDIO_COMMAND}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "9"

class
	EL_AUDIO_COMMAND_FACTORY

feature -- Factory

	new_wave_generation (output_file_path: FILE_PATH): EL_WAV_GENERATION_COMMAND_I
		do
			create {EL_WAV_GENERATION_COMMAND_IMP} Result.make (output_file_path)
			-- make calls execute
		end

	new_wav_to_mp3 (input_file_path, output_file_path: FILE_PATH): EL_WAV_TO_MP3_COMMAND_I
		do
			create {EL_WAV_TO_MP3_COMMAND_IMP} Result.make (input_file_path, output_file_path)
		end

	new_extract_mp3_info (file_path: FILE_PATH): EL_EXTRACT_MP3_INFO_COMMAND_I
		do
			create {EL_EXTRACT_MP3_INFO_COMMAND_IMP} Result.make (file_path)
		end

	new_audio_properties (file_path: FILE_PATH): EL_AUDIO_PROPERTIES_COMMAND_I
		do
			create {EL_AUDIO_PROPERTIES_COMMAND_IMP} Result.make (file_path)
		end

	new_mp3_to_wav_clip_saver (input_file_path, output_file_path: FILE_PATH): EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_I
		do
			create {EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMP} Result.make (input_file_path, output_file_path)
		end

	new_wav_fader (input_file_path, output_file_path: FILE_PATH): EL_WAV_FADER_I
		do
			create {EL_WAV_FADER_IMP} Result.make (input_file_path, output_file_path)
		end
end