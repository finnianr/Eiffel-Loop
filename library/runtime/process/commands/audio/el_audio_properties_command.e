note
	description: "Summary description for {EL_CPU_INFO_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-12-16 17:30:45 GMT (Wednesday 16th December 2015)"
	revision: "5"

class
	EL_AUDIO_PROPERTIES_COMMAND

inherit
	EL_SINGLE_OPERAND_FILE_SYSTEM_COMMAND [EL_AUDIO_PROPERTIES_COMMAND_IMPL]
		rename
			path as file_path,
			do_with_lines as do_with_output_lines
		export
			{NONE} all
		redefine
			make_default, make, Line_processing_enabled, do_with_output_lines, getter_function_table,
			file_redirection_operator
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE
		rename
			make as make_machine
		undefine
			default_create
		end

create
	make

feature {NONE} -- Initialization

	make_default
		do
			make_machine
			Precursor
		end

	make (a_file_path: like file_path)
			--
		require else
			is_file_path: a_file_path.is_file
		do
			create duration.make_by_seconds (0)
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

feature {NONE} -- Implementation

	do_with_output_lines (lines: EL_FILE_LINE_SOURCE)
			--
		do
			do_with_lines (agent find_duration_tag, lines)
		end

	getter_function_table: like getter_functions
			--
		do
			Result := Precursor
			Result.replace_key ("file_path", "path")
		end

	Line_processing_enabled: BOOLEAN = true

	file_redirection_operator: ZSTRING
		do
			Result := " 2>> "
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
