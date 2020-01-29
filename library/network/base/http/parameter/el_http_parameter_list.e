note
	description: "HTTP parameter list"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-29 16:33:01 GMT (Wednesday 29th January 2020)"
	revision: "8"

class
	EL_HTTP_PARAMETER_LIST

inherit
	EL_ARRAYED_LIST [EL_HTTP_PARAMETER]
		rename
			make as make_size,
			make_from_array as make
		end

	EL_HTTP_PARAMETER
		rename
			extend as extend_table
		undefine
			is_equal, copy
		end

	EL_REFLECTION_HANDLER
		undefine
			is_equal, copy
		end

create
	make_size, make, make_from_object

convert
	make ({ARRAY [EL_HTTP_PARAMETER]})

feature {NONE} -- Initialization

	make_from_object (object: EL_REFLECTIVE)
		do
			make_size (object.field_table.count)
			append_object (object)
		end

feature -- Conversion

	to_table: EL_URL_QUERY_HASH_TABLE
		do
			create Result.make_equal (count)
			extend_table (Result)
		end

feature -- Element change

	append_object (object: EL_REFLECTIVE)
		local
			field_array: EL_REFLECTED_FIELD_LIST; l_item: EL_HTTP_NAME_VALUE_PARAMETER
			value: ZSTRING; i: INTEGER
		do
			field_array := object.meta_data.field_list
			grow (field_array.count)
			from i := 1 until i > field_array.count loop
				create value.make_from_general (field_array.i_th (i).to_string (object))
				create l_item.make (field_array.i_th (i).export_name, value)
				extend (l_item)
				i := i + 1
			end
		end

	append_tuple (tuple: TUPLE)
		local
			i: INTEGER
		do
			from i := 1 until i > tuple.count loop
				if attached {EL_HTTP_PARAMETER} tuple.reference_item (i) as p then
					extend (p)
				elseif attached {EL_CONVERTABLE_TO_HTTP_PARAMETER_LIST} tuple.reference_item (i) as c then
					extend (c.to_parameter_list)
				end
				i := i + 1
			end
		end

feature {NONE} -- Implementation

	extend_table (table: like to_table)
		do
			from start until after loop
				item.extend (table)
				forth
			end
		end

end
