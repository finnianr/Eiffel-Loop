note
	description: "Test data for [$source STORABLE_COUNTRY]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-12-08 17:35:31 GMT (Thursday 8th December 2022)"
	revision: "1"

deferred class
	STORABLE_COUNTRY_TEST_DATA

inherit
	EL_ANY_SHARED

	EL_MODULE_BASE_64; EL_MODULE_LIO; EL_MODULE_TUPLE

feature {NONE} -- Implementation

	assert (a_tag: STRING; a_condition: BOOLEAN)
		deferred
		end

	check_values (country: COUNTRY)
		local
			name: ZSTRING; date_founded: DATE; euro_zone_member, brics_member: BOOLEAN
			photo_jpeg: MANAGED_POINTER; province_list: EL_ZSTRING_LIST
		do
			name := Value_table.item (Field.name)
			assert ("same name", country.name ~ name)
			assert ("same code", country.code  ~ Value_table.item (Field.code).to_string_8)
			lio.put_labeled_string ("country.currency_name", country.currency_name)
			lio.put_new_line
			assert ("same currency", country.currency_name  ~ Value_table.item (Field.currency).to_string_8)
			assert ("same literacy_rate", country.literacy_rate ~ Value_table.item (Field.literacy_rate).to_real)
			assert ("same population", country.population ~ Value_table.item (Field.population).to_integer)

			-- Test field cached in associated set
			assert ("same continent", country.continent ~ Value_table.item (Field.continent).to_string_8)
			assert ("in continent set", across country.Continent_set as list some list.item = country.continent end)

			create date_founded.make_from_string_default (Value_table.item (Field.date_founded))
			assert ("same date_founded", country.date_founded = date_founded.ordered_compact_date)
			euro_zone_member := Value_table.item (Field.euro_zone_member) ~ "YES"
			assert ("same euro_zone_member", country.euro_zone_member = euro_zone_member)

			brics_member := Value_table.item (Field.brics_member).to_boolean
			assert ("same brics_member", country.brics_member.item = brics_member)

			create photo_jpeg.make_from_array (Base_64.decoded_array (Value_table.item (Field.photo_jpeg)))
			assert ("same photo", country.photo_jpeg ~ photo_jpeg)

			province_list := Value_table.item (Field.province_list)
			assert ("same provinces", country.province_list ~ province_list)
		end

feature {NONE} -- Constants

	Field: TUPLE [
		brics_member, code, continent, currency, date_founded, euro_zone_member,
		literacy_rate, name, photo_jpeg, population, province_list: STRING
	]
		once
			create Result
			Tuple.fill (Result,
				"brics_member, code, continent, currency, date_founded, euro_zone_member,%
				%literacy_rate, name, photo_jpeg, population, province_list"
			)
		end

	Value_table: EL_ZSTRING_TABLE
		once
			create Result.make ("[
				brics_member:
					False
				code:
					IE
				continent:
					Europe
				currency:
					EUR
				date_founded:
					12/29/1937
				euro_zone_member:
					YES
				literacy_rate:
					0.9
				name:
					Ireland
				photo_jpeg:
					VyDHQ26RoAdUlNMQiWOKp22iUZEbS/VqWgX6rafZUGg=
				population:
					6500000
				province_list:
					Connaught, Leinster, Munster, Ulster
			]")
		end

end