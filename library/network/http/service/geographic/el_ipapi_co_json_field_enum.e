note
	description: "Field enumeration for JSON query `https://ipapi.co/<IP-address>/json'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-25 11:57:42 GMT (Saturday 25th June 2022)"
	revision: "3"

class
	EL_IPAPI_CO_JSON_FIELD_ENUM

inherit
	EL_ENUMERATION [NATURAL_16]
		rename
			foreign_naming as Snake_case_upper
		end

create
	make

feature -- API numeric fields

	country_area: NATURAL_16
		-- area of the country (in sq km)

	country_population: NATURAL_16
		-- population of the country

	latitude: NATURAL_16
		-- latitude

	longitude: NATURAL_16
		-- longitude

feature -- API boolean fields

	in_eu: NATURAL_16
		-- whether IP address belongs to a country that is a member of the European Union (EU)

feature -- API string fields

	asn: NATURAL_16
		-- autonomous system number

	city: NATURAL_16
		-- city name

	continent_code: NATURAL_16
		-- continent code

	country: NATURAL_16
		-- country code (2 letter, ISO 3166-1 alpha-2)

	country_calling_code: NATURAL_16
		-- country calling code (dial in code, comma separated)

	country_capital: NATURAL_16
		-- capital of the country

	country_code: NATURAL_16
		-- country code (2 letter, ISO 3166-1 alpha-2)

	country_code_iso3: NATURAL_16
		-- country code (3 letter, ISO 3166-1 alpha-3)

	country_name: NATURAL_16
		-- short country name

	country_tld: NATURAL_16
		-- country specific TLD (top-level domain)

	currency: NATURAL_16
		-- currency code (ISO 4217)

	currency_name: NATURAL_16
		-- currency name

	ip: NATURAL_16
		-- public (external) IP address (same as URL ip)

	languages: NATURAL_16
		-- languages spoken (comma separated 2 or 3 letter ISO 639 code with optional hyphen separated country suffix)

	org: NATURAL_16
		-- organinzation name

	postal: NATURAL_16
		-- postal code / zip code

	region: NATURAL_16
		-- region name (administrative division)

	region_code: NATURAL_16
		-- region code

	timezone: NATURAL_16
		-- timezone (IANA format i.e. “Area/Location”)

	utc_offset: NATURAL_16
		-- UTC offset as +HHMM or -HHMM (HH is hours, MM is minutes)

	version: NATURAL_16

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end
end