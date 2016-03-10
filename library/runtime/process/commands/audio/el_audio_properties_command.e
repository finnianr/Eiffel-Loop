note
	description: "Summary description for {EL_CPU_INFO_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-06-28 17:08:55 GMT (Friday 28th June 2013)"
	revision: "2"

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
			make, Line_processing_enabled, do_with_output_lines, getter_function_table,
			file_redirection_operator
		end

	EL_PLAIN_TEXT_LINE_STATE_MACHINE

create
	make

feature {NONE} -- Initialization

	make (a_file_path: like file_path)
			--
		require else
			is_file_path: a_file_path.is_file
		do
			create duration.make_by_compact_time (0)
			Precursor (a_file_path)
			execute
		end

feature -- Access

	bit_rate: INTEGER
		-- kbps

	sampling_frequency: INTEGER
		-- Hz

	duration: TIME

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

	file_redirection_operator: STRING
		do
			create Result.make_from_string (" 2>> ")
		end

feature {NONE} -- Line states

	find_duration_tag (line: EL_ASTRING)
		local
			pos_duration, pos_comma: INTEGER
		do
			pos_duration := line.substring_index (Duration_tag, 1)
			if pos_duration > 0 then
				pos_duration := pos_duration + Duration_tag.count + 1
				pos_comma := line.index_of (',', pos_duration)
				create duration.make_from_string (line.to_latin1.substring (pos_duration, pos_comma - 1), "hh24:[0]mi:[0]ss.ff2")
				state := agent find_audio_tag
			end
		end

	find_audio_tag (line: EL_ASTRING)
		local
			parts: LIST [EL_ASTRING]
		do
			if line.has_substring (Audio_tag) then
				across String.delimited_list (line.split (':').last, ", ") as properties loop
					parts := properties.item.split (' ')
					if parts.count = 2 then
						if parts.last.is_equal ("kb/s") then
							bit_rate := parts.first.to_integer
						elseif parts.last.is_equal ("Hz") then
							sampling_frequency := parts.first.to_integer
						end
					end
				end
				state := agent final
			end
		end

feature {NONE} -- Constants

	Audio_tag: EL_ASTRING
		once
			Result := "Audio:"
		end

	Duration_tag: EL_ASTRING
		once
			Result := "Duration:"
		end

end
