note
	description: "Shared directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 17:36:20 GMT (Saturday 19th May 2018)"
	revision: "3"

class
	EL_SHARED_DIRECTORY

feature {NONE} -- Implementation

	named_directory (path: EL_DIR_PATH): EL_DIRECTORY
		do
			Result := Directory
			Result.make_with_name (path.as_string_32)
		end

feature {NONE} -- Constants

	Directory: EL_DIRECTORY
			--
		once
			create Result
		end

end
