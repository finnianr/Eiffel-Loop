note
	description: "Summary description for {EL_MP3_CLIP_SAVER_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-14 9:20:34 GMT (Friday 14th June 2013)"
	revision: "2"

class
	EL_VIDEO_TO_MP3_COMMAND

inherit
	EL_WAV_TO_MP3_COMMAND
		rename
			is_valid_extension as is_valid_input_extension
		redefine
			make, implementation, getter_function_table, bit_rate, is_valid_input_extension
		end

create
	make

feature {NONE} -- Initialization

	make (a_source_path, a_destination_path: like input_file_path)
		do
			Precursor (a_source_path, a_destination_path)
			bit_rate := 128
			create duration.make_by_compact_time (0)
			create offset_time.make_by_compact_time (0)
		end

feature -- Access

	bit_rate: INTEGER

	duration: TIME

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
			Result := duration.fine_seconds > 0.1
		end

	has_offset_time: BOOLEAN
		do
			Result := offset_time.compact_time > 0
		end

feature -- Contract Support

	is_valid_input_extension (extension: EL_ASTRING): BOOLEAN
		do
			Result := Video_extensions.has (extension)
		end

feature {NONE} -- Evolicity reflection

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.append_tuples (<<
				["duration", 				agent: STRING do Result := duration.formatted_out (Duration_format) end],
				["has_duration",			agent: BOOLEAN_REF do Result := has_duration.to_reference end],
				["has_offset_time",		agent: BOOLEAN_REF do Result := has_offset_time.to_reference end],
				["offset_time", 			agent: STRING do Result := offset_time.formatted_out (Duration_format) end]
			>>)
		end

feature {NONE} -- Implementation

	implementation: EL_VIDEO_TO_MP3_COMMAND_IMPL

feature -- Constants

	Video_extensions: ARRAY [EL_ASTRING]
		once
			Result := << "flv", "mp4", "mov" >>
			Result.compare_objects
		end

	Duration_format: STRING = "hh:[0]mi:[0]ss.ff3"

end
