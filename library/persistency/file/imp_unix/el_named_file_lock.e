note
	description: "[
		Unix implementation of a special 1 byte created file used as a mutex
	]"
	testing: "${FILE_LOCKING_TEST_SET}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-02-14 10:23:50 GMT (Friday 14th February 2025)"
	revision: "9"

class
	EL_NAMED_FILE_LOCK

inherit
	EL_NAMED_FILE_LOCK_I

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

end