note
	description: "File list filter condition is met if path base name matches any in list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-05 15:20:07 GMT (Monday 5th December 2022)"
	revision: "3"

class
	EL_BASE_NAME_IN_LIST_FIND_CONDITION

inherit
	EL_FIND_FILE_CONDITION

create
	make

feature {NONE} -- Initialization

	make (a_base_name_list: ITERABLE [READABLE_STRING_GENERAL])
		do
			create base_name_list.make_from_general (a_base_name_list)
		end

feature {NONE} -- Status query

	met (path: ZSTRING): BOOLEAN
		local
			separator: CHARACTER_32
		do
			separator := Operating_environment.Directory_separator
			across base_name_list as list until Result loop
				if path.ends_with_zstring (list.item) then
					if path.count = list.item.count then
						Result := True
					else
						Result := path [path.count - list.item.count] = separator
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	base_name_list: EL_ZSTRING_LIST
end