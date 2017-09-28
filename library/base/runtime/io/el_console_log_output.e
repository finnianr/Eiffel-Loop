note
	description: "Summary description for {EL_CONSOLE_LOG_OUTPUT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-08-18 12:21:52 GMT (Friday 18th August 2017)"
	revision: "4"

class
	EL_CONSOLE_LOG_OUTPUT

inherit
	EL_MODULE_ENVIRONMENT

	EL_CONSOLE_ENCODEABLE

create
	make

feature -- Initialization

	make
		do
			create buffer.make (80)
			create string_pool.make (80)
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
		local
			str_32: STRING_32
		do
			str_32 := string_pool.new_string
			str_32.append_boolean (b)
			buffer.extend (str_32)
		end

	put_character (c: CHARACTER)
			--
		local
			str_32: STRING_32
		do
			str_32 := string_pool.new_string
			str_32.append_character (c)
			buffer.extend (str_32)
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
		local
			str_32: STRING_32
		do
			str_32 := string_pool.new_string
			str_32.append_double (d)
			buffer.extend (str_32)
		end

	put_integer (i: INTEGER)
			-- Add a string to the buffer
		local
			str_32: STRING_32
		do
			str_32 := string_pool.new_string
			str_32.append_integer (i)
			buffer.extend (str_32)
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
		local
			str_32: STRING_32
		do
			from lines.start until lines.off loop
				str_32 := string_pool.new_string; lines.item.append_to_string_32 (str_32)
				set_text_brown
				buffer.extend (str_32)
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
		local
			str_32: STRING_32
		do
			str_32 := string_pool.new_string
			str_32.append_real (r)
			buffer.extend (str_32)
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
		local
			str_32: STRING_32
		do
			if attached {STRING_8} s as str_8 then
				buffer.extend (str_8)
			else
				str_32 := string_pool.new_string
				if attached {ZSTRING} s as str_z then
					str_z.append_to_string_32 (str_32)
				else
					str_32.append_string_general (s)
				end
				buffer.extend (str_32)
			end
		end

feature -- Basic operations

	flush
			-- Write contents of buffer to file if it is free (not locked by another thread)
			-- Return strings of type {EL_ZSTRING} to recyle pool
		do
			buffer.do_all (agent flush_string_general)
			buffer.wipe_out
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
		do
			if attached {STRING_32} str as str_32 then
				write_console (str_32)
				string_pool.recycle (str_32)

			elseif attached {STRING_8} str as str_8 then
				flush_string_8 (str_8)
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

feature {NONE} -- Internal attributes

	buffer: ARRAYED_LIST [READABLE_STRING_GENERAL]

	new_line_prompt: STRING

	std_output: PLAIN_TEXT_FILE

	string_pool: EL_STRING_POOL [STRING_32]
		-- recycled strings

	tab_repeat_count: INTEGER

feature -- Constants

	Line_separator: STRING
		once
			create Result.make_filled ('-', 100)
		end

	Tab_string: STRING = "  "

	Tail_character_count : INTEGER = 1500

end
