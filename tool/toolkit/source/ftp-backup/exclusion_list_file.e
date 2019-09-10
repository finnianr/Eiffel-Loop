note
	description: "Exclusion list file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-09 16:42:28 GMT (Monday 9th September 2019)"
	revision: "5"

class
	EXCLUSION_LIST_FILE

inherit
	TAR_LIST_FILE

create
	make

feature {NONE} -- Constants

	specifier_list: EL_ZSTRING_LIST
			--
		once
			Result := backup.exclude_list
		end

	File_name: STRING
			--
		once
			Result := "exclude.txt"
		end

end
