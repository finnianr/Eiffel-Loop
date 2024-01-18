note
	description: "[
		Implementation of field ordering and shifting to be applied to an instance of
		${EL_FIELD_LIST} associated with object conforming to ${EL_REFLECTIVE}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 11:11:53 GMT (Monday 14th August 2023)"
	revision: "5"

class
	EL_FIELD_LIST_ORDER

create
	make, make_alphabetical, make_default

feature {NONE} -- Initialization

	make (a_reordered_fields: STRING)
		do
			make_default
			reordered_fields := a_reordered_fields
		end

	make_alphabetical (a_reordered_fields: STRING)
		do
			make (a_reordered_fields)
			set_alphabetical_sort
		end

	make_default
		do
			create reordered_fields.make_empty
			create field_shifts.make_empty
		end

feature -- Access

	field_shifts: ARRAY [TUPLE [index: INTEGER_32; offset: INTEGER_32]]
		-- arguments to be applied to `Result.shift_i_th' in `{EL_CLASS_META_DATA}.new_field_list'
		-- after applying `name_sort'

	name_sort: detachable FUNCTION [EL_REFLECTED_FIELD, IMMUTABLE_STRING_8]
		-- sorting function to be applied to result of `{EL_CLASS_META_DATA}.new_field_list'

	reordered_fields: STRING
		-- comma separated list of explicitly ordered fields to be shifted to the end of `Meta_data.field_list'
		-- after the `name_sort' function has been applied

feature -- Element change

	set_name_sort (a_name_sort: FUNCTION [EL_REFLECTED_FIELD, IMMUTABLE_STRING_8])
		do
			name_sort := a_name_sort
		end

	set_alphabetical_sort
		do
			name_sort := agent {EL_REFLECTED_FIELD}.name
		end

end