note
	description: "[
		Text buffer medium encoded as latin1 or UTF-8
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-04 11:23:09 GMT (Thursday 4th July 2013)"
	revision: "2"

class
	EL_TEXT_IO_MEDIUM

inherit
	PLAIN_TEXT_FILE
		rename
			make as make_with_name_8,
			make_open_write as make_file_open_write
		export
			{NONE} all
			{ANY} is_closed, file_readable, extendible, twin
		redefine
			item, linear_representation, position, count,
			put_new_line, new_line, put_string, putstring, put_character, putchar,
			put_integer, putint, put_integer_8, put_integer_16, put_integer_32, put_integer_64,
			put_natural, put_natural_8, put_natural_16, put_natural_32, put_natural_64,
			put_real, putreal, put_double, putdouble,
			put_boolean, putbool,
			readline, read_line,
			forth, finish, start, off, after,
			close, open_read, open_write, open_append, open_read_write, create_read_write, open_read_append,
			has, is_empty, exists, is_executable, readable, is_writable
		end

create
	make, make_open_write, make_open_write_to_string, make_open_read_from_string

feature {NONE} -- Initialization

	make_open_write (size: INTEGER)
		do
			make (size)
			open_write
		end

	make (size: INTEGER)
		local
			object_ptr: POINTER_REF
		do
			create last_string.make_empty
			create text.make (size)
			create object_ptr
			object_ptr.set_item ($Current)
			make_with_name (object_ptr.out)
		end

	make_open_write_to_string (a_string: STRING)
			--
		do
			make (0)
			text := a_string
			open_write
		end

	make_open_read_from_string (a_string: STRING)
			--
		do
			make (0)
			text := a_string
			open_read
		end

feature -- Access

	text: STRING

	item: CHARACTER
		do
			Result := text [position]
		end

	position: INTEGER

	count: INTEGER
		do
			Result := text.count
		end

feature -- Status report

	has (char: CHARACTER): BOOLEAN
		do
			Result := text.has (char)
		end

	is_empty: BOOLEAN
		do
			Result := text.is_empty
		end

	exists: BOOLEAN = true
			-- Does medium exist?

	is_executable: BOOLEAN
			-- Is medium executable?
		do
		end

	off: BOOLEAN
			-- Is there a current item that may be read?
		do
			Result := text.is_empty or else is_closed or else position > text.count
		end

	after: BOOLEAN
		do
			Result := not is_closed and then position > text.count
		end

	readable: BOOLEAN
			-- Is there a current item that may be read?
		do
			Result := not off
		end

	is_writable: BOOLEAN
		do
			Result := True
		end

feature -- Cursor movement


	start
		do
			position := 1
		end

	forth
		do
			position := position + 1
		end

	finish
		do
			position := text.count
		end

feature -- Status setting

	open_read
			-- Open medium.
		do
			position := 0
			mode := Read_file
		end

	open_write
			-- Open medium.
		do
			text.wipe_out
			mode := Write_file
		end

	open_append
			-- Open file in append-only mode;
			-- create it if it does not exist.
		do
			position := text.count + 1
			mode := Append_file
		end

	open_read_write
			-- Open file in read and write mode.
		do
			position := 0
			mode := Read_write_file
		end

	create_read_write
			-- Open file in read and write mode;
			-- create it if it does not exist.
		do
			position := 0
			mode := Read_write_file
		end

	open_read_append
			-- Open file in read and write-at-end mode;
			-- create it if it does not exist.
		do
			position := 0
			mode := Append_read_file
		end

	close
			-- Close medium.
		do
			mode := Closed_file
		end

feature -- Conversion

	linear_representation: LINEAR [CHARACTER]
		do
			Result := text.linear_representation
		end

feature -- Resizing

	grow (newsize: INTEGER)
			--
		do
			text.grow (newsize)
		end

feature -- Input

	read_line, readline
			-- Read characters until a new line or
			-- end of medium.
			-- Make result available in `last_string'.
		local
			start_index: INTEGER
		do
			start_index := position + 1
			position := text.index_of ('%N', position + 1)
			if position > 0 then
				last_string := text.substring (start_index, position - 1)
			else
				last_string := text.substring (start_index, text.count)
				position := text.count + 1
			end
		end

feature -- Output

	put_new_line, new_line
			-- Write a new line character to medium
		do
			text.append_character ('%N')
		end

	put_string, putstring (s: STRING)
			-- Write `s' to medium.
		do
			text.append (s)
		end

	put_character, putchar (c: CHARACTER)
			--
		do
			text.append_character (c)
		end

	put_real, putreal (r: REAL)
			--
		do
			text.append_real (r)
		end

	put_integer, putint, put_integer_32 (i: INTEGER)
			--
		do
			text.append_integer (i)
		end

	put_integer_8 (i: INTEGER_8)
			--
		do
			text.append_integer_8 (i)
		end

	put_integer_16 (i: INTEGER_16)
			--
		do
			text.append_integer_16 (i)
		end

	put_integer_64 (i: INTEGER_64)
			--
		do
			text.append_integer_64 (i)
		end

	put_boolean, putbool (b: BOOLEAN)
			-- Write `b' to medium.
		do
			text.append_boolean (b)
		end

	put_double, putdouble (d: DOUBLE)
			-- Write `d' to medium.
		do
			text.append_double (d)
		end

	put_natural_8 (n: NATURAL_8)
			--
		do
			text.append_natural_8 (n)
		end

	put_natural_16 (n: NATURAL_16)
			--
		do
			text.append_natural_16 (n)
		end

	put_natural, put_natural_32 (n: NATURAL_32)
			--
		do
			text.append_natural_32 (n)
		end

	put_natural_64 (n: NATURAL_64)
			--
		do
			text.append_natural_64 (n)
		end

end
