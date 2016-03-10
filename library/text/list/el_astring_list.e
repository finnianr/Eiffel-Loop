note
	description: "Summary description for {EL_ASTRING_LIST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_ASTRING_LIST

inherit
	EL_STRING_LIST [EL_ASTRING]

create
	make, make_empty, make_with_separator, make_with_lines, make_with_words, make_from_array

convert
	make_from_array ({ARRAY [EL_ASTRING]})
	
end
