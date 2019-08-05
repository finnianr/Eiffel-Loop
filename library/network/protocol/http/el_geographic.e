note
	description: "Cached geopgraphic lookup of ip number"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-08-05 11:12:22 GMT (Monday 5th August 2019)"
	revision: "3"

class
	EL_GEOGRAPHIC

inherit
	ANY

	EL_MODULE_WEB

	EL_MODULE_IP_ADDRESS

	EL_MODULE_EXECUTION_ENVIRONMENT

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make
		do
			create cache_table.make_equal (2)
			across (<< Var_country_name, Var_region >>) as var_name loop
				cache_table.extend (create {like cache_table.item}.make (17), var_name.item)
			end
		end

feature -- Element change

	cache_location (ip_number: NATURAL; character: CHARACTER)
		local
			str: ZSTRING
		do
			if not is_country_cached (ip_number) then
				str := country (ip_number)
				if character.natural_32_code.to_boolean then
					lio.put_character (character)
				end
			end
			if not is_region_cached (ip_number) then
				str := region (ip_number)
				if character.natural_32_code.to_boolean then
					lio.put_character (character)
				end
			end
		end

feature -- Access

	country (ip_number: NATURAL): ZSTRING
		do
			Result := geographic_area (ip_number, Var_country_name)
		end

	location (ip_number: NATURAL): ZSTRING
		do
			Result := country (ip_number) + Separator + region (ip_number)
		end

	region (ip_number: NATURAL): ZSTRING
		do
			Result := geographic_area (ip_number, Var_region)
		end

feature -- Status query

	is_country_cached (ip_number: NATURAL): BOOLEAN
		do
			Result := is_geographic_area_cached (ip_number, Var_country_name)
		end

	is_region_cached (ip_number: NATURAL): BOOLEAN
		do
			Result := is_geographic_area_cached (ip_number, Var_region)
		end

feature {NONE} -- Implementation

	geographic_area (ip_number: NATURAL; var_name: STRING): ZSTRING
		local
			done: BOOLEAN; cache: like cache_table.item
		do
			if cache_table.has_key (var_name) then
				cache := cache_table.found_item
				if cache.has_key (ip_number) then
					Result := cache.found_item
				else
					create Result.make_empty
					Web.open (IP_api_template #$ [Ip_address.to_string (ip_number), var_name])
					from done := False until done loop
						Web.read_string_get
						if Web.last_string.has_substring (Ratelimited) then
							Execution_environment.sleep (500)
						else
							Result.append_utf_8 (Web.last_string)
							done := True
						end
					end
					Web.close
					cache.extend (Result, ip_number)
				end
			else
				create Result.make_empty
			end
		end

	is_geographic_area_cached (ip_number: NATURAL; var_name: STRING): BOOLEAN
		do
			if cache_table.has_key (var_name) then
				Result := cache_table.found_item.has (ip_number)
			end
		end

feature {NONE} -- Internal attributes

	cache_table: HASH_TABLE [HASH_TABLE [ZSTRING, NATURAL], STRING]

feature {NONE} -- Constants

	IP_api_template: ZSTRING
		-- example: https://ipapi.co/91.196.50.33/country_name/
		-- Possible error: {"reason": "RateLimited", "message": "", "wait": 1.0, "error": true}
		once
			Result := "https://ipapi.co/%S/%S/"
		end

	RateLimited: STRING = "RateLimited"

	Separator: ZSTRING
		once
			Result := ", "
		end

	Var_country_name: STRING = "country_name"

	Var_region: STRING = "region"

end
