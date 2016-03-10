note
	description: "[
		Convenience class to store all element values for a context in a table but without recursing deeper
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_EIF_OBJ_TEXT_TABLE_CONTEXT

inherit
	HASH_TABLE [STRING, STRING]
		rename
			make as make_table
		end

	EL_EIF_OBJ_XPATH_CONTEXT
		rename
			do_with_xpath as put_text_value
		undefine
			copy, is_equal
		redefine
			make
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_table (5)
			compare_objects
			Precursor
		end

feature {NONE} -- Implementation

	put_text_value
			-- Put element text value with element name key
		do
			if xpath.occurrences ('/') = 1 and then xpath.ends_with ("text()") then
				put (node.to_string, xpath.substring (1, xpath.index_of ('/', 1) - 1))
			end
		end

end
