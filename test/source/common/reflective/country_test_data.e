note
	description: "Test data for ${COUNTRY}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-03 8:46:58 GMT (Monday 3rd March 2025)"
	revision: "14"

deferred class
	COUNTRY_TEST_DATA

inherit
	EL_ANY_SHARED

	EL_MODULE_BASE_64; EL_MODULE_TUPLE

feature {NONE} -- Implementation

	assert (a_tag: READABLE_STRING_GENERAL; a_condition: BOOLEAN)
		deferred
		end

	check_province_value (province: PROVINCE; table: EL_ZSTRING_TABLE)
		local
			field_name: IMMUTABLE_STRING_8; table_value, field_value: ZSTRING
		do
			assert ("same field count", province.field_table.count = table.count)
			across province.field_table as field loop
				field_name := field.item.name
				create field_value.make_from_general (field.item.to_string (province))
				assert ("has field " + field_name, table.has_key (field_name))
				table_value := table.found_item
				assert ("same value for " + field_name, table_value.same_string_general (field_value))
			end
		end

	check_values_ireland (country: COUNTRY)
		local
			field_name: IMMUTABLE_STRING_8; table_value, field_value: ZSTRING
		do
			assert ("same field count", country.field_count - 1 = Ireland_table.count)
			-- country.name.count > 0 implies
			assert ("valid photo data", country.valid_photo_data)
			across country.field_table as table loop
				field_name := table.item.name
				if field_name.same_string ("province_list") then
					assert ("4 provinces", country.province_list.count = 4)
					across country.province_list as list loop
						check_province_value (list.item, Province_table_list [list.cursor_index])
					end
				else
					assert ("has field " + field_name, Ireland_table.has_key (field_name))
					table_value := Ireland_table.found_item
					if field_name.same_string ("currency") then
						field_value := country.currency_name
					else
						create field_value.make_from_general (table.item.to_string (country))
					end
					if field_name.same_string ("euro_zone_member") then
						field_value.to_upper
					end
					assert ("same value for " + field_name, table_value.same_string_general (field_value))
				end
			end
		end

	new_country (id: NATURAL_8): COUNTRY
		do
			inspect id
				when Ireland then
					create Result.make (Ireland_data)
					across Province_table_list as list loop
						Result.province_list.extend (create {PROVINCE}.make (list.item))
					end
				when India then
					create Result.make (India_data)
			else
			end
		ensure
			valid_photo_data: Result.valid_photo_data
		end

	new_country_list: ARRAY [COUNTRY]
		do
			Result := << new_country (Ireland), new_country (India) >>
		end

	new_province_data: ARRAY [STRING]
		do
			Result := <<
				"[
					name:
						Connacht
					population:
						588583
					county_list:
						Galway, Leitrim, Mayo, Roscommon, Sligo
				]",
				"[
					name:
						Leinster
					population:
						258501
					county_list:
						Carlow, Dublin, Kildare, Kilkenny, Laois, Longford, Louth, Meath, Offaly, Westmeath, Wexford, Wicklow
				]",
				"[
					name:
						Munster
					population:
						1364098
					county_list:
						Clare, Cork, Kerry, Limerick, Tipperary, Waterford
				]",
				"[
					name:
						Ulster
					population:
						312354
					county_list:
						Cavan, Donegal, Monaghan
				]"
			>>
		end

feature {NONE} -- Constants

	India: NATURAL_8 = 2

	India_data: STRING = "[
		brics_member:
			True
		code:
			IN
		continent:
			Asia
		currency:
			INR
		date_founded:
			08/15/1947
		euro_zone_member:
			NO
		literacy_rate:
			0.73
		name:
			India
		photo_jpeg:
			UGhvdG8gb2YgSW5kaWE=
		population:
			1428627663
		temperature_range:
			[-40, 40, Celsius]
		wikipedia_url:
			https://en.wikipedia.org/wiki/India
	]"

	Ireland: NATURAL_8 = 1

	Ireland_data: STRING = "[
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
				UGhvdG8gb2YgSXJlbGFuZA==
			population:
				6500000
			temperature_range:
				[4, 16, Celsius]
			wikipedia_url:
				https://en.wikipedia.org/wiki/Ireland
		]"

	Ireland_table: EL_ZSTRING_TABLE
		once
			Result := Ireland_data
		end

	Province_table_list: ARRAYED_LIST [EL_ZSTRING_TABLE]
		once
			create Result.make (4)
			across new_province_data as str loop
				Result.extend (str.item)
			end
		end

end