note
	description: "[
		Object to temporarily swap a file with another file in the same directory that has
		the same name but a different extension
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-04-24 16:34:27 GMT (Saturday 24th April 2021)"
	revision: "2"

class
	EL_FILE_SWAPPER

inherit
	ANY

	EL_MODULE_FILE_SYSTEM

create
	make

feature {NONE} -- Initialization

	make (a_file_path: EL_FILE_PATH; target_extension: READABLE_STRING_GENERAL)
		do
			file_path := a_file_path
			temp_path := a_file_path.with_new_extension (Temp_extension)
			replacement_path := a_file_path.with_new_extension (target_extension)
		end

feature -- Access

	file_path: EL_FILE_PATH

	replacement_path: EL_FILE_PATH

feature -- Basic operations

	swap
		do
			if replacement_path.exists then
				File_system.rename_file (file_path, temp_path)
				File_system.rename_file (replacement_path, file_path)
			end
		end

	undo
		-- swap files back to original state
		do
			if temp_path.exists then
				File_system.rename_file (file_path, replacement_path)
				File_system.rename_file (temp_path, file_path)
			end
		end

feature {NONE} -- Internal attributes

	temp_path: EL_FILE_PATH

feature {NONE} -- Constants

	Temp_extension: READABLE_STRING_GENERAL
		once
			Result := "temp"
		end
end