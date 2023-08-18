note
	description: "Audio properties command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-17 15:07:38 GMT (Thursday 17th August 2023)"
	revision: "18"

deferred class
	EL_AUDIO_PROPERTIES_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as file_path
		export
			{NONE} all
		redefine
			make, make_default, file_path, getter_function_table, on_error
		end

	EL_AVCONV_OS_COMMAND_I
		redefine
			on_error
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			is_equal
		end

	EL_ZSTRING_CONSTANTS; EL_CHARACTER_32_CONSTANTS

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			create duration.make_by_seconds (0)
			Precursor
		end

	make (a_file_path: like file_path)
			--
		do
			Precursor (a_file_path)
			execute
		end

feature -- Access

	bit_rate: INTEGER
		-- kbps

	standard_bit_rate: INTEGER
			-- nearest standard bit rate: 64, 128, 192, 256, 320
		do
			Result := (bit_rate / 64).rounded * 64
		end

	sampling_frequency: INTEGER
		-- Hz

	duration: TIME_DURATION

	file_path: FILE_PATH

feature {NONE} -- Implementation

	on_error (description: EL_ERROR_DESCRIPTION)
			-- Strangely the output goes into the error stream, so we parse the errors
		do
			do_with_lines (agent find_duration_tag, description)
		end

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor + command_name_assignment
		end

feature {NONE} -- Line states

	find_duration_tag (line: ZSTRING)
		local
			start_index: INTEGER; time: EL_TIME; time_string: ZSTRING
		do
			start_index := line.substring_right_index (Tag.duration, 1)
			if start_index > 0 then
				time_string := line.substring_between (space * 1, comma * 1, start_index)
				create time.make_with_format (time_string, "hh:[0]mi:[0]ss.ff2")
				create duration.make_by_fine_seconds (time.fine_seconds)
				state := agent find_audio_tag
			end
		end

	find_audio_tag (line: ZSTRING)
		local
			fields: EL_ZSTRING_LIST; words: LIST [STRING]
		do
			if line.has_substring (Tag.audio) then
				create fields.make_comma_split (line)
				across fields as field loop
					words := field.item.to_string_8.split (' ')
					if words.count = 2 then
						if words.last ~ once "kb/s" then
							bit_rate := words.first.to_integer
						elseif words.last ~ once "Hz" then
							sampling_frequency := words.first.to_integer
						end
					end
				end
				state := final
			end
		end

feature {NONE} -- Constants

	Tag: TUPLE [audio, duration: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "Audio:, Duration:")
		end

end