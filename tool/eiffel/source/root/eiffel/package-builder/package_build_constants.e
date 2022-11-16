note
	description: "Windows package building contants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "11"

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