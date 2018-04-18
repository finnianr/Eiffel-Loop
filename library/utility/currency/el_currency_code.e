note
	description: "Reflectively settable currency code"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-13 16:48:12 GMT (Friday 13th April 2018)"
	revision: "3"

class
	EL_CURRENCY_CODE

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Currency
		end

	EL_SHARED_CURRENCY_CODES
		undefine
			is_equal
		end

create
	make, make_default
end
