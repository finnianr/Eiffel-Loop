note
	description: "Shared currency enum"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-05-19 19:24:50 GMT (Saturday 19th May 2018)"
	revision: "5"

class
	EL_SHARED_CURRENCY_ENUM

feature {NONE} -- Constants

	Currency: EL_CURRENCY_ENUM
		once
			create Result.make
		end

end
