note
	description: "Dummy file persistent"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:33:26 GMT (Thursday 11th December 2014)"
	revision: "5"

class
	EL_FILE_PERSISTENT_IMPL

inherit
	EL_FILE_PERSISTENT

create
	make, make_from_file

feature -- Access

	file_path: EL_FILE_PATH

feature {NONE} -- Initialization

	make
			--
		do
			create file_path
		end

feature -- Element change

	set_file_path (a_file_path: EL_FILE_PATH)
			--
		do
			file_path := a_file_path
		end

feature {NONE} -- Implementation

	store_as (a_file_path: like file_path)
			--
		do
		end

	stored_successfully (a_file: like new_open_read_file): BOOLEAN
		do
		end

	new_open_read_file (a_file_path: like file_path): FILE
		do
		end
end
