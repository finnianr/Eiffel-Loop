note
	description: "Exclusion list file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	EXCLUSION_LIST_FILE

inherit
	TAR_LIST_FILE

create
	make

feature {NONE} -- Implementation

	specifier_list: EL_ZSTRING_LIST
			--
		do
			Result := backup.exclude_list
		end

feature {NONE} -- Constants

	File_name: STRING
			--
		once
			Result := "exclude.txt"
		end

end