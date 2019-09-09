note
	description: "Exclusion list file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-09-20 11:35:12 GMT (Thursday 20th September 2018)"
	revision: "4"

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
