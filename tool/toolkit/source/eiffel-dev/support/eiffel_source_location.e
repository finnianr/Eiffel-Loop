note
	description: "Summary description for {EIFFEL_SOURCE_LOCATION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-04-04 10:23:52 GMT (Monday 4th April 2016)"
	revision: "8"

class
	EIFFEL_SOURCE_LOCATION

inherit
	EVOLICITY_EIFFEL_CONTEXT
		rename
			make_default as make
		undefine
			is_equal
		redefine
			make
		end

	EL_EIF_OBJ_BUILDER_CONTEXT
		rename
			make_default as make
		undefine
			is_equal
		redefine
			make
		end

	COMPARABLE

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			create name.make_empty
			create dir_path
			Precursor {EVOLICITY_EIFFEL_CONTEXT}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature -- Access

	name: ZSTRING

	dir_path: EL_DIR_PATH

	file_list: EL_FILE_PATH_LIST
		do
			create Result.make (dir_path, "*.e")
		end

feature -- Comparison

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			Result := name < other.name
		end

feature {NONE} -- Evolicity fields

	getter_function_table: like getter_functions
			--
		do
			create Result.make (<<
				["name", 			agent: like name do Result := name end],
				["file_list", 		agent: like file_list do Result := file_list end]
			>>)
		end

feature {NONE} -- Build from Pyxis

	building_action_table: like Type_building_actions
		do
			create Result.make (<<
				["@name", agent do name := node.to_string end],
				["text()", agent do dir_path := node.to_string; dir_path.expand end]
			>>)
		end
end
