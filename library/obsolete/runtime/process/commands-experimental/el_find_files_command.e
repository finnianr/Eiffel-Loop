note
	description: "Summary description for {EL_FIND_FILES_COMMAND}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-12-11 14:34:35 GMT (Thursday 11th December 2014)"
	revision: "2"

class
	EL_FIND_FILES_COMMAND

inherit
	EL_FIND_OS_COMMAND [EL_FIND_FILES_IMPL, EL_FILE_PATH]
		rename
			make as make_find
		redefine
			make_default
		end

create
	make, make_default

feature {NONE} -- Initialization

	make_default
			--
		do
			Precursor
			file_pattern := "*"
			set_recursive (true)
		end

	make (a_path: like path; a_file_pattern: like file_pattern)
			--
		do
			make_find (a_path)
			file_pattern := a_file_pattern
		end

feature -- Access

	file_pattern: STRING

feature -- Status query

	is_recursive_find: BOOLEAN

feature -- Element change

	set_file_pattern (a_file_pattern: like file_pattern)
			--
		do
			file_pattern := a_file_pattern
		end

	set_recursive (flag: BOOLEAN)
			--
		do
			is_recursive_find := flag
		end

end
