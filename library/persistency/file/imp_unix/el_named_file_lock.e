note
	description: "[
		Unix implementation of a special 1 byte created file that can be used as a file mutex
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-06-07 11:29:46 GMT (Friday 7th June 2024)"
	revision: "4"

class
	EL_NAMED_FILE_LOCK

inherit
	EL_FILE_LOCK
		rename
			make as make_lock
		redefine
			dispose
		end

create
	make

feature {NONE} -- Initialization

	make (a_path: EL_FILE_PATH)
		do
			path := a_path
			make_write (c_create_write_only (a_path.to_path.native_string.item))
			if is_fixed_size then
				set_length (1)
			end
		ensure
			is_lockable: is_lockable
		end

feature -- Access

	path: EL_FILE_PATH

feature -- Status change

	close
		do
			if descriptor.to_boolean and then c_close (descriptor) = 0 then
				descriptor := 0
			end
		ensure
			not_lockable: not is_lockable
		end

feature {NONE} -- Implementation

	is_fixed_size: BOOLEAN
		do
			Result := True
		end

	dispose
		local
			status: INTEGER
		do
			if descriptor.to_boolean then
				status := c_close (descriptor)
			end
			Precursor
		end

end