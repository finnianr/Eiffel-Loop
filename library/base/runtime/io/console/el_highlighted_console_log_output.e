note
	description: "Highlighted console log output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-02-19 14:01:37 GMT (Wednesday 19th February 2020)"
	revision: "10"

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
		local
			sequence: STRING
		do
			sequence := extended_buffer_last
			sequence.append (Escape_start)
			if code = 0 then
				sequence.append_integer (code)
			else
				sequence.append_integer (light.to_integer)
				sequence.append_character (';')
				sequence.append_integer (code)
			end
			sequence.append_character ('m')
		end

	clear
		local
			sequence: STRING
		do
			sequence := extended_buffer_last
			across Clear_codes as code loop
				sequence.append (Escape_start)
				sequence.append (code.item)
			end
		end

	flush_string_8 (str_8: STRING_8)
		do
			if is_escape_sequence (str_8) then
				write_escape_sequence (str_8)
			else
				write_console (str_8)
			end
		end

	move_cursor_up (n: INTEGER)
		-- move cursor up `n' lines (Linux only)
		local
			sequence: STRING
		do
			sequence := extended_buffer_last
			sequence.append (Escape_start)
			sequence.append_integer (n)
			sequence.append_character ('A')
		end

	is_escape_sequence (seq: STRING_8): BOOLEAN
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
