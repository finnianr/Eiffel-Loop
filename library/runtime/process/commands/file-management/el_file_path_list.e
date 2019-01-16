note
	description: "File path list from OS command"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-09 15:41:00 GMT (Wednesday 9th January 2019)"
	revision: "4"

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

	EL_MODULE_OS
		undefine
			is_equal, copy
		end

create
	make, make_empty, make_with_count, make_from_array, make_from_tuple

feature {NONE} -- Initialization

	make (a_dir_path: EL_DIR_PATH; wildcard: STRING)
			--
		do
			make_empty
			append_files (a_dir_path, wildcard)
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
						extend (create {EL_FILE_PATH}.make_from_general (general))
					end
				else
					check invalid_tuple_type: False end
				end
				i := i + 1
			end
		end

feature -- Element change

	append_files (a_dir_path: EL_DIR_PATH; wildcard: STRING)
		do
			append (OS.file_list (a_dir_path, wildcard))
		end

end
