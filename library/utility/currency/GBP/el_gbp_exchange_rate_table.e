note
	description: "British Pound exchange rate table derived from Euro exchange rate"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "3"

class
	EL_GBP_EXCHANGE_RATE_TABLE

inherit
	EL_EXCHANGE_RATE_TABLE

create
	make

feature {NONE} -- Constants

	Base_currency: NATURAL_8
		once
			Result := Currency.GBP
		end

end