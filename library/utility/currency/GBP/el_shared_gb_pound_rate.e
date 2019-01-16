note
	description: "Shared gbp exchange rate table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-16 0:49:43 GMT (Wednesday 16th January 2019)"
	revision: "4"

class
	EL_SHARED_GB_POUND_RATE

feature {NONE} -- Constants

	GB_pound_rate: EL_GBP_DAILY_EXCHANGE_RATES
		once
			create Result.make
		end
end
