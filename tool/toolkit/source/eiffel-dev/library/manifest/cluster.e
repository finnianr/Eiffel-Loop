note
	description: "Summary description for {CLUSTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-01-10 10:52:53 GMT (Saturday 10th January 2015)"
	revision: "6"

class
	CLUSTER

inherit
	EVOLICITY_EIFFEL_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (a_path: EL_DIR_PATH; class_file_path_list: LIST [EL_FILE_PATH])
			--
		do
			make_default
			create class_info_list.make
			if a_path.is_empty then
				path := "root"
			else
				path := a_path
			end
			across class_file_path_list as file_path loop
				class_info_list.extend (create {CLASS_INFO}.make (file_path.item))
			end
		end

feature -- Access

	class_info_list: PART_SORTED_TWO_WAY_LIST [CLASS_INFO]

	path: EL_DIR_PATH

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["class_info_list", 	agent: ITERABLE [CLASS_INFO]  do Result := class_info_list end],
				["path", 				agent: like path do Result := path end]
			>>)
		end

end
