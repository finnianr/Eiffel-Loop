note
	description: "Windows package building contants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:52:09 GMT (Monday 3rd January 2022)"
	revision: "10"

deferred class
	PACKAGE_BUILD_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Exe_path_template: ZSTRING
		once
			Result := "build/%S/package/bin/%S"
		end

	Project_py: FILE_PATH
		once
			Result := "project.py"
		end

	ISE_platform_table: EL_HASH_TABLE [STRING, INTEGER]
		once
			create Result.make (<< [32, "windows"], [64, "win64"] >>)
		end

end