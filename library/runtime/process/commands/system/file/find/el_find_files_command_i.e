note
	description: "Cross platform interface to [$source EL_FIND_FILES_COMMAND_IMP]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:01 GMT (Thursday 12th October 2017)"
	revision: "2"

deferred class
	EL_FIND_FILES_COMMAND_I

inherit
	EL_FIND_COMMAND_I
		rename
			make as make_path
		redefine
			make_default
		end

feature {NONE} -- Initialization

	make (a_dir_path: like dir_path; a_name_pattern: like name_pattern)
			--
		do
			make_path (a_dir_path)
			name_pattern := a_name_pattern
		end

	make_default
			--
		do
			Precursor
			name_pattern := "*"
		end

feature -- Element change

	set_file_pattern (a_name_pattern: like name_pattern)
			--
		do
			name_pattern := a_name_pattern
		end

feature {NONE} -- Implementation

	new_path (a_path: ZSTRING): EL_FILE_PATH
		do
			create Result.make (a_path)
		end

feature {NONE} -- Constants

	Type: STRING = "f"
		-- Unix find type

end
