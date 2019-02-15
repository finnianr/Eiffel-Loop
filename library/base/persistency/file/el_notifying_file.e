note
	description: "File that can notify a listener of the progress of file read/write operations"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-13 18:23:51 GMT (Wednesday 13th February 2019)"
	revision: "6"

deferred class
	EL_NOTIFYING_FILE

inherit
	FILE
		redefine
			move, go, recede, back, start, finish, forth
		end

	EL_SHARED_FILE_PROGRESS_LISTENER

feature -- Basic operations

	notify (final: BOOLEAN)
		-- notify progress of file operation
		local
			delta_count: INTEGER
		do
			delta_count := position - last_position
			if not final implies delta_count > 500 then
				progress_listener.on_notify (delta_count)
				last_position := position
			end
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
			notify (True)
			Precursor (abs_position)
			last_position := position
		end

	move (offset: INTEGER)
		do
			notify (True)
			Precursor (offset)
			last_position := position
		end

	recede (abs_position: INTEGER)
		do
			notify (True)
			Precursor (abs_position)
			last_position := position
		end

feature -- Implementation

	last_position: INTEGER

end
