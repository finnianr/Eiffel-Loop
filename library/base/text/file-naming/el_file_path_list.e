note
	description: "File path list sortable by path, base name or file size."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-11 18:15:28 GMT (Wednesday 11th September 2019)"
	revision: "8"

class
	EL_FILE_PATH_LIST

inherit
	EL_SORTABLE_ARRAYED_LIST [EL_FILE_PATH]
		rename
			make as make_with_count,
			first as first_path,
			item as path,
			last as last_path
		redefine
			make_from_tuple
		end

	EL_MODULE_FILE_SYSTEM

create
	make, make_empty, make_with_count, make_from_array, make_from_tuple

feature {NONE} -- Initialization

	make (list: ITERABLE [EL_FILE_PATH])
		require
			finite: attached {FINITE [EL_FILE_PATH]} list
		do
			if attached {FINITE [EL_FILE_PATH]} list as finite then
				make_with_count (finite.count)
				across list as it loop
					extend (it.item)
				end
			end
		end

	make_from_tuple (tuple: TUPLE)
		local
			i: INTEGER
		do
			make_with_count (tuple.count)
			from i := 1 until i > tuple.count loop
				if tuple.is_reference_item (i) then
					if attached {EL_FILE_PATH} tuple.reference_item (i) as file_path then
						extend (file_path)

					elseif attached {READABLE_STRING_GENERAL} tuple.reference_item (i) as general then
						extend (create {EL_FILE_PATH}.make (general))
					end
				else
					check invalid_tuple_type: False end
				end
				i := i + 1
			end
		end

feature -- Basic operations

	sort_by_base (in_ascending_order: BOOLEAN)
		local
			map: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [ZSTRING, EL_FILE_PATH]
		do
			create map.make_sorted (Current, agent {EL_FILE_PATH}.base, in_ascending_order)
			make_from_array (map.value_list.to_array)
		end

	sort_by_size (in_ascending_order: BOOLEAN)
		local
			map: EL_KEY_SORTABLE_ARRAYED_MAP_LIST [INTEGER, EL_FILE_PATH]
		do
			create map.make_sorted (Current, agent File_system.file_byte_count, in_ascending_order)
			make_from_array (map.value_list.to_array)
		end

end
