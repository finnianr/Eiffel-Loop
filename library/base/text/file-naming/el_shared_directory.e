note
	description: "Shared directory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:26:08 GMT (Monday 1st July 2019)"
	revision: "5"

deferred class
	EL_SHARED_DIRECTORY

inherit
	EL_ANY_SHARED

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
