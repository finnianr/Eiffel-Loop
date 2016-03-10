note
	description: "Summary description for {CLUSTER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 19:58:20 GMT (Monday 22nd July 2013)"
	revision: "3"

class
	CLUSTER

inherit
	EVOLICITY_EIFFEL_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (a_name: EL_DIR_PATH; class_file_path_list: LIST [EL_FILE_PATH])
			--
		do
			make_eiffel_context
			create class_info_list.make
			if a_name.is_empty then
				name := "root"
			else
				name := a_name
			end
			across class_file_path_list as file_path loop
				class_info_list.extend (create {CLASS_INFO}.make (file_path.item))
			end
		end

feature -- Access

	class_info_list: PART_SORTED_TWO_WAY_LIST [CLASS_INFO]

	name: EL_DIR_PATH

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["class_info_list", 	agent: ITERABLE [CLASS_INFO]  do Result := class_info_list end],
				["name", 				agent: EL_ASTRING do Result := name.to_string end]
			>>)
		end

end
