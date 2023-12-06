note
	description: "HTTP parameter list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-06 11:03:56 GMT (Wednesday 6th December 2023)"
	revision: "15"

class
	EL_HTTP_PARAMETER_LIST

inherit
	EL_ARRAYED_LIST [EL_HTTP_PARAMETER]
		rename
			make as make_size,
			make_from_array as make
		end

	EL_HTTP_PARAMETER
		undefine
			is_equal, copy
		redefine
			add_to_list
		end

	EL_REFLECTION_HANDLER

create
	make_size, make, make_from_object

convert
	make ({ARRAY [EL_HTTP_PARAMETER]})

feature {NONE} -- Initialization

	make_from_object (object: EL_REFLECTIVE)
		local
			i: INTEGER
		do
			if attached object.meta_data.field_list as field_list then
				make_size (field_list.count)
				from i := 1 until i > field_list.count loop
					extend (create {EL_HTTP_NAME_VALUE_PARAMETER}.make_from_field (object, field_list [i]))
					i := i + 1
				end
			end
		end

feature -- Conversion

	to_table: EL_URI_QUERY_ZSTRING_HASH_TABLE
		do
			create Result.make_equal (count)
			add_to_table (Result)
		end

feature -- Element change

	append_tuple (tuple: TUPLE)
		local
			i: INTEGER
		do
			from i := 1 until i > tuple.count loop
				if attached {EL_HTTP_PARAMETER} tuple.reference_item (i) as p then
					extend (p)
				elseif attached {EL_REFLECTIVELY_CONVERTIBLE_TO_HTTP_PARAMETER} tuple.reference_item (i) as c then
					extend (c.to_parameter)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	add_to_table (table: like to_table)
		do
			from start until after loop
				item.add_to_table (table)
				forth
			end
		end

	add_to_list (list: EL_HTTP_PARAMETER_LIST)
		do
			list.append_sequence (Current)
		end

end