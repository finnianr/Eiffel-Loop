note
	description: "Text buffer medium"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-04-10 13:40:24 GMT (Sunday 10th April 2016)"
	revision: "1"

deferred class
	EL_STRING_IO_MEDIUM

inherit
	PLAIN_TEXT_FILE
		rename
			has as has_8,
			item as item_8,
			last_string as last_string_8,
			make as make_with_name_8,
			make_open_write as make_file_open_write,
			put_string as put_encoded_string_8

		export
			{NONE} all
			{ANY} is_closed, file_readable, extendible, twin, is_open_read
		undefine
			put_character, putchar,
			put_integer, putint, put_integer_8, put_integer_16, put_integer_32, put_integer_64,
			put_natural, put_natural_8, put_natural_16, put_natural_32, put_natural_64,
			put_real, putreal, put_double, putdouble,
			put_boolean, putbool
		redefine
			position, count,
			put_new_line, new_line,

			readline, read_line, read_stream, readstream,
			forth, finish, start, off, after, go,
			close, open_read, open_write, open_append, open_read_write, create_read_write, open_read_append,
			is_empty, end_of_file, exists, is_executable, readable, is_writable
		end

	EL_OUTPUT_MEDIUM
		redefine
			put_bom
		end

feature {NONE} -- Initialization

	make (size: INTEGER)
		local
			object_ptr: POINTER_REF
		do
			create last_string_8.make_empty
			set_last_string (new_string (0))
			text := new_string (size)
			create object_ptr
			object_ptr.set_item ($Current)
			make_with_name (object_ptr.out)
			set_default_encoding
		end

	make_open_read_from_text (a_text: like text)
			--
		do
			make (0)
			text := a_text
			open_read
		end

	make_open_write (size: INTEGER)
		do
			make (size)
			open_write
		end

	make_open_write_to_text (a_text: like text)
			--
		do
			make (0)
			text := a_text
			open_write
		end

feature -- Access

	count: INTEGER
		do
			Result := text.count
		end

	item: CHARACTER_32
		do
			Result := text [position]
		end

	last_string: like text
		deferred
		end

	position: INTEGER
		-- zero based index

	text: STRING_GENERAL

feature -- Status report

	after: BOOLEAN
		do
			Result := not is_closed and then end_of_file
		end

	end_of_file: BOOLEAN
		do
			Result := position >= text.count
		end

	exists: BOOLEAN = true
			-- Does medium exist?

	has (uc: CHARACTER_32): BOOLEAN
		do
			Result := text.has (uc)
		end

	is_empty: BOOLEAN
		do
			Result := text.is_empty
		end

	is_executable: BOOLEAN
			-- Is medium executable?
		do
		end

	is_writable: BOOLEAN
		do
			Result := True
		end

	off: BOOLEAN
			-- Is there a current item that may be read?
		do
			Result := text.is_empty or else is_closed or else end_of_file
		end

	readable: BOOLEAN
			-- Is there a current item that may be read?
		do
			Result := not off
		end

feature -- Cursor movement

	finish
		do
			position := text.count - 1
		end

	forth
		do
			position := position + 1
		end

	go (abs_position: INTEGER)
		do
			position := abs_position
		end

	start
		do
			position := 0
		end

feature -- Status setting

	close
			-- Close medium.
		do
			mode := Closed_file
		end

	create_read_write
			-- Open file in read and write mode;
			-- create it if it does not exist.
		do
			position := 0
			mode := Read_write_file
		end

	open_append
			-- Open file in append-only mode;
			-- create it if it does not exist.
		do
			position := text.count + 1
			mode := Append_file
		end

	open_read
			-- Open medium.
		do
			position := 0
			mode := Read_file
		end

	open_read_append
			-- Open file in read and write-at-end mode;
			-- create it if it does not exist.
		do
			position := 0
			mode := Append_read_file
		end

	open_read_write
			-- Open file in read and write mode.
		do
			position := 0
			mode := Read_write_file
		end

	open_write
			-- Open medium.
		do
			text.set_count (0)
			mode := Write_file
		end

feature -- Element change

	set_default_encoding
		do
			set_utf_encoding (8)
		end

feature -- Input

	read_line, readline
			-- Read characters until a new line or end of medium.
			-- Make result available in `last_string'.
		local
			new_line_pos, start_index, end_index: INTEGER

		do
			start_index := position + 1
			new_line_pos := text.index_of ('%N', start_index)
			if new_line_pos > 0 then
				end_index := new_line_pos - 1
			else
				end_index := text.count
			end
			set_last_string (text.substring (start_index, end_index))
			position := end_index + 1
		end

	read_stream, readstream (nb_char: INTEGER)
		local
			start_index, end_index: INTEGER
		do
			start_index := position + 1
			end_index := (start_index + nb_char -1).min (count)
			set_last_string (text.substring (start_index, end_index))
			position := end_index
		end

feature -- Output

	put_bom
		do
		end

	put_new_line, new_line
			-- Write a new line character to medium
		do
			text.append_code (10)
		end

feature -- Resizing

	grow (new_size: INTEGER)
			--
		deferred
		end

feature {NONE} -- Implementation

	set_last_string (a_string: like last_string)
		deferred
		end

	new_string (a_count: INTEGER): like text
		deferred
		end
end