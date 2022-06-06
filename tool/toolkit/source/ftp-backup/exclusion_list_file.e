note
	description: "Exclusion list file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-09 15:56:26 GMT (Sunday 9th January 2022)"
	revision: "6"

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