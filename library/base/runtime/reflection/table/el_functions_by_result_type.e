note
	description: "Functions by result type"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-03 11:22:14 GMT (Thursday 3rd October 2019)"
	revision: "2"

class
	EL_FUNCTIONS_BY_RESULT_TYPE

inherit
	HASH_TABLE [FUNCTION [ANY], INTEGER_32]
		rename
			make as make_table
		end

create
	make

feature {NONE} -- Initialization

	make (functions: ARRAY [like item])
		do
			make_table (functions.count)
			extend_from_array (functions)
		end

feature -- Element change

	extend_from_array (functions: ARRAY [like item])
		do
			across functions as f loop
				put (f.item, f.item.generating_type.generic_parameter_type (2).type_id)
			end
		end

end
