note
	description: "Application constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-06 16:58:34 GMT (Sunday 6th February 2022)"
	revision: "12"

deferred class
	EL_APPLICATION_CONSTANTS

inherit
	EL_MODULE_EXECUTABLE

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

end