note
	description: "Cross platform Eiffel development constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-29 13:40:12 GMT (Monday 29th January 2024)"
	revision: "5"

deferred class
	CROSS_PLATFORM_CONSTANTS

inherit
	EL_ANY_SHARED

	EL_MODULE_TUPLE

feature {NONE} -- Strings

	Eifgens_dir: ZSTRING
		once
			Result := "build/%S/EIFGENs"
		end

	Exe_path_template: ZSTRING
		once
			Result := "build/%S/package/bin/%S"
		end

	Implementation_ending: ZSTRING
		once
			Result := "_imp.e"
		end

	Interface_ending: ZSTRING
		once
			Result := "_i.e"
		end

feature {NONE} -- Constants

	F_code_dir: DIR_PATH
		once
			Result := "build/$ISE_PLATFORM/EIFGENs/classic/F_code"
			Result.expand
		end

	Platform: TUPLE [linux_x86_64, win64, windows: IMMUTABLE_STRING_8]
		once
			create Result
			Tuple.fill_immutable (Result, "linux-x86-64, win64, windows")
		end

	Platform_list: EL_IMMUTABLE_STRING_8_LIST
		once
			create Result.make_from_tuple (Platform)
		end

	Windows_platform_table: EL_HASH_TABLE [IMMUTABLE_STRING_8, INTEGER]
		once
			create Result.make (<< [32, Platform.windows], [64, Platform.win64] >>)
		end

end