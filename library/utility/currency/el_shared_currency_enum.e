note
	description: "Summary description for {EL_SHARED_CURRENCY_CODES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-24 9:24:29 GMT (Tuesday 24th April 2018)"
	revision: "3"

class
	EL_SHARED_CURRENCY_ENUM

feature {NONE} -- Constants

	Currency: EL_CURRENCY_ENUM
		once
			create Result.make
		end

end
