note
	description: "[
		country and region fields parsed from JSON query `https://ipapi.co/<IP-address>/json'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-20 9:47:57 GMT (Monday 20th June 2022)"
	revision: "5"

class
	EL_IP_ADDRESS_GEOLOCATION

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

	EL_MODULE_EIFFEL

create
	make, make_from_json

feature -- Access

	location: ZSTRING
		-- country and region
		do
			Result := country_name + Separator + region
		end

feature -- API string fields

	country_name: ZSTRING
		-- country name

	region: ZSTRING
		-- region name (administrative division)

feature {NONE} -- Implementation

	new_representations: like Default_representations
		do
			create Result.make (<<
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
			Result := 4271480229
		end

	Separator: ZSTRING
		once
			Result := ", "
		end

end