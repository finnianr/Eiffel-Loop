note
	description: "[
		List of NVP API sub-parameters as for example:
		
			L_BUTTONVAR0: currency_code=HUF
			L_BUTTONVAR1: item_name=Single PC subscription pack
			L_BUTTONVAR2: item_number=1.en.HUF
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-13 13:26:12 GMT (Friday 13th April 2018)"
	revision: "6"

deferred class
	PP_SUB_PARAMETER_LIST

inherit
	EL_HTTP_NAME_VALUE_PARAMETER_LIST
		rename
			make as make_list,
			extend as extend_list
		redefine
			make_from_object
		end

	PP_VARIABLE_NAME_SEQUENCE
		undefine
			copy, is_equal
		end

feature {NONE} -- Initialization

	make
		do
			make_size (5)
		end

feature {NONE} -- Initialization

	make_from_object (object: EL_REFLECTIVE)
		local
			field_array: EL_REFLECTED_FIELD_ARRAY
			value: ZSTRING; i: INTEGER
		do
			field_array := object.meta_data.field_array
			make_size (field_array.count)
			from i := 1 until i > field_array.count loop
				create value.make_from_general (field_array.item (i).to_string (object))
				extend (field_array.item (i).export_name, value)
				i := i + 1
			end
		end

feature -- Element change

	extend (name, value: ZSTRING)
		local
			nvp: EL_NAME_VALUE_PAIR [ZSTRING]
		do
			create nvp.make_pair (name, value)
			extend_list (create {like item}.make (new_name, nvp.as_assignment))
		end

end
