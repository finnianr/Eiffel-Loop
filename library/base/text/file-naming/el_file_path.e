note
	description: "Summary description for {EL_LATIN_FILE_PATH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-01-14 13:10:06 GMT (Saturday 14th January 2017)"
	revision: "4"

class
	EL_FILE_PATH

inherit
	EL_PATH

create
	default_create, make, make_from_unicode, make_from_latin_1, make_from_path, make_from_other

convert
	make ({ZSTRING}),
	make_from_unicode ({STRING_32}),
	make_from_latin_1 ({STRING}),
	make_from_path ({PATH}),

 	to_string: {EL_ZSTRING}, unicode: {READABLE_STRING_GENERAL}, steps: {EL_PATH_STEPS}, to_path: {PATH}

feature -- Access

	modification_time: INTEGER
		do
			Result := File_system.modification_time (Current)
		end

	modification_date_time: DATE_TIME
		do
			if exists then
				create Result.make_from_epoch (modification_time)
			else
				create Result.make (0, 0, 0, 0, 0, 0)
			end
		end

feature -- Status report

	exists: BOOLEAN
		do
			Result := File_system.file_exists (Current)
		end

	Is_directory: BOOLEAN = False

feature {NONE} -- Implementation

	new_relative_path: EL_FILE_PATH
		do
			create Result.make_from_other (Current)
		end

end
