note
	description: "Information parsed from JSON query `https://ipapi.co/<IP-address>/json'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-13 11:18:23 GMT (Wednesday 13th October 2021)"
	revision: "1"

class
	EL_IP_ADDRESS_INFO

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		end

	EL_SETTABLE_FROM_JSON_STRING
		redefine
			set_json_field
		end

create
	make_default, make_from_json

feature -- Access

	location: ZSTRING
		-- country and region
		do
			Result := country_name + Separator + region
		end

feature -- API numeric fields

	country_area: NATURAL
		-- area of the country (in sq km)

	country_population: NATURAL
		-- population of the country

	latitude: REAL
		-- latitude

	longitude: REAL
		-- longitude

feature -- API boolean fields

	in_eu: BOOLEAN
		-- whether IP address belongs to a country that is a member of the European Union (EU)

feature -- API string fields

	asn: STRING
		-- autonomous system number

	city: ZSTRING
		-- city name

	continent_code: STRING
		-- continent code

	country: STRING
		-- country code (2 letter, ISO 3166-1 alpha-2)

	country_calling_code: STRING
		-- country calling code (dial in code, comma separated)

	country_capital: ZSTRING
		-- capital of the country

	country_code: STRING
		-- country code (2 letter, ISO 3166-1 alpha-2)

	country_code_iso3: STRING
		-- country code (3 letter, ISO 3166-1 alpha-3)

	country_name: ZSTRING
		-- short country name

	country_tld: STRING
		-- country specific TLD (top-level domain)

	currency: STRING
		-- currency code (ISO 4217)

	currency_name: ZSTRING
		-- currency name

	ip: STRING
		-- public (external) IP address (same as URL ip)

	languages: STRING
		-- languages spoken (comma separated 2 or 3 letter ISO 639 code with optional hyphen separated country suffix)

	org: ZSTRING
		-- organinzation name

	postal: STRING
		-- postal code / zip code

	region: ZSTRING
		-- region name (administrative division)

	region_code: STRING
		-- region code

	timezone: ZSTRING
		-- timezone (IANA format i.e. “Area/Location”)

	utc_offset: STRING
		-- UTC offset as +HHMM or -HHMM (HH is hours, MM is minutes)

	version: STRING

feature {NONE} -- Implementation

	set_json_field (field: EL_REFLECTED_FIELD; json_value: ZSTRING)
		-- Convert
		do
			if Natural_fields.has (field.name) then
				Precursor (field, json_value.substring_to ('.', Default_pointer))
			else
				Precursor (field, json_value)
			end
		end

feature {NONE} -- Constants

	Natural_fields: ARRAY [STRING]
		once
			Result := << "country_area", "country_population" >>
			Result.compare_objects
		end

	Separator: ZSTRING
		once
			Result := ", "
		end

end