note
	description: "British Pound exchange rate table derived from Euro exchange rate"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-13 14:06:49 GMT (Wednesday 13th December 2017)"
	revision: "2"

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
