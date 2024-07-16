note
	description: "[
		Convenience class to store all element values for a context in a table but without recursing deeper
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-07-16 15:39:54 GMT (Tuesday 16th July 2024)"
	revision: "8"

class
	EL_EIF_OBJ_TEXT_TABLE_CONTEXT

inherit
	HASH_TABLE [ZSTRING, STRING]
		rename
			make as make_table
		end

	EL_EIF_OBJ_XPATH_CONTEXT
		rename
			do_with_xpath as put_text_value
		undefine
			copy, is_equal
		end

	EL_XPATH_NODE_CONSTANTS

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_equal (5)
			make_default
		end

feature {NONE} -- Implementation

	put_text_value
			-- Put element text value with element name key
		do
			if xpath.occurrences ('/') = 1 and then xpath.ends_with_general (Node_name [Type_text]) then
				put (node.to_string, xpath.substring (1, xpath.index_of ('/', 1) - 1))
			end
		end

end