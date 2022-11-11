note
	description: "Geographic information parsed from JSON query `https://ipapi.co/<IP-address>/json'"
	notes: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-11 12:37:55 GMT (Friday 11th November 2022)"
	revision: "11"

class
	EL_IP_ADDRESS_GEOGRAPHIC_INFO

inherit
	EL_IP_ADDRESS_GEOLOCATION
		redefine
			Field_hash, new_representations
		end

	EL_SHARED_CODE_REPRESENTATIONS

create
	make, make_from_json

feature -- API 2 byte code-strings

	country_: EL_CODE_STRING
		-- country code (2 letter, ISO 3166-1 alpha-2)
		do
			Result := country
		end

	country_code_: EL_CODE_STRING
		-- country code (2 letter, ISO 3166-1 alpha-2)
		do
			Result := country_code
		end

	continent_code_: EL_CODE_STRING
		-- continent code
		do
			Result := continent_code
		end

feature -- 4 byte code-strings

	country_code_iso3_: EL_CODE_STRING
		-- country code (3 letter, ISO 3166-1 alpha-3)
		do
			Result := country_code_iso3
		end

	country_tld_: EL_CODE_STRING
		-- country specific TLD (top-level domain)
		do
			Result := country_tld
		end

	currency_: EL_CODE_STRING
		-- currency code (ISO 4217)
		do
			Result := currency
		end

	ip_address: STRING
		-- public (external) IP address (same as URL ip)
		do
			Result := Ip_address_representation.to_string (ip)
		end

	region_code_: EL_CODE_STRING
		-- region code
		do
			Result := region_code
		end

	version_: EL_CODE_STRING
		-- IPv4 or IPv6
		do
			Result := version
		end

feature -- 8 byte code-strings

	asn_: EL_CODE_STRING
		-- autonomous system number
		-- Characters sequence 'AS' followed by a number that can be up-to 32 bit long (i.e. AS4294967295)
		do
			Result := asn
		end

	postal_: EL_CODE_STRING
		-- postal code / zip code
		do
			Result := postal
		end

	utc_offset_: EL_CODE_STRING
		-- UTC offset as +HHMM or -HHMM (HH is hours, MM is minutes)
		do
			Result := utc_offset
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

	city: ZSTRING
		-- city name

	country_calling_code: STRING
		-- country calling code (dial in code, comma separated)

	country_capital: ZSTRING
		-- capital of the country

	currency_name: ZSTRING
		-- currency name

	languages: STRING
		-- languages spoken (comma separated 2 or 3 letter ISO 639 code with optional hyphen separated country suffix)

	org: ZSTRING
		-- organinzation name

	timezone: ZSTRING
		-- timezone (IANA format i.e. “Area/Location”)

feature -- API 2 byte compressed codes

	country: NATURAL_16
		-- country code (2 letter, ISO 3166-1 alpha-2)

	country_code: NATURAL_16
		-- country code (2 letter, ISO 3166-1 alpha-2)

	continent_code: NATURAL_16
		-- 2 character continent code

feature -- API 4 byte compressed codes

	country_code_iso3: NATURAL_32
		-- country code (3 letter, ISO 3166-1 alpha-3)

	country_tld: NATURAL_32
		-- country specific TLD (top-level domain)

	currency: NATURAL_32
		-- currency code (ISO 4217)

	ip: NATURAL_32
		-- public (external) IP address (same as URL ip)

	region_code: NATURAL_32
		-- region code can be up-to 3 characters

	version: NATURAL_32
		-- IPv4 or IPv6

feature -- API 8 byte compressed codes

	asn: NATURAL_64
		-- autonomous system number
		-- Characters sequence 'AS' followed by a number that can be up-to 32 bit long (i.e. AS4294967295)

	postal: NATURAL_64
		-- postal code / zip code

	utc_offset: NATURAL_64
		-- UTC offset as +HHMM or -HHMM (HH is hours, MM is minutes)

feature {NONE} -- Implementation

	new_representations: like Default_representations
		do
			Result := Precursor +
				["ip", Ip_address_representation] +

				["asn", Code_64_representation] +
				["utc_offset", Code_64_representation] +
				["postal", Code_64_representation] +

				["continent_code", Code_16_representation] +
				["country", Code_16_representation] +
				["country_code", Code_16_representation] +

				["country_code_iso3", Code_32_representation] +
				["country_tld", Code_32_representation] +
				["currency", Code_32_representation] +
				["region_code", Code_32_representation] +
				["version", Code_32_representation]
		end

feature {NONE} -- Constants

	Field_hash: NATURAL = 120250182

	Ip_address_representation: EL_IP_ADDRESS_REPRESENTATION
		do
			create Result.make
		end

note
	notes: "[
		Hi Finnian,
		Here are the details for the respective fields :

			version : IPv4 or IPv6
			region_code : Length can be up-to 3 characters
			continent_code : Length is 2 characters
			postal : Length is up-to 8 characters currently (but this can be higher in future)
			timezone : IANA format (currently the longest entry is 30 characters, but it can change in future)
			UTC offset : in ±HHMM format
			asn : Characters sequence 'AS' followed by a number that can be up-to 32 bit long (i.e. AS4294967295)

		Kind Regards
		Team ipapi
	]"

end