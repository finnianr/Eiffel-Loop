note
	description: "Summary description for {EL_LATIN_FILE_PATH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_FILE_PATH

inherit
	EL_PATH

create
	default_create, make, make_from_unicode, make_from_latin1, make_from_path

convert
	make ({EL_ASTRING}),
	make_from_unicode ({STRING_32}),
	make_from_latin1 ({STRING}),
	make_from_path ({PATH}),

 	to_string: {EL_ASTRING}

feature -- Access

	modification_time: DATE_TIME
		require
			path_exists: exists
		do
			if exists then
				create Result.make_from_epoch (File_system.closed_raw_file (Current).date)
			else
				create Result.make (0, 0, 0, 0, 0, 0)
			end
		end

feature -- Status report

	exists: BOOLEAN
		local
			l_file: RAW_FILE
		do
			create l_file.make_with_name (unicode)
			Result := l_file.exists
		end

	Is_directory: BOOLEAN = False

end
