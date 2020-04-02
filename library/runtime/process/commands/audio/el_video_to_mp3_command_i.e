note
	description: "Video to mp3 command interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-01 13:33:16 GMT (Wednesday 1st April 2020)"
	revision: "6"

deferred class
	EL_VIDEO_TO_MP3_COMMAND_I

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
		do
			bit_rate := 128
			create duration.make_by_seconds (0)
			create offset_time.make_by_compact_time (0)
			Precursor {EL_FILE_CONVERSION_COMMAND_I}
		end

feature -- Access

	formatted_duration: STRING
		local
			time: TIME
		do
			create time.make_by_fine_seconds (duration.fine_seconds_count)
			Result := time.formatted_out (Duration_format)
		end

	bit_rate: INTEGER

	duration: TIME_DURATION

	offset_time: TIME

feature -- Element change

	set_duration (a_duration: like duration)
		do
			duration := a_duration
		end

	set_offset_time (a_offset_time: like offset_time)
		do
			offset_time := a_offset_time
		end

	set_bit_rate (a_bit_rate: like bit_rate)
		do
			bit_rate := a_bit_rate
		end

feature -- Status query

	has_duration: BOOLEAN
		do
			Result := duration.fine_seconds_count > 0.1
		end

	has_offset_time: BOOLEAN
		do
			Result := offset_time.compact_time > 0
		end

feature -- Contract Support

	valid_input_extension (extension: ZSTRING): BOOLEAN
		do
			Result := Video_extensions.has (extension)
		end

	valid_output_extension (extension: ZSTRING): BOOLEAN
		do
			Result := extension ~ File_extension_mp3
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor {EL_FILE_CONVERSION_COMMAND_I} +
				["bit_rate", 				agent bit_rate] +
				["duration", 				agent formatted_duration] +
				["has_duration",			agent: BOOLEAN_REF do Result := has_duration.to_reference end] +
				["has_offset_time",		agent: BOOLEAN_REF do Result := has_offset_time.to_reference end] +
				["offset_time", 			agent: STRING do Result := offset_time.formatted_out (Duration_format) end]

			Result.merge (Precursor {EL_AVCONV_OS_COMMAND_I})
		end

feature -- Constants

	Duration_format: STRING = "hh:[0]mi:[0]ss.ff3"

end
