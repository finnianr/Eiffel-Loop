note
	description: "Path constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-14 10:32:05 GMT (Sunday 14th January 2024)"
	revision: "17"

deferred class
	EL_PATH_CONSTANTS

inherit
	EL_SHARED_ZSTRING_CODEC

feature -- Strings

	Back_dir_step: ZSTRING
		once
			Result := "../"
		end

	Debug_template: ZSTRING
		once
			Result := "[%S] %S"
		end

	Empty_path: ZSTRING
		once
			create Result.make_empty
		end

	Forward_slash: ZSTRING
		once
			Result := "/"
		end

	Square_brackets: STRING_32
		once
			Result := "[] "
		end

	Variable_cwd: ZSTRING
		once
			Result := "$CWD"
		end

feature -- Characters

	Separator: CHARACTER_32
		once
			Result := Operating_environment.Directory_separator
		end

	Unix_separator: CHARACTER_32 = '/'

	Windows_separator: CHARACTER_32 = '\'

feature {NONE} -- Constants

	Magic_number: INTEGER = 8388593
		-- Greatest prime lower than 2^23
		-- so that this magic number shifted to the left does not exceed 2^31.

	Parent_set: EL_HASH_SET [ZSTRING]
			--
		once
			create Result.make (100)
		end

	URI_path_string: EL_URI_PATH_STRING_8
		once
			create Result.make_empty
		end
end