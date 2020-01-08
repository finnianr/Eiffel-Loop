note
	description: "Test for reflective classes [$source EL_REFLECTIVELY_SETTABLE] and [$source EL_SETTABLE_FROM_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-08 11:45:34 GMT (Wednesday 8th January 2020)"
	revision: "14"

class
	COUNTRY

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
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

	temperature_range: TUPLE [winter, summer: INTEGER; unit_name: STRING]

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

	set_temperature_range (a_temperature_range: like temperature_range)
		do
			temperature_range.copy (a_temperature_range)
			temperature_range.compare_objects
		end

end
