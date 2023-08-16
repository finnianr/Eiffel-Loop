note
	description: "[
		List of NVP API sub-parameters as for example:
		
			L_BUTTONVAR0: currency_code=HUF
			L_BUTTONVAR1: item_name=Single PC subscription pack
			L_BUTTONVAR2: item_number=1.en.HUF
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-14 8:32:57 GMT (Monday 14th August 2023)"
	revision: "12"

deferred class
	PP_SUB_PARAMETER_LIST

inherit
	EL_HTTP_PARAMETER_LIST
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
			field_list: EL_FIELD_LIST
			value: ZSTRING; i: INTEGER
		do
			field_list := object.meta_data.field_list
			make_size (field_list.count)
			from i := 1 until i > field_list.count loop
				create value.make_from_general (field_list.i_th (i).to_string (object))
				extend (field_list.i_th (i).export_name, value)
				i := i + 1
			end
		end

feature -- Element change

	extend (name: READABLE_STRING_8; value: ZSTRING)
		local
			nvp: ZSTRING
		do
			create nvp.make (name.count + value.count + 1)
			nvp.append_string_general (name)
			nvp.append_character ('=')
			nvp.append_string (value)

			extend_list (create {EL_HTTP_NAME_VALUE_PARAMETER}.make (new_name, nvp))
		end

end