note
	description: "Ms windows directories"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-07 11:06:40 GMT (Sunday 7th January 2024)"
	revision: "13"

class
	EL_MS_WINDOWS_DIRECTORIES

inherit
	EXECUTION_ENVIRONMENT
		export
			{NONE} all
		end

	EL_MODULE_DIRECTORY

	EL_SHARED_NATIVE_STRING

	EL_WIN_32_C_API

feature -- Access

	Desktop_common: DIR_PATH
		once
			Result := win_folder_path (c_folder_id_common_desktop)
		end

	Desktop: DIR_PATH
		once
			Result := win_folder_path (c_folder_id_desktop)
		end

	User, User_profile_dir: DIR_PATH
		once
			Result := win_folder_path (c_folder_id_user_profile)
		end

	My_documents: DIR_PATH
			--
		once
			Result := win_folder_path (c_folder_id_my_documents)
		end

	Program_files_dir: DIR_PATH
			--
		once
			Result := win_folder_path (c_folder_id_program_files)
		end

	Start_menu_programs_dir: DIR_PATH
		once
			Result := win_folder_path (c_folder_id_common_programs)
		end

	System_dir: DIR_PATH
			--
		once
			Result := win_folder_path (c_folder_id_system)
		end

	Executable_extensions_spec: ZSTRING
		once
			Result := item ("PATHEXT")
		end

feature {NONE} -- Implementation

	win_folder_path (folder_id: INTEGER): DIR_PATH
		local
			status_code: INTEGER
		do
			if attached Native_string as folder_path then
				folder_path.set_empty_capacity (max_path_count)
				status_code := c_shell32_get_folder_path (folder_id, folder_path.item)
				Result := folder_path.to_string
			end
		end
end