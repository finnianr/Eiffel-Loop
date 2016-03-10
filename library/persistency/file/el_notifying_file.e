note
	description: "Summary description for {EL_NOTIFYING_FILE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "4"

deferred class
	EL_NOTIFYING_FILE

inherit
	FILE
		redefine
			make_with_name, open_read, open_write, close, move,
			read_character, read_line, read_to_managed_pointer,
			put_managed_pointer, put_character, put_string, put_new_line
		end

	EL_SHARED_FILE_PROGRESS_LISTENER

feature -- Initialization

	make_with_name (fn: READABLE_STRING_GENERAL)
		do
			Precursor (fn)
			listener := Do_nothing_listener
		end

feature -- Status setting

	open_read
		do
			Precursor
			listener := file_listener
		end

	open_write
		do
			Precursor
			listener := file_listener
		end

feature -- Status setting

	close
		do
			Precursor
			listener := Do_nothing_listener
		end

feature -- Cursor movement

	move (offset: INTEGER)
			-- Advance by `offset' from current location.
		do
			Precursor (offset)
			listener.on_read (offset)
		end

feature -- Input

	read_character
		do
			Precursor
			listener.on_read ({PLATFORM}.character_8_bytes)
		end

	read_line
		local
			old_position: INTEGER
		do
			old_position := position
			Precursor
			listener.on_read (position - old_position)
		end

	read_to_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Read at most `nb_bytes' bound bytes and make result
			-- available in `p' at position `start_pos'.
		do
			Precursor (p, start_pos, nb_bytes)
			listener.on_read (bytes_read)
		end

feature -- Input

	put_managed_pointer (p: MANAGED_POINTER; start_pos, nb_bytes: INTEGER)
			-- Put data of length `nb_bytes' pointed by `start_pos' index in `p' at
			-- current position.
		do
			Precursor (p, start_pos, nb_bytes)
			listener.on_write (nb_bytes)
		end

	put_character (c: CHARACTER)
			-- Write `c' at current position.
		do
			file_pc (file_pointer, c)
			listener.on_write ({PLATFORM}.character_8_bytes)
		end

	put_new_line
		local
			old_position: INTEGER
		do
			old_position := position
			Precursor
			listener.on_write (position - old_position)
		end

	put_string (s: STRING)
		do
			Precursor (s)
			listener.on_write (s.count)
		end

feature -- Implementation

	listener: EL_FILE_PROGRESS_LISTENER

end
