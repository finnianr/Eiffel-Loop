note
	description: "[
		Test for reflective classes [$source EL_REFLECTIVELY_SETTABLE] and [$source EL_SETTABLE_FROM_ZSTRING]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-23 12:13:44 GMT (Monday 23rd January 2023)"
	revision: "35"

class
	COUNTRY

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			foreign_naming as eiffel_naming,
			read_version as read_default_version
		export
			{ANY} field_table
		redefine
			make_default, new_representations, new_tuple_field_names
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_from_table as make
		end

	EL_ATTRIBUTE_NODE_HINTS

	EL_SHARED_CURRENCY_ENUM

	EL_MODULE_DATE_TIME

create
	make, make_default

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			province_list.compare_objects
			temperature_range.compare_objects
		end

feature -- Access

	brics_member: BOOLEAN_REF

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

	photo_jpeg: MANAGED_POINTER

	population: INTEGER

	province_list: ARRAYED_LIST [PROVINCE]

	temperature_range: TUPLE [winter, summer: INTEGER; unit_name: STRING]

	wikipedia_url: EL_URL

feature -- Measurement

	field_count: INTEGER
		do
			Result := field_table.count
		end

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

	new_tuple_field_names: like Default_tuple_field_names
		do
			create Result.make (<<
				["temperature_range", "winter, summer, unit_name"]
			>>)
		end

feature {NONE} -- Constants

	Attribute_node_fields: STRING = "code, continent, name"

	Field_hash: NATURAL_32 = 3967280807
end