note
	description: "Application constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-01 14:46:12 GMT (Sunday 1st September 2024)"
	revision: "19"

deferred class
	EL_APPLICATION_CONSTANTS

inherit
	EL_MODULE_EXECUTABLE; EL_MODULE_TUPLE

feature {NONE} -- Constants

	Package_dir: DIR_PATH
		once
			if Executable.is_work_bench then
			-- Eg. "build/win64/package"
				create Result.make_expanded ("build/$ISE_PLATFORM/package")
			else
			-- This is assumed to be the directory 'package/bin' unpacked by installer to a temporary directory
				Result := Executable.parent_dir.parent
			end
		end

	File_placeholder: IMMUTABLE_STRING_8
		once
			if {PLATFORM}.is_windows then
				create Result.make_empty -- Modern Windows does not have %1 which used to work on XP
			else
				Result := "'%%f'" -- XDG file argument
			end
		end

	Standard_option: TUPLE [config, file, install, main, remove_data, silent, uninstall: IMMUTABLE_STRING_8]
		-- standard sub-application and command line option names
		once
			create Result
			Tuple.fill_immutable (Result, "config, file, install, main, remove_data, silent, uninstall")
		end

end