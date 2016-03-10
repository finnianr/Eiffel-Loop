note
	description: "Summary description for {EL_XML_PARSER_IO_MEDIUM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_XML_PARSER_OUTPUT_MEDIUM

inherit
	IO_MEDIUM
		undefine
			dispose
		redefine
			is_plain_text
		end

feature {NONE} -- Initialization

	make
			--
		do
			create last_string.make (100)
		end

feature -- Output

	put_string, putstring (string: STRING)
			--
		local
			last_char: CHARACTER
		do
			last_string.append (string)
			if not string.is_empty then
				last_char := string @ string.count
				if (last_char = '%N' or last_char = '>') and then is_correct then
					parse_string_and_set_error (last_string, False)
					last_string.wipe_out
				end
			end
		end

feature -- Status setting

	close
			-- Close medium.
		do
			is_closed := true
		end

	open
			-- Open medium.
		do
			is_closed := false
		end

feature -- Status report

	is_correct: BOOLEAN
			-- i s parser in a valid state without error
		deferred
		end

	is_plain_text: BOOLEAN
			-- Is file reserved for text (character sequences)?
		do
			Result := true
		end

	exists: BOOLEAN = true
			-- Does medium exist?

	is_open_read: BOOLEAN
			-- Is this medium opened for input
		do
		end

	is_open_write: BOOLEAN
			-- Is this medium opened for output
		do
		end

	is_readable: BOOLEAN
			-- Is medium readable?
		do
		end

	is_executable: BOOLEAN
			-- Is medium executable?
		do
		end

	is_writable: BOOLEAN
			-- Is medium writable?
		do
		end

	readable: BOOLEAN
			-- Is there a current item that may be read?
		do
		end

	extendible: BOOLEAN = true
			-- May new items be added?

	is_closed: BOOLEAN

	support_storable: BOOLEAN = false

feature {NONE} -- Implementation

	parse_string_and_set_error (a_data: STRING; is_final: BOOLEAN)
			--
		deferred
		end

feature {NONE} -- Unused

	put_new_line, new_line
			-- Write a new line character to medium
		do
		end

	put_character, putchar (c: CHARACTER)
			--
		do
		end

	put_real, putreal (r: REAL)
			--
		do
		end

	put_integer, putint, put_integer_32 (i: INTEGER)
			--
		do
		end

	put_integer_8 (i: INTEGER_8)
			--
		do
		end

	put_integer_16 (i: INTEGER_16)
			--
		do
		end

	put_integer_64 (i: INTEGER_64)
			--
		do
		end

	put_boolean, putbool (b: BOOLEAN)
			-- Write `b' to medium.
		do
		end

	put_double, putdouble (d: DOUBLE)
			-- Write `d' to medium.
		do
		end

	put_natural_8 (n: NATURAL_8)
			--
		do
		end

	put_natural_16 (n: NATURAL_16)
			--
		do
		end

	put_natural, put_natural_32 (n: NATURAL_32)
			--
		do
		end

	put_natural_64 (n: NATURAL_64)
			--
		do
		end

	put_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Put data of length `nb_bytes' pointed by `start_pos' index in `p' at
			-- current position.
		do
		end


	basic_store (object: ANY)
			-- Produce an external representation of the
			-- entire object structure reachable from `object'.
			-- Retrievable within current system only.
		do
		end

	general_store (object: ANY)
			-- Produce an external representation of the
			-- entire object structure reachable from `object'.
			-- Retrievable from other systems for same platform
			-- (machine architecture).
			--| This feature may use a visible name of a class written
			--| in the `visible' clause of the Ace file. This makes it
			--| possible to overcome class name clashes.
		do
		end

	independent_store (object: ANY)
			-- Produce an external representation of the
			-- entire object structure reachable from `object'.
			-- Retrievable from other systems for the same or other
			-- platform (machine architecture).
		do
		end

	handle: INTEGER
			-- Handle to medium
		do
		end

	handle_available: BOOLEAN
			-- Is the handle available after class has been
			-- created?
		do
		end

	read_real, readreal
			-- Read a new real.
			-- Make result available in `last_real'.
		do
		end

	read_double, readdouble
			-- Read a new double.
			-- Make result available in `last_double'.
		do
		end

	read_character, readchar
			-- Read a new character.
			-- Make result available in `last_character'.
		do
		end

	read_integer, readint, read_integer_32
			-- Read a new integer.
			-- Make result available in `last_integer'.
		do
		end

	read_integer_8
			-- Read a new 8-bit integer.
			-- Make result available in `last_integer_8'.
		do
		end

	read_integer_16
			-- Read a new 16-bit integer.
			-- Make result available in `last_integer_16'.
		do
		end

	read_integer_64
			-- Read a new 64-bit integer.
			-- Make result available in `last_integer_64'.
		do
		end

	read_natural_8
			-- Read a new 8-bit natural.
			-- Make result available in `last_natural_8'.
		do
		end

	read_natural_16
			-- Read a new 16-bit natural.
			-- Make result available in `last_natural_16'.
		do
		end

	read_natural, read_natural_32
			-- Read a new 32-bit natural.
			-- Make result available in `last_natural'.
		do
		end

	read_natural_64
			-- Read a new 64-bit natural.
			-- Make result available in `last_natural_64'.
		do
		end

	read_stream, readstream (nb_char: INTEGER)
			-- Read a string of at most `nb_char' bound characters
			-- or until end of medium is encountered.
			-- Make result available in `last_string'.
		do
		end

	read_line, readline
			-- Read characters until a new line or
			-- end of medium.
			-- Make result available in `last_string'.
		do
		end

	read_to_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Read at most `nb_bytes' bound bytes and make result
			-- available in `p' at position `start_pos'.
		do
		end

	name: STRING

	retrieved: ANY
			-- Retrieved object structure
			-- To access resulting object under correct type,
			-- use assignment attempt.
			-- Will raise an exception (code `Retrieve_exception')
			-- if content is not a stored Eiffel structure.
		do
		end


end
