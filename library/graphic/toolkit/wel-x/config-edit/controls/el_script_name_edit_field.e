note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

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


