note
	description: "Abstraction for file that can be locked for exclusive writing operation"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 17:17:30 GMT (Monday 26th August 2024)"
	revision: "1"

deferred class
	EL_LOCKABLE_TEXT_FILE_I

inherit
	ANY
		undefine
			copy, is_equal
		end

feature -- Status report

	last_write_ok: BOOLEAN
			-- Was last write operation successful?

	is_locked: BOOLEAN
		deferred
		end

feature -- Measurement

	last_put_count: INTEGER
			-- Last amount of bytes written to pipe

feature -- Basic operations

	put_string (str: STRING)
		require
			locked: is_locked
		deferred
		ensure
			last_write_ok: last_write_ok
		end

	wipe_out
		-- wipe out existing file data
		require
			locked: is_locked
		deferred
		end

feature {NONE} -- Implementation

	remove_file
		do
			do_nothing
		end

feature {NONE} -- Constants

	Is_fixed_size: BOOLEAN = False

	Is_writeable: BOOLEAN = True

end