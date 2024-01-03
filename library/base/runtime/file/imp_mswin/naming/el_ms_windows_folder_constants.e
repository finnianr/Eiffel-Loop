note
	description: "MS Windows folder constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-03 16:29:38 GMT (Wednesday 3rd January 2024)"
	revision: "8"

class
	EL_MS_WINDOWS_FOLDER_CONSTANTS

feature -- Access

	common_desktop: INTEGER
			-- The file system directory that contains files and folders that appear on the desktop for all users.
			-- A typical path is C:\Documents and Settings\All Users\Desktop.
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_COMMON_DESKTOPDIRECTORY"
		end

	common_programs: INTEGER
			-- The file system directory that contains the directories for the common program groups
			-- that appear on the Start menu for all users.
			-- typical path is C:\Documents and Settings\All Users\Start Menu\Programs
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_COMMON_PROGRAMS"
		end

	desktop: INTEGER
			-- The file system directory used to physically store file objects on the desktop
			-- (not to be confused with the desktop folder itself).
			-- A typical path is C:\Documents and Settings\username\Desktop.		
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_DESKTOPDIRECTORY"
		end

	my_documents: INTEGER
			-- typical path is "C:\Users\xxx\My Documents".
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_MYDOCUMENTS"
		end

	program_files: INTEGER
			-- typical path is C:\Program Files.
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_PROGRAM_FILES"
		end

	user_profile: INTEGER
			-- typical path is C:\Users\<username>.
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_PROFILE"
		end

	system: INTEGER
			-- The Windows System folder.
			-- A typical path is C:\Windows\System32.
		external
			"C [macro <Shlobj.h>]"
		alias
			"CSIDL_SYSTEM"
		end

end