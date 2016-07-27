note
	description: "Summary description for {EL_CPU_INFO_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-06-22 17:31:14 GMT (Wednesday 22nd June 2016)"
	revision: "5"

deferred class
	EL_AUDIO_PROPERTIES_COMMAND_I

inherit
	EL_SINGLE_PATH_OPERAND_COMMAND_I
		rename
			path as file_path
		export
			{NONE} all
		redefine
			make, make_default, file_path, getter_function_table, on_error, var_name_path
		end

	EL_AVCONV_OS_COMMAND_I
		undefine
			make_default
		redefine
			getter_function_table, on_error
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		end

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			create duration.make_by_seconds (0)
			Precursor {EL_SINGLE_PATH_OPERAND_COMMAND_I}
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

	file_path: EL_FILE_PATH

feature {NONE} -- Implementation

	on_error
			-- Strangely the output goes into the error stream, so we parse the errors
		do
			do_with_lines (agent find_duration_tag, errors)
		end

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor {EL_SINGLE_PATH_OPERAND_COMMAND_I}
			Result.merge (Precursor {EL_AVCONV_OS_COMMAND_I})
		end

feature {NONE} -- Line states

	find_duration_tag (line: ZSTRING)
		local
			pos_duration, pos_comma: INTEGER
			time: TIME
		do
			pos_duration := line.substring_index (Duration_tag, 1)
			if pos_duration > 0 then
				pos_duration := pos_duration + Duration_tag.count + 1
				pos_comma := line.index_of (',', pos_duration)
				create time.make_from_string (line.to_latin_1.substring (pos_duration, pos_comma - 1), "hh24:[0]mi:[0]ss.ff2")
				duration := time.relative_duration (Time_zero)
				state := agent find_audio_tag
			end
		end

	find_audio_tag (line: ZSTRING)
		local
			fields: EL_ZSTRING_LIST; words: LIST [STRING]
		do
			if line.has_substring (Audio_tag) then
				create fields.make_with_separator (line, ',', True)
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
				state := agent final
			end
		end

feature {NONE} -- Constants

	Var_name_path: ZSTRING
		once
			Result := "file_path"
		end

	Audio_tag: ZSTRING
		once
			Result := "Audio:"
		end

	Duration_tag: ZSTRING
		once
			Result := "Duration:"
		end

	Time_zero: TIME
		once
			create Result.make_by_seconds (0)
		end

end