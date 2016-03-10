note
	description: "Summary description for {EL_MS_WINDOWS_DIRECTORIES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-01-24 11:49:31 GMT (Friday 24th January 2014)"
	revision: "3"

class
	EL_MS_WINDOWS_DIRECTORIES

inherit
	EXECUTION_ENVIRONMENT

	EL_MODULE_DIRECTORY

feature -- Access

	user_profile_dir: EL_DIR_PATH
		do
			Result := win_folder_path (FOLDER_user_profile)
		end

	program_files_dir: EL_DIR_PATH
			--
		do
			Result := win_folder_path (FOLDER_program_files)
		end

	start_menu_programs_dir: EL_DIR_PATH
		do
			Result := win_folder_path (FOLDER_common_programs)
		end

	system_dir: EL_DIR_PATH
			--
		do
			Result := win_folder_path (FOLDER_system)
		end

	executable_extensions_spec: EL_ASTRING
		do
			Result := item ("PATHEXT")
		end

feature {NONE} -- Implementation

	win_folder_path (folder_id: INTEGER): EL_DIR_PATH
		local
			l_max_path, l_path: EL_C_WIDE_CHARACTER_STRING
			status_code: INTEGER
		do
			create l_max_path.make (max_path)
			status_code := c_shell32_get_folder_path (folder_id, l_max_path.base_address)
			create l_path.make_shared (l_max_path.base_address)
			Result := l_path.as_string
		end

feature {NONE} -- C Externals

	max_path: INTEGER
			-- Maximum number of characters in path
		external
			"C [macro <limits.h>]"
		alias
			"MAX_PATH"
		end

	FOLDER_common_programs: INTEGER
			-- The file system directory that contains the directories for the common program groups
			-- that appear on the Start menu for all users.
			-- typical path is C:\Documents and Settings\All Users\Start Menu\Programs
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_COMMON_PROGRAMS"
		end

	FOLDER_program_files: INTEGER
			-- typical path is C:\Program Files.
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_PROGRAM_FILES"
		end

	FOLDER_user_profile: INTEGER
			-- typical path is C:\Users\<username>.
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_PROFILE"
		end

	FOLDER_system: INTEGER
			-- The Windows System folder.
			-- A typical path is C:\Windows\System32.
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_SYSTEM"
		end

	c_shell32_get_folder_path (folder_id: INTEGER; a_path_out: POINTER): INTEGER
			--
		external
			"C inline use <Shlobj.h>"
		alias
			"SHGetFolderPath (NULL, $folder_id, NULL, 0, $a_path_out)"
		end

end
