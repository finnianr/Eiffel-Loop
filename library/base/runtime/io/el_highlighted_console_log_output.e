note
	description: "Summary description for {EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-12-14 13:16:02 GMT (Wednesday 14th December 2016)"
	revision: "2"

class
	EL_HIGHLIGHTED_CONSOLE_LOG_OUTPUT

inherit
	EL_CONSOLE_LOG_OUTPUT
		redefine
			set_text_blue, set_text_brown, set_text_dark_gray, set_text_default, set_text_light_blue,
			set_text_light_cyan, set_text_light_green, set_text_purple, set_text_red,
			flush_string_8
		end

create
	make

feature {NONE} -- Implementation

	flush_string_8 (str_8: STRING_8)
		do
			if is_escape_sequence (str_8) then
				std_output.put_string (str_8)
			else
				write_console (str_8)
			end
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

	set_text_blue
		do
			buffer.extend (once "%/027/[0;34m")
		end

	set_text_brown
		do
			buffer.extend (once "%/027/[0;33m")
		end

	set_text_dark_gray
		do
			buffer.extend (once "%/027/[1;30m")
		end

	set_text_default
		do
			buffer.extend (once "%/027/[0m")
		end

	set_text_light_blue
		do
			buffer.extend (once "%/027/[1;34m")
		end

	set_text_light_cyan
		do
			buffer.extend (once "%/027/[1;36m")
		end

	set_text_light_green
		do
			buffer.extend (once "%/027/[1;32m")
		end

	set_text_purple
		do
			buffer.extend (once "%/027/[1;35m")
		end

	set_text_red
		do
			buffer.extend (once "%/027/[1;31m")
		end

feature {NONE} -- Constants

	Escape_start: STRING = "%/027/["
end
