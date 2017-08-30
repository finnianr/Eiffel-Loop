note
	description: "Class for appropriately encoding strings for output to console"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
		do
			if Is_console_utf_8_encoded then
				Unicode.convert_to (Utf_8, str)
			else
				Unicode.convert_to (Console_encoding, str)
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
				-- If the have forgotten to set LANG in execution parameters assume that developers have their console set to UTF-8
				Result := True
			else
				Result := Console_encoding.code_page ~ Utf_8.code_page
			end
		end

end
