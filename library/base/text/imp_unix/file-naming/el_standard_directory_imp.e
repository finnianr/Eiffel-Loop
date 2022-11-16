note
	description: "Unix implementation of [$source EL_STANDARD_DIRECTORY_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	EL_STANDARD_DIRECTORY_IMP

inherit
	EL_STANDARD_DIRECTORY_I

	EL_OS_IMPLEMENTATION

feature -- Access

	Applications: DIR_PATH
		once
			Result := "/opt"
		end

	Documents: DIR_PATH
		once
			Result := Home.joined_dir_tuple (["Documents"])
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
			Result := Home.joined_dir_tuple ([".local/share"])
		end

	Root: STRING_32
		once
			Result := "root"
		end

	System_command: DIR_PATH
		once
			Result := "/usr/bin"
		end

end