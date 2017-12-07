note
	description: "Summary description for {EL_MP3_TO_WAV_CLIP_SAVER_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-02 9:33:37 GMT (Saturday 2nd December 2017)"
	revision: "3"

deferred class
	EL_MP3_TO_WAV_CLIP_SAVER_COMMAND_I

inherit
	EL_FILE_CONVERSION_COMMAND_I
		redefine
			make_default, getter_function_table, valid_input_extension, valid_output_extension
		end

	EL_AVCONV_OS_COMMAND_I
		undefine
			make_default
		redefine
			getter_function_table
		end

	EL_MULTIMEDIA_CONSTANTS

feature {NONE} -- Initialization

	make_default
			--
		do
			log_level := "quiet"
			Precursor {EL_FILE_CONVERSION_COMMAND_I}
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

feature -- Contract Support

	valid_input_extension (extension: ZSTRING): BOOLEAN
		do
			Result := extension ~ File_extension_mp3
		end

	valid_output_extension (extension: ZSTRING): BOOLEAN
		do
			Result := extension ~ File_extension_wav
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor {EL_FILE_CONVERSION_COMMAND_I} +
				["log_level",			 agent: STRING do Result := log_level end] +
				["offset", 				 agent: INTEGER_REF do Result := offset.to_reference end] +
				["duration", 			 agent: INTEGER_REF do Result := duration.to_reference end]
			Result.merge (Precursor {EL_AVCONV_OS_COMMAND_I})
		end

end
