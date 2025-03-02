note
	description: "British Pound exchange rate table derived from Euro exchange rate"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-02 10:48:38 GMT (Sunday 2nd March 2025)"
	revision: "4"

class
	EL_GBP_EXCHANGE_RATE_TABLE

inherit
	EL_EXCHANGE_RATE_TABLE

create
	make

feature {NONE} -- Constants

	Base_currency: NATURAL_8
		once
			Result := Currency_enum.GBP
		end

end