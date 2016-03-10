note
	description: "Summary description for {GENRE_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	PYXIS_GENRE_LIST

inherit
	LINKED_LIST [EL_ASTRING]
		rename
			make as make_list
		end

	EL_PYXIS_STRING_LIST
		undefine
			is_equal, copy
		redefine
			make
		end

create
	make, make_from_file, make_from_string

feature {NONE} -- Initialization

	make
		do
			make_list
			compare_objects
			Precursor
		end

feature {NONE} -- Constants

	Root_node_name: STRING = "genres"

end
