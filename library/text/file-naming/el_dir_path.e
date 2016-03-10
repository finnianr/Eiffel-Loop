note
	description: "Summary description for {EL_DIR_PATH}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:02 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	EL_DIR_PATH

inherit
	EL_PATH

create
	default_create, make, make_from_unicode, make_from_latin1, make_from_path

convert
	make ({EL_ASTRING}),
	make_from_latin1 ({STRING}),
	make_from_unicode ({STRING_32}),
	make_from_path ({PATH}),

 	to_string: {EL_ASTRING},
 	steps: {EL_PATH_STEPS},
 	to_path: {PATH}

feature -- Conversion

	joined_dir_steps (a_steps: EL_PATH_STEPS): EL_DIR_PATH
		do
			Result := joined_dir_path (a_steps)
		end

	joined_file_steps (a_steps: EL_PATH_STEPS): EL_FILE_PATH
		do
			Result := joined_file_path (a_steps)
		end

	joined_file_path alias "+" (a_file_path: EL_FILE_PATH): EL_FILE_PATH
		do
			create Result.make (to_string); Result.append (a_file_path)
		end

	joined_dir_path (a_dir_path: EL_DIR_PATH): EL_DIR_PATH
		do
			create Result.make (to_string); Result.append_dir_path (a_dir_path)
		end

feature -- Status report

	is_parent_of (other: EL_PATH): BOOLEAN
		local
			l_path: EL_ASTRING
		do
			l_path := to_string
			if other.parent_path.starts_with (l_path)
				and then l_path.count = other.parent_path.count or else other.parent_path [l_path.count + 1] = Separator
			then
				Result := True
			end
		end

	exists: BOOLEAN
		do
			Directory.set_path (unicode)
			Result := Directory.exists
		end

	Is_directory: BOOLEAN = True

	is_createable: BOOLEAN
		do
			Result := File_system.dir_exists_and_is_writeable (parent)
		end

feature {NONE} -- Constants

	Directory: EL_DIRECTORY
			--
		once
			create Result
		end

end
