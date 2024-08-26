note
	description: "[
		Unix implementation of a special 1 byte created file used as a mutex
	]"
	testing: "${FILE_LOCKING_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-26 17:58:02 GMT (Monday 26th August 2024)"
	revision: "8"

class
	EL_NAMED_FILE_LOCK

inherit
	EL_NAMED_FILE_LOCK_I
		redefine
			unlock
		end

create
	make

feature {NONE} -- Initialization

	make (a_path: EL_FILE_PATH)
		local
			error: INTEGER
		do
			path := a_path
			make_write (c_create_write_only (native_path.item, $error))
			last_error := error
			if is_fixed_size then
				set_length (1)
			end
		ensure then
			is_lockable: is_lockable
		end

feature -- Status change

	close
		do
			if descriptor.to_boolean and then c_close (descriptor) = 0 then
				descriptor := 0
			end
		end

	unlock
		do
			if is_locked then
				Precursor; remove_file
			end
		ensure then
			file_removed: not is_writeable and then old is_locked implies not path.exists
		end

end