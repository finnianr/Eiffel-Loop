note
	description: "[
		Test for reflective classes ${EL_REFLECTIVELY_SETTABLE} and ${EL_SETTABLE_FROM_ZSTRING}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-25 9:13:22 GMT (Tuesday 25th March 2025)"
	revision: "45"

class
	COUNTRY

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			foreign_naming as eiffel_naming,
			read_version as read_default_version
		export
			{ANY} field_table, query_by_type
		redefine
			make_default, new_representations, new_tuple_field_table
		end

	EL_SETTABLE_FROM_ZSTRING
		rename
			make_from_text_table as make
		end

	EL_ATTRIBUTE_NODE_HINTS

	EL_SHARED_CURRENCY_ENUM; EL_SHARED_TEST_TEXT

	EL_MODULE_DATE_TIME

create
	make, make_default, make_from_table

feature {NONE} -- Initialization

	make_default
		do
			Precursor
			province_list.compare_objects
			temperature_range.compare_objects
		end

feature -- Access

	currency_name: IMMUTABLE_STRING_8
		do
			Result := Currency_enum.name (currency)
		end

	string_8_field_names: like field_list.name_list
		do
			Result := field_list.name_list_for (Current, << code, continent >>)
		end

feature -- Attribute fields

	brics_member: BOOLEAN_REF

	code: STRING

	continent: STRING

	currency: NATURAL_8

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

feature -- Status query

	valid_photo_data: BOOLEAN
		local
			c_str: EL_C_STRING_8
		do
			create c_str.make_shared_of_size (photo_jpeg.item, photo_jpeg.count)
			Result := c_str.as_string_8 ~ "Photo of " + name.to_latin_1
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
			Result := Text.continents
		end

	Yes_no_states: EL_BOOLEAN_REPRESENTATION [STRING]
		once
			create Result.make ("no", "yes")
		end

feature {NONE} -- Reflection

	new_representations: like Default_representations
		do
			create Result.make_assignments (<<
				["continent",			Continent_set.to_representation],
				["currency",			Currency_enum.to_representation],
				["date_founded",		Date_time.Date_representation],
				["euro_zone_member",	Yes_no_states]
			>>)
		end

	new_tuple_field_table: like Default_tuple_field_table
		do
			Result := "[
				temperature_range:
					winter, summer, unit_name
			]"
		end

feature {NONE} -- Constants

	Attribute_node_fields: STRING = "code, continent, name"

	Field_hash: NATURAL_32 = 3967280807
end