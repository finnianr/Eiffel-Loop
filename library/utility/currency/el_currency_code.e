note
	description: "Currency code with values defined by enumeration [$source EL_CURRENCY_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-07-01 10:34:31 GMT (Monday 1st July 2019)"
	revision: "5"

class
	EL_CURRENCY_CODE

inherit
	EL_ENUMERATION_VALUE [NATURAL_8]
		rename
			enumeration as Currency
		end

	EL_SHARED_CURRENCY_ENUM

create
	make, make_default
end
