note
	description: "Summary description for {EL_SHARED_DIRECTORY}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-06-27 18:13:48 GMT (Saturday 27th June 2015)"
	revision: "6"

class
	EL_SHARED_DIRECTORY

feature {NONE} -- Implementation

	named_directory (path: EL_DIR_PATH): EL_DIRECTORY
		do
			Result := Directory
			Result.make_with_name (path.unicode)
		end

feature {NONE} -- Constants

	Directory: EL_DIRECTORY
			--
		once
			create Result
		end

end
