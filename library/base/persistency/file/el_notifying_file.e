note
	description: "File that can notify a listener of the progress of file read/write operations"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-11 9:50:47 GMT (Monday 11th July 2016)"
	revision: "6"

deferred class
	EL_NOTIFYING_FILE

inherit
	FILE
		redefine
			make_with_name, open_read, open_write, close, move, go, recede, back, start, finish, forth
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
			listener := progress_listener
		end

	open_write
		do
			Precursor
			listener := progress_listener
		end

feature -- Status setting

	close
		-- Notify listener of bytes read or written
		do
			Precursor
			listener := Do_nothing_listener
		end

feature -- Basic operations

	notify
		local
			l_count: INTEGER
		do
			l_count := position - last_position
			if l_count > 0 then
				listener.on_notify (l_count)
			end
			last_position := position
		end

feature -- Cursor movement

	back
		do
			Precursor
			last_position := position
		end

	start
		do
			Precursor
			last_position := position
		end

	finish
		do
			Precursor
			last_position := position
		end

	forth
			-- Go to next position.
		do
			Precursor
			last_position := position
		end

	go (abs_position: INTEGER)
		do
			Precursor (abs_position)
			last_position := position
		end

	move (offset: INTEGER)
		do
			Precursor (offset)
			last_position := position
		end

	recede (abs_position: INTEGER)
		do
			Precursor (abs_position)
			last_position := position
		end

feature -- Implementation

	last_position: INTEGER

	listener: EL_FILE_PROGRESS_LISTENER

end