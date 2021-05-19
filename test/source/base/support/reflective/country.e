note
	description: "Test for reflective classes [$source EL_REFLECTIVELY_SETTABLE] and [$source EL_SETTABLE_FROM_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-19 8:01:53 GMT (Wednesday 19th May 2021)"
	revision: "19"

class
	COUNTRY

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		redefine
			new_representations
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_from_table as make
		end

	EL_SHARED_CURRENCY_ENUM

	EL_SHARED_DATE_TIME

create
	make, make_default

feature -- Access

	code: STRING

	currency: NATURAL_8

	currency_name: STRING
		do
			Result := Currency_enum.name (currency)
		end

	date_founded: INTEGER

	euro_zone_member: BOOLEAN

	literacy_rate: REAL

	name: ZSTRING

	population: INTEGER

	temperature_range: TUPLE [winter, summer: INTEGER; unit_name: STRING]

feature -- Element change

	set_code (a_code: like code)
		do
			code := a_code
		end

	set_currency (a_currency: NATURAL_8)
		do
			currency := a_currency
		end

	set_literacy_rate (a_literacy_rate: REAL)
		do
			literacy_rate := a_literacy_rate
		end

	set_name (a_name: like name)
		do
			name := a_name
		end

	set_population (a_population: INTEGER)
		do
			population := a_population
		end

	set_temperature_range (a_temperature_range: like temperature_range)
		do
			temperature_range.copy (a_temperature_range)
			temperature_range.compare_objects
		end

feature {NONE} -- Reflection

	new_representations: like Default_representations
		do
			create Result.make (<<
				["currency", Currency_enum.to_representation],
				["date_founded", Date_time.Date_representation],
				["euro_zone_member", create {EL_BOOLEAN_REPRESENTATION}.make ("no", "yes")]
			>>)
		end

end