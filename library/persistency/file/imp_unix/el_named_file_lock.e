note
	description: "[
		Unix implementation of a special 1 byte created file used as a mutex
	]"
	testing: "${FILE_LOCKING_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-19 11:27:49 GMT (Monday 19th August 2024)"
	revision: "7"

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
			error: NATURAL
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
		ensure then
			not_lockable: not is_lockable
		end

	unlock
		do
			if is_locked then
				Precursor
				File_system.remove_file (path)
			end
		ensure then
			file_removed: old is_locked implies not path.exists
		end

end