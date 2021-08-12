note
	description: "Console log output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-12 13:49:53 GMT (Thursday 12th August 2021)"
	revision: "20"

class
	EL_CONSOLE_LOG_OUTPUT

inherit
	EL_MODULE_ENVIRONMENT

	EL_CONSOLE_ENCODEABLE

	EL_SHARED_UTF_8_ZCODEC

	EL_SHARED_CONSOLE_COLORS

create
	make

feature -- Initialization

	make
		do
			create buffer.make (30)
			create {EL_STRING_POOL [STRING]} string_pool.make
			string_pool.start_scope
			create recycle_buffer.make (30)
			create new_line_prompt.make_from_string ("%N")
			std_output := io.Output
		end

feature -- Status change

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

	set_text_color (code: INTEGER)
		require
			valid_code: valid_colors.has (code)
		do
		end

	set_text_color_light (code: INTEGER)
		require
			valid_code: valid_colors.has (code)
		do
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

	put_classname (a_name: IMMUTABLE_STRING_8)
		do
			set_text_color_light (Color.Blue)
			buffer.extend (a_name)
			set_text_color (Color.Default)
		end

	put_keyword (keyword: STRING)
		require
			not_augmented_latin_string: not attached {ZSTRING} keyword
		do
			set_text_color_light (Color.Red)
			buffer.extend (keyword)
			set_text_color (Color.Default)
		end

	put_label (a_name: READABLE_STRING_GENERAL)
		do
			set_text_color_light (Color.Purple)
			put_string_general (a_name)
			set_text_color (Color.Default)
			put_string (once ": ")
		end

	put_lines (lines: LIST [ZSTRING])
			--
		do
			from lines.start until lines.off loop
				set_text_color (Color.Yellow)
				buffer.extend (lines.item)
				set_text_color (Color.Default)
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

	put_quoted_string (a_str: READABLE_STRING_GENERAL; quote_mark: STRING)
		do
			set_text_color (Color.Yellow)
			put_string (quote_mark)
			put_string_general (a_str)
			put_string (quote_mark)
			set_text_color (Color.Default)
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

feature -- Numeric output

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

	put_natural (n: NATURAL)
		do
			extended_buffer_last.append_natural_32 (n)
		end

	put_real (r: REAL)
			--
		do
			extended_buffer_last.append_real (r)
		end

feature -- Basic operations

	clear
		do
		end

	move_cursor_up (n: INTEGER)
		-- move cursor up `n' lines (Linux only)
		do
		end

	flush
			-- Write contents of buffer to file if it is free (not locked by another thread)
			-- Return strings of type {STRING_32} to recyle pool
		do
			buffer.do_all (agent flush_string_general)
			buffer.wipe_out
			string_pool.reclaim (recycle_buffer)
			string_pool.end_scope
			string_pool.start_scope
		end

feature {NONE} -- Implementation

	extended_buffer_last: like string_pool.item
		do
			Result := string_pool.reuse_item
			recycle_buffer.extend (Result)
			buffer.extend (Result)
		end

	flush_string_8 (str_8: STRING_8)
		do
			write_console (str_8)
		end

	flush_string_general (str: READABLE_STRING_GENERAL)
		local
			str_32: STRING_32; buffer_32: EL_STRING_32_BUFFER_ROUTINES
		do
			if attached {ZSTRING} str as str_z then
				str_32 := buffer_32.empty
				str_z.append_to_string_32 (str_32)
				write_console (str_32)

			elseif attached {STRING_8} str as str_8 then
				flush_string_8 (str_8)

			else
				write_console (str)
			end
		end

	write_console (str: READABLE_STRING_GENERAL)
		do
			std_output.put_string (console_encoded (str))
		end

feature {NONE} -- Internal attributes

	buffer: ARRAYED_LIST [READABLE_STRING_GENERAL]

	new_line_prompt: STRING

	recycle_buffer: ARRAYED_LIST [like string_pool.item]
		-- strings for recycling back to pool

	std_output: PLAIN_TEXT_FILE

	string_pool: EL_POOL_SCOPE [STRING]
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