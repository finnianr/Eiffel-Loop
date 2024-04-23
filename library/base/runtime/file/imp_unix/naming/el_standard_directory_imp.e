note
	description: "Unix implementation of ${EL_STANDARD_DIRECTORY_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-22 15:00:55 GMT (Monday 22nd April 2024)"
	revision: "16"

class
	EL_STANDARD_DIRECTORY_IMP

inherit
	EL_STANDARD_DIRECTORY_I

	EL_UNIX_IMPLEMENTATION

feature -- Access

	Applications: DIR_PATH
		once
			Result := "/opt"
		end

	Documents: DIR_PATH
		once
			Result := Home #+ "Documents"
		end

	Desktop, Desktop_common: DIR_PATH
		once
			Result := Home #+ "Desktop"
		end

	Home: DIR_PATH
		-- same as $HOME if user is not root
		once
			create Result.make_expanded ("/home/$USER")
		end

	User_local: DIR_PATH
		once
			Result := Home #+ ".local/share"
		end

	System_command: DIR_PATH
		once
			Result := "/usr/bin"
		end

end