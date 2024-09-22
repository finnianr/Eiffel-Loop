note
	description: "[
		Country parsed from JSON query `https://api.iplocation.net/?ip=<IP-address>'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-22 13:39:38 GMT (Sunday 22nd September 2024)"
	revision: "3"

class
	EL_IP_ADDRESS_COUNTRY

inherit
	EL_REFLECTIVELY_SETTABLE_STORABLE
		rename
			foreign_naming as eiffel_naming,
			make_default as make,
			read_version as read_default_version
		redefine
			new_representations
		end

	JSON_SETTABLE_FROM_STRING
		rename
			make_default as make
		end

	EL_MODULE_EIFFEL

create
	make, make_from_json

feature -- Access

	location: ZSTRING
		-- country and region
		do
			Result := country_name
		end

feature -- API string fields

	country_name: ZSTRING
		-- country name

feature -- Constants

	IP_api_template: ZSTRING
		-- example: https://api.iplocation.net/?ip=91.196.50.33
		once
			Result := "https://api.iplocation.net/?ip=%S"
		end

	Too_many_requests: STRING = "Too many requests"
		-- applies to ipapi.co, not api.iplocation.net

feature {NONE} -- Implementation

	new_representations: like Default_representations
		do
			create Result.make_assignments (<<
				["country_name", Country_representation]
			>>)
		end

feature {NONE} -- Constants

	Country_representation: EL_HASH_SET_REPRESENTATION [ZSTRING]
		once
			create Result.make_default
		end

	Field_hash: NATURAL
		once
			Result := 157540883
		end

end