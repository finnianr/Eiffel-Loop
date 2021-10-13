note
	description: "Field enumeration for [https://ipapi.co/api/#specific-location-field ipapi.co API]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-10 12:27:04 GMT (Sunday 10th October 2021)"
	revision: "1"

class
	EL_GEOGRAPHIC_FIELDS_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			export_name as export_default,
			import_name as import_default
		end

create
	make

feature -- Access

	asn: NATURAL_8
		-- autonomous system number

	city: NATURAL_8
		-- city name
		
	continent_code: NATURAL_8
		-- continent code

	country: NATURAL_8
		-- country code (2 letter, ISO 3166-1 alpha-2)

	country_area: NATURAL_8
		-- area of the country (in sq km)

	country_calling_code: NATURAL_8
		-- country calling code (dial in code, comma separated)

	country_capital: NATURAL_8
		-- capital of the country

	country_code: NATURAL_8
		-- country code (2 letter, ISO 3166-1 alpha-2)

	country_code_iso3: NATURAL_8
		-- country code (3 letter, ISO 3166-1 alpha-3)

	country_name: NATURAL_8
		-- short country name

	country_population: NATURAL_8
		-- population of the country

	country_tld: NATURAL_8
		-- country specific TLD (top-level domain)

	currency: NATURAL_8
		-- currency code (ISO 4217)

	currency_name: NATURAL_8
		-- currency name

	in_eu: NATURAL_8
		-- whether IP address belongs to a country that is a member of the European Union (EU)

	ip: NATURAL_8
		-- public (external) IP address (same as URL ip)

	languages: NATURAL_8
		-- languages spoken (comma separated 2 or 3 letter ISO 639 code with optional hyphen separated country suffix)

	latitude: NATURAL_8
		-- latitude

	latlong: NATURAL_8
		-- comma separated latitude and longitude

	longitude: NATURAL_8
		-- longitude

	org: NATURAL_8
		-- organinzation name

	postal: NATURAL_8
		-- postal code / zip code

	region: NATURAL_8
		-- region name (administrative division)

	region_code: NATURAL_8
		-- region code

	timezone: NATURAL_8
		-- timezone (IANA format i.e. “Area/Location”)

	utc_offset: NATURAL_8
		-- UTC offset as +HHMM or -HHMM (HH is hours, MM is minutes)
end