note
	description: "Application constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "15"

deferred class
	EL_APPLICATION_CONSTANTS

inherit
	EL_MODULE_EXECUTABLE; EL_MODULE_TUPLE

feature {NONE} -- Constants

	Package_dir: DIR_PATH
		once
			if Executable.is_work_bench then
				Result := "build/$ISE_PLATFORM/package"; Result.expand
					-- Eg. "build/win64/package"
			else
				-- This is assumed to be the directory 'package/bin' unpacked by installer to a temporary directory
				Result := Executable.parent_dir.parent
			end
		end

	File_placeholder: STRING = "%%f"

	Standard_option: TUPLE [config, file, install, main, remove_data, silent, uninstall: IMMUTABLE_STRING_8]
		-- standard sub-application and command line option names
		once
			create Result
			Tuple.fill_immutable (Result, "config, file, install, main, remove_data, silent, uninstall")
		end

end