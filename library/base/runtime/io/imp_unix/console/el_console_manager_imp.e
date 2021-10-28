note
	description: "Unix implementation of [$source EL_CONSOLE_MANAGER_I] interface"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-26 9:44:28 GMT (Tuesday 26th October 2021)"
	revision: "7"

class
	EL_CONSOLE_MANAGER_IMP

inherit
	EL_CONSOLE_MANAGER_I

	EL_OS_IMPLEMENTATION

	EL_MODULE_EXECUTABLE

create
	make

feature -- Status query

	is_highlighting_enabled: BOOLEAN
			-- Can terminal color highlighting sequences be output to console
		once
			Result := not Base_option.no_highlighting
		end

	is_utf_8_encoded: BOOLEAN
		do
			if Executable.is_work_bench and then code_page ~ Default_workbench_codepage then
				-- If LANG is not set in execution parameters assume that
				-- developers have their console set to UTF-8
				Result := True
			else
				Result := code_page ~ Utf_8.code_page
			end
		end

feature {NONE} -- Constants

	Default_workbench_codepage: STRING = "ANSI_X3.4-1968"

end