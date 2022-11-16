note
	description: "Paypal button option"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "7"

class
	PP_BUTTON_OPTION

inherit
	PP_SETTABLE_FROM_UPPER_CAMEL_CASE
		undefine
			new_representations
		end

	EL_CURRENCY_PROPERTY

create
	make, make_default

feature {NONE} -- Initialization

	make (a_name: like name; a_price_x100: like price_x100; a_currency: like currency_code)
		do
			l_option_0_select := a_name; currency_code := a_currency
			l_option_0_price := (a_price_x100 / 100).truncated_to_real
		end

feature -- Paypal

	l_option_0_price: REAL

	l_option_0_select: ZSTRING

feature -- Access

	name: ZSTRING
		do
			Result := l_option_0_select
		end

	price_x100: INTEGER
		do
			Result := (l_option_0_price * 100).rounded
		end

end