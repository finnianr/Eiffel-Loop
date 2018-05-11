note
	description: "[
		Details of Paypal button. Just to confuse matters, Paypal names these fields using `lower_snake_case' rather
		than `UPPERCAMELCASE'.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-28 12:45:27 GMT (Saturday 28th April 2018)"
	revision: "6"

class
	PP_BUTTON_DETAIL

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make,
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_default as make
		end

create
	make

feature -- Access

	bn: STRING

	business: STRING

	currency_code: EL_CURRENCY_CODE

	item_name: ZSTRING

	item_number: STRING

	no_note: NATURAL_8

	product_info: PP_PRODUCT_INFO
		do
			create Result.make
			Result.set_currency_code (currency_code)
			Result.set_item_name (item_name)
			Result.set_item_number (item_number)
		end

end
