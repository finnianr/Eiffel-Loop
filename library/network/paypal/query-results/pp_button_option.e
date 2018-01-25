note
	description: "Summary description for {PP_BUTTON_OPTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-16 18:53:12 GMT (Saturday 16th December 2017)"
	revision: "1"

class
	PP_BUTTON_OPTION

inherit
	PP_REFLECTIVELY_SETTABLE

create
	make, make_default

feature {NONE} -- Initialization

	make (a_name: like name; a_price_x100: like price_x100; a_currency: like currency_code)
		do
			l_option_0_select := a_name; currency_code := a_currency
			l_option_0_price := (a_price_x100 / 100).truncated_to_real
		end

feature -- Access

	currency_code: NATURAL_8

	l_option_0_price: REAL

	l_option_0_select: ZSTRING

	name: ZSTRING
		do
			Result := l_option_0_select
		end

	price_x100: INTEGER
		do
			Result := (l_option_0_price * 100).rounded
		end

feature -- Element change

	set_currency (a_currency_code: like currency_code)
		do
			currency_code := a_currency_code
		end

end
