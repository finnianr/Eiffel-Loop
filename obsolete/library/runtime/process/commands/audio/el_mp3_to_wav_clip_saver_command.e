note
	description: "Summary description for {EL_MP3_TO_WAV_CLIP_SAVER_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 7:24:08 GMT (Wednesday 16th December 2015)"
	revision: "1"

class
	EL_MP3_TO_WAV_CLIP_SAVER_COMMAND

inherit
	EL_DOUBLE_OPERAND_FILE_SYSTEM_OS_COMMAND [EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_IMPL]
		rename
			source_path as input_file_path,
			destination_path as output_file_path,

			set_source_path as set_input_file_path,
			set_destination_path as set_output_file_path,

			make as make_double_operand_command,

			Valid_extension as File_extension_mp3,
			Valid_destination_extension as File_extension_wav

		undefine
			File_extension_mp3, File_extension_wav
		redefine
			getter_function_table, output_file_path
		end

	EL_MULTIMEDIA_CONSTANTS
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make (a_source_path, a_destination_path: like input_file_path)
			--
		do
			make_double_operand_command (a_source_path, a_destination_path)
			log_level := "quiet"
		end

feature -- Element change

	set_offset (a_offset: like offset)
		do
			offset := a_offset
		end

	set_duration (a_duration: like duration)
		do
			duration := a_duration
		end

feature -- Access

	offset: INTEGER

	duration: INTEGER

	log_level: STRING

	output_file_path: EL_FILE_PATH

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["input_file_path",	 agent: ZSTRING do Result := escaped_path (input_file_path) end],
				["output_file_path",	 agent: ZSTRING do Result := escaped_path (output_file_path) end],
				["log_level",			 agent: STRING do Result := log_level end],
				["offset", 				 agent: INTEGER_REF do Result := offset.to_reference end],
				["duration", 			 agent: INTEGER_REF do Result := duration.to_reference end]
			>>)
		end

end