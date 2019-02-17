note
	description: "File that can notify a listener of the progress of file read/write operations"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-02-16 12:34:07 GMT (Saturday 16th February 2019)"
	revision: "8"

deferred class
	EL_NOTIFYING_FILE

inherit
	FILE
		redefine
			close, move, go, recede, back, start, finish, forth
		end

	EL_SHARED_FILE_PROGRESS_LISTENER

feature -- Basic operations

	notify_final
		do
			notify_progress (True)
		end

	notify
		do
			notify_progress (False)
		end

	close
		do
			notify_final
			Precursor
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
			notify_final
			Precursor (abs_position)
			last_position := position
		end

	move (offset: INTEGER)
		do
			notify_final
			Precursor (offset)
			last_position := position
		end

	recede (abs_position: INTEGER)
		do
			notify_final
			Precursor (abs_position)
			last_position := position
		end

feature {NONE} -- Implementation

	notify_progress (final: BOOLEAN)
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

	last_position: INTEGER

end
