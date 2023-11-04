note
	description: "A special 1 byte created file that can be used as a file mutex"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-04 18:41:20 GMT (Saturday 4th November 2023)"
	revision: "2"

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
	make, make_from_name

feature {NONE} -- Initialization

	make (path: EL_FILE_PATH)
		do
			make_from_name (path)
		end

	make_from_name (path_name: ZSTRING)
		do
			native_path := path_name
			make_write (c_create_write_only (native_path.base_address))
			set_length (1)
		ensure
			is_lockable: is_lockable
		end

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

	dispose
		local
			status: INTEGER
		do
			if descriptor.to_boolean then
				status := c_close (descriptor)
			end
			Precursor
		end

feature {NONE} -- Internal attributes

	native_path: EL_C_UTF_STRING_8

end