note
	description: "[
		Details of Paypal button.
		Just to confuse matters, Paypal names these fields using lower_snake_case rather than UPPERCAMELCASE.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 16:14:16 GMT (Thursday 28th December 2017)"
	revision: "2"

class
	PP_BUTTON_DETAIL

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			make_default as make,
			field_included as is_any_field
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

	product_code: ZSTRING
		do
			Result := item_number
		end

end
