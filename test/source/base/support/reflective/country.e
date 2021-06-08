note
	description: "Test for reflective classes [$source EL_REFLECTIVELY_SETTABLE] and [$source EL_SETTABLE_FROM_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-06-08 11:25:31 GMT (Tuesday 8th June 2021)"
	revision: "23"

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

	continent: STRING

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

	photo_jpeg: MANAGED_POINTER

	temperature_range: TUPLE [winter, summer: INTEGER; unit_name: STRING]

feature -- Element change

	set_code (a_code: like code)
		do
			code := a_code
		end

	set_continent (a_continent: STRING)
		do
			Continent_set.put (a_continent)
			continent := Continent_set.found_item
		end

	set_currency (a_currency: NATURAL_8)
		do
			currency := a_currency
		end

	set_date_founded (a_date: DATE)
		do
			date_founded := a_date.ordered_compact_date
		end

	set_literacy_rate (a_literacy_rate: REAL)
		do
			literacy_rate := a_literacy_rate
		end

	set_name (a_name: like name)
		do
			name := a_name
		end

	set_photo_jpeg (jpeg: SPECIAL [NATURAL_8])
		do
			photo_jpeg.resize (jpeg.count)
			photo_jpeg.put_special_natural_8 (jpeg, 0, 0, jpeg.count)
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

feature -- Constant

	Continent_set: EL_HASH_SET [STRING]
		once
			Result := << "Europe", "Asia" , "Africa", "North America", "South America", "Antarctica" >>
		end

	Yes_no_states: EL_BOOLEAN_REPRESENTATION [STRING]
		once
			create Result.make ("no", "yes")
		end

feature {NONE} -- Reflection

	new_representations: like Default_representations
		do
			create Result.make (<<
				["continent", Continent_set.to_representation],
				["currency", Currency_enum.to_representation],
				["date_founded", Date_time.Date_representation],
				["euro_zone_member", Yes_no_states]
			>>)
		end

end