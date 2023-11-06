note
	description: "Highlighted console log output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-06 16:29:34 GMT (Monday 6th November 2023)"
	revision: "13"

class
	EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_CONSOLE_LOG_OUTPUT
		redefine
			clear, flush_string_8, move_cursor_up, set_text_color, set_text_color_light
		end

create
	make

feature {NONE} -- Implementation

	buffer_color_sequence (code: INTEGER; light: BOOLEAN)
		do
			if attached extended_buffer_last (26) as sequence then
				sequence.append (Escape_start) -- 2
				if code = 0 then
					sequence.append_integer (code)
				else
					sequence.append_integer (light.to_integer) -- 11
					sequence.append_character (';') -- 1
					sequence.append_integer (code) -- 11
				end
				sequence.append_character ('m') -- 1
			end
		end

	clear
		do
			if attached extended_buffer_last (12) as sequence then
				across Clear_codes as code loop
					sequence.append (Escape_start) -- 2 x 2
					sequence.append (code.item) -- 4 x 2
				end
			end
		end

	flush_string_8 (str_8: READABLE_STRING_8)
		do
			if is_escape_sequence (str_8) then
				write_escape_sequence (str_8)
			else
				write_console (str_8)
			end
		end

	move_cursor_up (n: INTEGER)
		-- move cursor up `n' lines (Linux only)
		do
			if attached extended_buffer_last (14) as sequence then
				sequence.append (Escape_start) -- 2
				sequence.append_integer (n) -- 11
				sequence.append_character ('A') -- 1
			end
		end

	is_escape_sequence (seq: READABLE_STRING_8): BOOLEAN
		local
			count: INTEGER
		do
			if seq.starts_with (Escape_start) then
				count := seq.count
				Result := count >= 4 and then seq.item (3).is_digit and then seq [count] = 'm'
			end
		end

	set_text_color (code: INTEGER)
		do
			buffer_color_sequence (code, False)
		end

	set_text_color_light (code: INTEGER)
		do
			buffer_color_sequence (code, True)
		end

	write_escape_sequence (seq: STRING_8)
		do
			std_output.put_string (seq)
		end

feature {NONE} -- Constants

	Clear_codes: ARRAY [STRING]
		once
			Result := << "1;1H", "2J" >>
		end

	Escape_start: STRING = "%/027/["
end