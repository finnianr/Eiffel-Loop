note
	description: "Console log output"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-11-08 10:21:18 GMT (Friday 8th November 2024)"
	revision: "43"

class
	EL_CONSOLE_LOG_OUTPUT

inherit
	ANY

	EL_MODULE_CONSOLE; EL_MODULE_ENVIRONMENT

	EL_LOGGABLE_CONSTANTS; EL_STRING_8_CONSTANTS; EL_CHARACTER_8_CONSTANTS

	EL_SHARED_FORMAT_FACTORY; EL_SHARED_STRING_8_BUFFER_POOL

create
	make

feature -- Initialization

	make
		do
			create buffer.make (30)
			create buffer_list.make (30)
			create index_label_table.make (7)
			create new_line_prompt.make_from_string ("%N")
			string_pool := String_8_pool
			std_output := io.Output
		end

feature -- Status change

	restore (previous_stack_count: INTEGER)
			--
		do
			tab_repeat_count := previous_stack_count
		end

	set_tab_plus (offset: INTEGER)
			--
		do
			tab_repeat_count := tab_repeat_count.item + offset
		end

	tab_left
			--
		do
			set_tab_plus (-1)
		end

	tab_right
			--
		do
			set_tab_plus (1)
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
			extended_buffer_last (5).append_boolean (b)
		end

	put_character (c: CHARACTER)
			--
		do
			extended_buffer_last (1).append_character (c)
		end

	put_classname (a_name: READABLE_STRING_8)
		do
			set_text_color_light (Color.Blue)
			buffer.extend (a_name)
			set_text_color (Color.Default)
		end

	put_index_label (indexable: ANY; label_or_format: detachable READABLE_STRING_GENERAL)
		-- output integer index value associated with `indexable' object that may conform to one of:
		--		`LINEAR', `INDEXABLE_ITERATION_CURSOR', `INTEGER_32_REF', `NATURAL_32_REF'

		-- An optional formatting `label_or_format' that may be interpreted in the following ways:

		--		1. A template if it contains a substitution placeholder '%S' for the `indexable' value (Eg. "i_th [%S]")
		--		2. A padding format for the `indexable' value if all the characters are equal to '9'
		--		3. Or else a prefix before the `indexable' value
		require
			is_indexable: is_indexable (indexable)
		local
			substitution_index, index, width: INTEGER;
			leading, trailing: READABLE_STRING_GENERAL; math: EL_INTEGER_MATH
		do
			if attached {INDEXABLE_ITERATION_CURSOR [ANY]} indexable as list then
				index := list.cursor_index

			elseif attached {LINEAR [ANY]} indexable as list then
				index := list.index

			elseif attached {INTEGER_32_REF} indexable as integer then
				index := integer.item

			elseif attached {NATURAL_32_REF} indexable as natural then
				index := natural.item.to_integer_32
			end
			leading := Empty_string_8; trailing := Empty_string_8
			if attached label_or_format as str then
				if str.occurrences ('9') = str.count then
					width := math.digit_count (index)
					if width < str.count then
					-- create padding to right justify
						leading := space * (str.count - width)
					end

				elseif attached index_label_table as table then
					if table.has_key (str) and then attached table.found_item as pair then
						leading := pair.leading; trailing := pair.trailing
					else
						substitution_index := str.index_of ('%S', 1)
						if substitution_index > 0 then
						-- split for example: "i_th [%S]"
							leading := str.substring (1, substitution_index - 1) -- "i_th [
							trailing := str.substring (substitution_index + 1, str.count) -- "]"
						else
							leading := str
						end
						table.extend ([leading, trailing], str)
					end
				end
			end
			set_text_color_light (Color.Purple)
			if leading.count > 0 then
				put_string_general (leading)
			end
			extended_buffer_last (11).append_integer (index)
			if trailing.count > 0 then
				put_string_general (trailing)
			end
			set_text_color (Color.Default)
			put_string (Dot_space)
		end

	put_keyword (keyword: READABLE_STRING_8)
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
			put_string (Colon_space)
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

	put_path (a_path: EL_PATH)
			--
		do
			buffer.extend (a_path.to_string)
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

	put_double (d: DOUBLE; a_format: detachable STRING)
			--
		do
		-- Using `extended_buffer_last' not more efficient
			if attached a_format as str then
				buffer.extend (Format.double_as_string (d, str))
			else
				buffer.extend (d.out)
			end
		end

	put_integer (i: INTEGER)
			-- Add a string to the buffer
		do
			extended_buffer_last (11).append_integer (i)
		end

	put_natural (n: NATURAL)
		do
			extended_buffer_last (10).append_natural_32 (n)
		end

	put_real (r: REAL; a_format: detachable STRING)
			--
		do
		-- Using `extended_buffer_last' not more efficient
			if attached a_format as l_format then
				buffer.extend (Format.double_as_string (r, l_format))
			else
				buffer.extend (r.out)
			end
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
		-- Return strings of type {STRING_8} to recyle pool
		do
			buffer.do_all (agent flush_string_general)
			buffer.wipe_out
			String_8_pool.return (buffer_list.area)
		end

feature {NONE} -- Implementation

	extended_buffer_last (size: INTEGER): STRING_8
		do
			if attached string_pool.borrowed_item as borrowed then
				Result := borrowed.empty
				buffer_list.extend (borrowed)
			end
			buffer.extend (Result)
		end

	flush_string_8 (str_8: READABLE_STRING_8)
		do
			write_console (str_8)
		end

	flush_string_general (str: READABLE_STRING_GENERAL)
		do
			if str.is_string_8 and then attached {READABLE_STRING_8} str as str_8 then
				flush_string_8 (str_8)
			else
				write_console (str)
			end
		end

	write_console (str: READABLE_STRING_GENERAL)
		do
			std_output.put_string (Console.encoded (str, False))
		end

feature {NONE} -- Internal attributes

	buffer: ARRAYED_LIST [READABLE_STRING_GENERAL]

	buffer_list: ARRAYED_LIST [EL_STRING_8_BUFFER]

	index_label_table: STRING_TABLE [TUPLE [leading, trailing: READABLE_STRING_GENERAL]]
		-- substitution parts
		-- Eg. "i_th [%S]" => ["i_th [", "]"]

	new_line_prompt: STRING

	std_output: PLAIN_TEXT_FILE

	string_pool: like String_8_pool
		-- recycled strings

	tab_repeat_count: INTEGER

feature {EL_LOGGABLE} -- Constants

	Colon_space: STRING = ": "

	Dot_space: STRING = ". "

	Line_separator: STRING
		once
			create Result.make_filled ('-', 100)
		end

	Tab_string: STRING = "  "

	Tail_character_count : INTEGER = 1500

end