note
	description: "Geographic data for IP address parsed from JSON query `https://ipapi.co/<IP-address>/json'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-18 11:32:30 GMT (Saturday 18th June 2022)"
	revision: "1"

class
	EL_IP_ADDRESS_GEOGRAPHIC_INFO

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			make_default as make,
			read_version as read_default_version
		redefine
			new_representations
		end

	EL_SETTABLE_FROM_JSON_STRING
		rename
			make_default as make
		end

create
	make, make_from_json

feature -- Access

	ip: NATURAL

feature -- Codes

	asn: STRING
		-- autonomous system number

	country: STRING
		-- autonomous system number

feature -- Measurement

	country_area: REAL

	country_population: NATURAL

	latitude: REAL

	longitude: REAL

feature -- Status query

	in_eu: BOOLEAN
		-- whether IP address belongs to a country that is a member of the European Union (EU)

feature -- String

	city: ZSTRING
		-- city name

	country_name: ZSTRING
		-- country name

	region: ZSTRING
		-- region name (administrative division)

feature {NONE} -- Reflection

	new_representations: like Default_representations
		do
			create Result.make (<<
				["ip", create {EL_IP_ADDRESS_REPRESENTATION}.make]
			>>)
		end

feature {NONE} -- Constants

	Field_hash: NATURAL = 4147358407

end