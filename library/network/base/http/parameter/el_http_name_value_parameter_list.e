note
	description: "Parameter list that is createable from an object implementing [$source EL_REFLECTIVE]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-15 10:39:52 GMT (Sunday 15th April 2018)"
	revision: "4"

class
	EL_HTTP_NAME_VALUE_PARAMETER_LIST

inherit
	EL_HTTP_PARAMETER_LIST [EL_HTTP_NAME_VALUE_PARAMETER]

	EL_REFLECTION_HANDLER
		undefine
			is_equal, copy
		end

create
	make_size, make_from_object

feature {NONE} -- Initialization

	make_from_object (object: EL_REFLECTIVE)
		local
			field_array: EL_REFLECTED_FIELD_ARRAY; l_item: like item
			value: ZSTRING; i: INTEGER
		do
			field_array := object.meta_data.field_array
			make_size (field_array.count)
			from i := 1 until i > field_array.count loop
				create value.make_from_general (field_array.item (i).to_string (object))
				create l_item.make (field_array.item (i).export_name, value)
				extend (l_item)
				i := i + 1
			end
		end

end
