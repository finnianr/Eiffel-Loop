note
	description: "Windows implementation of [$source EL_EXECUTABLE_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-22 9:25:23 GMT (Tuesday 22nd September 2020)"
	revision: "2"

class
	EL_EXECUTABLE_IMP

inherit
	EL_EXECUTABLE_I
		export
			{NONE} all
		end

	EL_OS_IMPLEMENTATION

	EL_MS_WINDOWS_DIRECTORIES
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Implementation

	file_extensions: EL_ZSTRING_LIST
		do
			-- C:\Users\finnian>echo %PATHEXT%
			-- .COM;.EXE;.BAT;.CMD;.VBS;.VBE;.JS;.JSE;.WSF;.WSH;.MSC	
			create Result.make_from_list (Executable_extensions_spec.as_lower.split_intervals (";."))
			Result.first.remove_head (1)
		end

feature {NONE} -- Constants

	Search_path_separator: CHARACTER_32 = ';'

end