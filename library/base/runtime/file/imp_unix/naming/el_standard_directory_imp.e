note
	description: "Unix implementation of ${EL_STANDARD_DIRECTORY_I} interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "15"

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
			Result := "/home/$USER"
			Result.expand
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