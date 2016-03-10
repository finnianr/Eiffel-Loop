note
	description: "Text buffer medium encoded as UTF-8"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_UTF_8_TEXT_IO_MEDIUM

inherit
	PLAIN_TEXT_FILE
		rename
			make as make_with_name_8,
			make_open_write as make_file_open_write,
			put_string as put_string_8
		export
			{NONE} all
			{ANY} is_closed, file_readable, extendible, twin
		redefine
			item, linear_representation, position, count,
			put_new_line, new_line, put_string_8, putstring, put_character, putchar,
			put_integer, putint, put_integer_8, put_integer_16, put_integer_32, put_integer_64,
			put_natural, put_natural_8, put_natural_16, put_natural_32, put_natural_64,
			put_real, putreal, put_double, putdouble,
			put_boolean, putbool,
			readline, read_line, read_stream, readstream,
			forth, finish, start, off, after, go,
			close, open_read, open_write, open_append, open_read_write, create_read_write, open_read_append,
			has, is_empty, end_of_file, exists, is_executable, readable, is_writable
		end

	EL_OUTPUT_MEDIUM

create
	make, make_open_write, make_open_write_to_text, make_open_read_from_text

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
			set_default_encoding
		end

	make_open_write_to_text (a_text: like text)
			--
		do
			make (0)
			text := a_text
			open_write
		end

	make_open_read_from_text (a_text: like text)
			--
		do
			make (0)
			text := a_text
			open_read
		end

feature -- Access

	text: STRING

	item: CHARACTER
		do
			Result := text [position]
		end

	position: INTEGER
		-- zero based index

	count: INTEGER
		do
			Result := text.count
		end

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

	has (char: CHARACTER): BOOLEAN
		do
			Result := text.has (char)
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

	start
		do
			position := 0
		end

	forth
		do
			position := position + 1
		end

	finish
		do
			position := text.count - 1
		end

	go (abs_position: INTEGER)
		do
			position := abs_position
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

feature -- Element change

	set_default_encoding
		do
			set_utf_encoding (8)
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
			last_string := text.substring (start_index, end_index)
			position := end_index + 1
		end

	read_stream, readstream (nb_char: INTEGER)
		local
			start_index, end_index: INTEGER
		do
			start_index := position + 1
			end_index := (start_index + nb_char -1).min (count)
			last_string := text.substring (start_index, end_index)
			position := end_index
		end

feature -- Output

	put_new_line, new_line
			-- Write a new line character to medium
		do
			text.append_character ('%N')
		end

	put_string_8, putstring (s: STRING)
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
