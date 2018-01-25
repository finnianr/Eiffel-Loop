note
	description: "Postal address"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-28 16:14:39 GMT (Thursday 28th December 2017)"
	revision: "4"

class
	PP_ADDRESS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field
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
