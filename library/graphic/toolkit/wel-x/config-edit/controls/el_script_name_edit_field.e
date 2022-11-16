note
	description: "Script name edit field"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:05 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_SCRIPT_NAME_EDIT_FIELD

inherit
	EL_TEXT_EDIT_FIELD
		rename
			text as file_name
		redefine
			apply_edit
		end

create
	make

feature -- Basic operations

	apply_edit
			--
		do
			if file_name.is_equal (Default_script_file_name)
				or file_exists (file_name)
			then
				Precursor
			end
		end

feature {NONE} -- Implementation

	file_exists (filename: STRING): BOOLEAN
			-- Does `filename' exist?
		require
			filename_not_void: filename /= Void
		local
			a_file: PLAIN_TEXT_FILE
		do
			create a_file.make (filename)
			Result := a_file.exists
		end

feature -- Constants

	Default_script_file_name: STRING = "default"

end