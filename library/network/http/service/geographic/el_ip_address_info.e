note
	description: "Information parsed from JSON query `https://ipapi.co/<IP-address>/json'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-18 17:20:15 GMT (Saturday 18th June 2022)"
	revision: "6"

class
	EL_IP_ADDRESS_INFO

inherit
	EL_IP_ADDRESS_GEOLOCATION
		redefine
			new_representations, set_json_field
		end

	EL_SHARED_CODE_REPRESENTATIONS

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

	asn_: EL_CODE_STRING
		-- autonomous system number
		do
			Result := asn
		end

	city: ZSTRING
		-- city name

	continent_code_: EL_CODE_STRING
		-- continent code
		do
			Result := continent_code
		end

	country_: EL_CODE_STRING
		-- country code (2 letter, ISO 3166-1 alpha-2)
		do
			Result := country
		end

	country_calling_code: STRING
		-- country calling code (dial in code, comma separated)

	country_capital: ZSTRING
		-- capital of the country

	country_code_: EL_CODE_STRING
		-- country code (2 letter, ISO 3166-1 alpha-2)
		do
			Result := country_code
		end

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

	currency_name: ZSTRING
		-- currency name

	ip_address: STRING
		-- public (external) IP address (same as URL ip)
		do
			Result := Ip_address_representation.to_string (ip)
		end

	languages: STRING
		-- languages spoken (comma separated 2 or 3 letter ISO 639 code with optional hyphen separated country suffix)

	org: ZSTRING
		-- organinzation name

	postal: STRING
		-- postal code / zip code

	region_code_: EL_CODE_STRING
		-- region code
		do
			Result := region_code
		end

	timezone: ZSTRING
		-- timezone (IANA format i.e. “Area/Location”)

	utc_offset_: EL_CODE_STRING
		-- UTC offset as +HHMM or -HHMM (HH is hours, MM is minutes)
		do
			Result := utc_offset
		end

	version_: EL_CODE_STRING
		do
			Result := version
		end

feature {NONE} -- Fixed length codes

	asn: NATURAL_64
		-- autonomous system number

	continent_code: NATURAL_16
		-- continent code

	country: NATURAL_16
		-- country code (2 letter, ISO 3166-1 alpha-2)

	country_code: NATURAL_16
		-- country code (2 letter, ISO 3166-1 alpha-2)

	country_code_iso3: NATURAL_32
		-- country code (3 letter, ISO 3166-1 alpha-3)

	country_tld: NATURAL_32
		-- country specific TLD (top-level domain)

	currency: NATURAL_32
		-- currency code (ISO 4217)

	ip: NATURAL_32
		-- public (external) IP address (same as URL ip)

	region_code: NATURAL_32
		-- region code

	utc_offset: NATURAL_64
		-- UTC offset as +HHMM or -HHMM (HH is hours, MM is minutes)

	version: NATURAL_32

feature {NONE} -- Implementation

	new_representations: like Default_representations
		do
			create Result.make (<<
				["asn", Code_64_representation],
				["continent_code", Code_16_representation],
				["country", Code_16_representation],
				["country_code", Code_16_representation],
				["country_code_iso3", Code_32_representation],
				["country_tld", Code_32_representation],
				["currency", Code_32_representation],
				["ip", Ip_address_representation],
				["region_code", Code_32_representation],
				["utc_offset", Code_64_representation],
				["version", Code_32_representation]
			>>)
		end

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

	Ip_address_representation: EL_IP_ADDRESS_REPRESENTATION
		do
			create Result.make
		end

	Natural_fields: EL_FIELD_INDICES_SET
		once
			Result := new_field_indices_set ("country_area, country_population")
		end

end