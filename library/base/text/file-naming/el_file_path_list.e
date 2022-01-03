note
	description: "File path list sortable by path, base name or file size."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-03 15:54:04 GMT (Monday 3rd January 2022)"
	revision: "18"

class
	EL_FILE_PATH_LIST

inherit
	EL_SORTABLE_ARRAYED_LIST [FILE_PATH]
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

	make (list: ITERABLE [FILE_PATH])
		do
			make_with_count (Iterable.count (list))
			across list as l_path loop
				extend (l_path.item)
			end
		end

	make_from_tuple (tuple: TUPLE)
		local
			i: INTEGER
		do
			make_with_count (tuple.count)
			from i := 1 until i > tuple.count loop
				if tuple.is_reference_item (i) then
					if attached {FILE_PATH} tuple.reference_item (i) as file_path then
						extend (file_path)

					elseif attached {READABLE_STRING_GENERAL} tuple.reference_item (i) as general then
						extend (create {FILE_PATH}.make (general))
					end
				else
					check invalid_tuple_type: False end
				end
				i := i + 1
			end
		end

feature -- Conversion

	as_escaped: EL_ZSTRING_LIST
		do
			create Result.make (count)
			across Current as l_path loop
				Result.extend (l_path.item.escaped)
			end
		end

feature -- Basic operations

	sort_by_base (in_ascending_order: BOOLEAN)
		do
			make_from_array (ordered_by (agent {FILE_PATH}.base, in_ascending_order).to_array)
		end

	sort_by_size (in_ascending_order: BOOLEAN)
		do
			make_from_array (ordered_by (agent File_system.file_byte_count, in_ascending_order).to_array)
		end

feature -- Cursor movement

	find_first_base (base: ZSTRING)
		do
			find_first_true (agent base_matches (?, base))
		end

feature {NONE} -- Implementation

	base_matches (a_path: FILE_PATH; base: ZSTRING): BOOLEAN
		do
			Result := a_path.base ~ base
		end
end