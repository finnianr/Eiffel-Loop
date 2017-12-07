note
	description: "Test for similar type of class `EL_PAYPAL_TRANSACTION'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-06 13:57:14 GMT (Wednesday 6th December 2017)"
	revision: "5"

class
	COUNTRY

inherit
	EL_REFLECTIVELY_SETTABLE [ZSTRING]
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
