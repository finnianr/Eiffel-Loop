note
	description: "Postal address"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-23 12:13:27 GMT (Monday 23rd April 2018)"
	revision: "5"

class
	PP_ADDRESS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		end

	EL_SETTABLE_FROM_ZSTRING

create
	make_default

feature -- Access

	city: ZSTRING

	country: ZSTRING

	country_code: STRING

	name: ZSTRING

	state: ZSTRING

	status: PP_ADDRESS_STATUS

	street: ZSTRING

	zip: ZSTRING

feature -- Status query

	is_confirmed: BOOLEAN
		do
			Result := status
		end

end
