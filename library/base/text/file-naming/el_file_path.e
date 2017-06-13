note
	description: "Summary description for {EL_LATIN_FILE_PATH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-27 12:36:38 GMT (Saturday 27th May 2017)"
	revision: "7"

class
	EL_FILE_PATH

inherit
	EL_PATH

create
	default_create, make, make_from_general, make_from_path, make_from_other

convert
	make ({ZSTRING}), make_from_general ({STRING_32, STRING}), make_from_path ({PATH}),

 	to_string: {EL_ZSTRING}, as_string_32: {STRING_32, READABLE_STRING_GENERAL}, steps: {EL_PATH_STEPS}, to_path: {PATH}

feature -- Access

	modification_date_time: DATE_TIME
		do
			if exists then
				create Result.make_from_epoch (modification_time)
			else
				create Result.make (0, 0, 0, 0, 0, 0)
			end
		end

	modification_time: INTEGER
		do
			Result := File_system.file_modification_time (Current)
		end

feature -- Status report

	Is_directory: BOOLEAN = False

	exists: BOOLEAN
		do
			Result := File_system.file_exists (Current)
		end

feature {NONE} -- Implementation

	new_relative_path: EL_FILE_PATH
		do
			create Result.make_from_other (Current)
		end

end
