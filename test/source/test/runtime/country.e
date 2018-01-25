note
	description: "Test for similar type of class `EL_PAYPAL_TRANSACTION'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 16:25:03 GMT (Thursday 28th December 2017)"
	revision: "8"

class
	COUNTRY

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_from_zkey_table as make
		end

create
	make, make_default

feature -- Access

	code: STRING

	literacy_rate: REAL

	name: ZSTRING

	population: INTEGER

feature -- Element change

	set_code (a_code: like code)
		do
			code := a_code
		end

	set_literacy_rate (a_literacy_rate: like literacy_rate)
		do
			literacy_rate := a_literacy_rate
		end

	set_name (a_name: like name)
		do
			name := a_name
		end

	set_population (a_population: like population)
		do
			population := a_population
		end

end
