note
	description: "Information parsed from JSON query `https://ipapi.co/<IP-address>/json'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-17 13:31:16 GMT (Sunday 17th October 2021)"
	revision: "5"

class
	EL_IP_ADDRESS_INFO

inherit
	EL_IP_ADDRESS_GEOLOCATION
		redefine
			set_json_field
		end

create
	make_default, make_from_json

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

	asn: EL_CODE_STRING
		-- autonomous system number

	city: ZSTRING
		-- city name

	continent_code: EL_CODE_STRING
		-- continent code

	country: EL_CODE_STRING
		-- country code (2 letter, ISO 3166-1 alpha-2)

	country_calling_code: STRING
		-- country calling code (dial in code, comma separated)

	country_capital: ZSTRING
		-- capital of the country

	country_code: EL_CODE_STRING
		-- country code (2 letter, ISO 3166-1 alpha-2)

	country_code_iso3: EL_CODE_STRING
		-- country code (3 letter, ISO 3166-1 alpha-3)

	country_tld: EL_CODE_STRING
		-- country specific TLD (top-level domain)

	currency: EL_CODE_STRING
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

	region_code: EL_CODE_STRING
		-- region code

	timezone: ZSTRING
		-- timezone (IANA format i.e. “Area/Location”)

	utc_offset: EL_CODE_STRING
		-- UTC offset as +HHMM or -HHMM (HH is hours, MM is minutes)

	version: EL_CODE_STRING

feature {NONE} -- Implementation

	set_json_field (field: EL_REFLECTED_FIELD; json_value: ZSTRING)
		-- Trim decimal point for `country_area' and `country_population'
		do
			if Natural_fields.has (field.index) then
				Precursor (field, json_value.substring_to ('.', Default_pointer))
			else
				Precursor (field, json_value)
			end
		end

feature {NONE} -- Constants

	Natural_fields: EL_FIELD_INDICES_SET
		once
			Result := new_field_indices_set ("country_area, country_population")
		end

end