note
	description: "Currency code with values defined by enumeration [$source EL_CURRENCY_ENUM]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-24 9:24:29 GMT (Tuesday 24th April 2018)"
	revision: "4"

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
