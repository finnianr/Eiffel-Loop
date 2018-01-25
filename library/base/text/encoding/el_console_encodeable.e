note
	description: "Class for appropriately encoding strings for output to console"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-01-24 9:35:52 GMT (Wednesday 24th January 2018)"
	revision: "2"

class
	EL_CONSOLE_ENCODEABLE

inherit
	SYSTEM_ENCODINGS
		rename
			Utf32 as Unicode,
			Utf8 as Utf_8
		export
			{NONE} all
		end

	EL_MODULE_EXECUTION_ENVIRONMENT

feature {NONE} -- Implementation

	console_encoded (str: READABLE_STRING_GENERAL): STRING_8
		local
			l_encoding: ENCODING; done: BOOLEAN
		do
			if Is_console_utf_8_encoded then
				l_encoding := Utf_8
			else
				l_encoding := Console_encoding
			end
			-- Fix for bug where LANG=C in Nautilus F10 terminal caused a crash
			from until done loop
				Unicode.convert_to (l_encoding, str)
				if Unicode.last_conversion_successful then
					done := True
				else
					l_encoding := Utf_8
				end
			end
			Result := Unicode.last_converted_string_8
		end

feature -- Constants

	Default_workbench_codepage: STRING = "ANSI_X3.4-1968"

	Is_console_utf_8_encoded: BOOLEAN
		once
			if {PLATFORM}.is_unix and then Execution_environment.is_work_bench_mode
				and then Console_encoding.code_page ~ Default_workbench_codepage
			then
				-- If the have forgotten to set LANG in execution parameters assume that
				-- developers have their console set to UTF-8
				Result := True
			else
				Result := Console_encoding.code_page ~ Utf_8.code_page
			end
		end

end
