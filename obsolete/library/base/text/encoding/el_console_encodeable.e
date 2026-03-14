note
	description: "Class for encoding strings for output to console"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-09-13 10:48:57 GMT (Sunday 13th September 2020)"
	revision: "3"

class
	EL_CONSOLE_ENCODEABLE

inherit
	EL_SYSTEM_ENCODINGS
		rename
			Utf32 as Unicode,
			Utf8 as Utf_8
		export
			{NONE} all
		end

	EL_MODULE_EXECUTABLE

obsolete
	"Use {EL_MODULE_CONSOLE} instead"

feature {NONE} -- Implementation

	console_encoded (str: READABLE_STRING_GENERAL): STRING_8
		local
			l_encoding: ENCODING; done: BOOLEAN
		do
			if Is_console_utf_8_encoded then
				l_encoding := Utf_8
			else
				l_encoding := Console
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

feature -- Status query

	Is_console_utf_8_encoded: BOOLEAN
		once
			if {PLATFORM}.is_unix and then Executable.is_work_bench
				and then Console.code_page ~ Default_workbench_codepage
			then
				-- If the have forgotten to set LANG in execution parameters assume that
				-- developers have their console set to UTF-8
				Result := True
			else
				Result := Console.code_page ~ Utf_8.code_page
			end
		end

feature -- Constants

	Default_workbench_codepage: STRING = "ANSI_X3.4-1968"

end
