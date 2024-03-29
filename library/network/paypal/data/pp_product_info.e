note
	description: "[
		Product button information reflectively convertible to type ${PP_BUTTON_SUB_PARAMETER_LIST}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "10"

class
	PP_PRODUCT_INFO

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make,
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		undefine
			new_representations
		end

	EL_CURRENCY_PROPERTY

create
	make

feature -- Access

	item_name: ZSTRING

	item_number: STRING

feature -- Conversion

	to_parameter_list: PP_BUTTON_SUB_PARAMETER_LIST
		do
			create Result.make_from_object (Current)
		end

feature -- Element change

	set_item_name (a_item_name: ZSTRING)
		do
			item_name := a_item_name
		end

	set_item_number (a_item_number: ZSTRING)
		do
			item_number := a_item_number
		end

end