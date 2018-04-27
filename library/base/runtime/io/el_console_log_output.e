note
	description: "Summary description for {EL_CONSOLE_LOG_OUTPUT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-03-03 13:48:37 GMT (Saturday 3rd March 2018)"
	revision: "6"

class
	EL_CONSOLE_LOG_OUTPUT

inherit
	EL_MODULE_ENVIRONMENT

	EL_CONSOLE_ENCODEABLE

	EL_SHARED_UTF_8_ZCODEC

	EL_SHARED_ONCE_STRINGS

create
	make

feature -- Initialization

	make
		do
			create buffer.make (30)
			create string_pool.make (30)
			create recycle_buffer.make (30)
			create new_line_prompt.make_from_string ("%N")
			std_output := io.Output
		end

feature -- Element change

	restore (previous_stack_count: INTEGER)
			--
		do
			tab_repeat_count := previous_stack_count
		end

	tab (offset: INTEGER)
			--
		do
			tab_repeat_count := tab_repeat_count.item + offset
		end

	tab_left
			--
		do
			tab_repeat_count := tab_repeat_count.item - 1
		end

	tab_right
			--
		do
			tab_repeat_count := tab_repeat_count.item + 1
		end

feature -- Output

	put_boolean (b: BOOLEAN)
			--
		do
			extended_buffer_last.append_boolean (b)
		end

	put_character (c: CHARACTER)
			--
		do
			extended_buffer_last.append_character (c)
		end

	put_classname (a_name: STRING)
		require
			not_augmented_latin_string: not attached {ZSTRING} a_name
		do
			set_text_light_blue
			buffer.extend (a_name)
			set_text_default
		end

	put_double (d: DOUBLE)
			--
		do
			extended_buffer_last.append_double (d)
		end

	put_integer (i: INTEGER)
			-- Add a string to the buffer
		do
			extended_buffer_last.append_integer (i)
		end

	put_keyword (keyword: STRING)
		require
			not_augmented_latin_string: not attached {ZSTRING} keyword
		do
			set_text_red
			buffer.extend (keyword)
			set_text_default
		end

	put_label (a_name: READABLE_STRING_GENERAL)
		do
			set_text_purple
			put_string_general (a_name)
			set_text_default
			put_string (once ": ")
		end

	put_lines (lines: LIST [ZSTRING])
			--
		do
			from lines.start until lines.off loop
				set_text_brown
				buffer.extend (lines.item)
				set_text_default
				lines.forth
				if not lines.after then
					put_new_line
				end
			end
		end

	put_new_line
			-- Add a string to the buffer
		local
			i: INTEGER
		do
			buffer.extend (new_line_prompt)
			from
				i := 1
			until
				i > tab_repeat_count
			loop
				buffer.extend (Tab_string)
				i := i + 1
			end
		end

	put_quoted_string (a_str: READABLE_STRING_GENERAL)
		do
			set_text_brown
			put_string (once "%"")
			put_string_general (a_str)
			put_string (once "%"")
			set_text_default
		end

	put_real (r: REAL)
			--
		do
			extended_buffer_last.append_real (r)
		end

	put_separator
		do
			buffer.extend (Line_separator)
			put_new_line
		end

	put_string (s: STRING)
		do
			buffer.extend (s)
		end

	put_string_general (s: READABLE_STRING_GENERAL)
			--
		do
			buffer.extend (s)
		end

feature -- Basic operations

	flush
			-- Write contents of buffer to file if it is free (not locked by another thread)
			-- Return strings of type {STRING_32} to recyle pool
		do
			buffer.do_all (agent flush_string_general)
			buffer.wipe_out
			recycle_buffer.do_all (agent string_pool.recycle)
			recycle_buffer.wipe_out
		end

feature -- Change text output color

	set_text_blue
		do
		end

	set_text_brown
		do
		end

	set_text_dark_gray
		do
		end

	set_text_default
		do
		end

	set_text_light_blue
		do
		end

	set_text_light_cyan
		do
		end

	set_text_light_green
		do
		end

	set_text_purple
		do
		end

	set_text_red
		do
		end

feature {NONE} -- Implementation

	flush_string_general (str: READABLE_STRING_GENERAL)
		local
			string_32: STRING_32
		do
			if attached {ZSTRING} str as str_z then
				string_32 := empty_once_string_32
				str_z.append_to_string_32 (string_32)
				write_console (string_32)

			elseif attached {STRING_8} str as str_8 then
				flush_string_8 (str_8)

			elseif attached {STRING_32} str as str_32 then
				write_console (str_32)
			end
		end

	flush_string_8 (str_8: STRING_8)
		do
			write_console (str_8)
		end

	write_console (str: READABLE_STRING_GENERAL)
		do
			std_output.put_string (console_encoded (str))
		end

	extended_buffer_last: like string_pool.item
		do
			Result := string_pool.new_string
			recycle_buffer.extend (Result)
			buffer.extend (Result)
		end

feature {NONE} -- Internal attributes

	buffer: ARRAYED_LIST [READABLE_STRING_GENERAL]

	recycle_buffer: ARRAYED_LIST [like string_pool.item]
		-- strings for recycling back to pool

	new_line_prompt: STRING

	std_output: PLAIN_TEXT_FILE

	string_pool: EL_STRING_POOL [STRING]
		-- recycled strings

	tab_repeat_count: INTEGER

feature {NONE} -- Constants

	Line_separator: STRING
		once
			create Result.make_filled ('-', 100)
		end

	Tab_string: STRING = "  "

	Tail_character_count : INTEGER = 1500

end
