note
	description: "Unix implementation of [$source EL_STANDARD_DIRECTORY_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-20 11:38:02 GMT (Monday 20th April 2020)"
	revision: "8"

class
	EL_STANDARD_DIRECTORY_IMP

inherit
	EL_STANDARD_DIRECTORY_I

	EL_OS_IMPLEMENTATION

feature -- Access

	Applications: EL_DIR_PATH
		once
			Result := "/opt"
		end

	Documents: EL_DIR_PATH
		once
			Result := Home.joined_dir_tuple (["Documents"])
		end

	Desktop: EL_DIR_PATH
		once
			Result := Home.joined_dir_path ("Desktop")
		end

	Home: EL_DIR_PATH
		-- same as $HOME if user is not root
		once
			Result := "/home/$USER"
			Result.expand
		end

	User_local: EL_DIR_PATH
		once
			Result := Home.joined_dir_tuple ([".local/share"])
		end

	Desktop_common: EL_DIR_PATH
		once
			Result := Desktop
		end

	Root: STRING_32
		once
			Result := "root"
		end

	System_command: EL_DIR_PATH
		once
			Result := "/usr/bin"
		end

end
