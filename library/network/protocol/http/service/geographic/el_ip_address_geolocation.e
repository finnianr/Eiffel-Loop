note
	description: "[
		Geographic location information parsed from JSON query `https://ipapi.co/<IP-address>/json'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-10-18 10:56:20 GMT (Monday 18th October 2021)"
	revision: "2"

class
	EL_IP_ADDRESS_GEOLOCATION

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		end

	EL_SETTABLE_FROM_JSON_STRING

	EL_MODULE_EIFFEL

create
	make_default, make_from_json

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

feature {NONE} -- Constants

	Separator: ZSTRING
		once
			Result := ", "
		end

end