note
	description: "Summary description for {EL_SHARED_CURRENCY_CODES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 5:37:39 GMT (Monday 18th December 2017)"
	revision: "2"

class
	EL_SHARED_CURRENCY_CODES

feature {NONE} -- Constants

	Currency: EL_CURRENCY_ENUM
		once
			create Result.make
		end

end
