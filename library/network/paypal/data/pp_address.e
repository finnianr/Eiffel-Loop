note
	description: "Postal address"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-11-30 11:14:31 GMT (Monday 30th November 2020)"
	revision: "7"

class
	PP_ADDRESS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			export_name as export_default,
			import_name as import_default
		redefine
			new_enumerations
		end

create
	make_default

feature -- Access

	city: ZSTRING

	country: ZSTRING

	country_code: STRING

	name: ZSTRING

	state: ZSTRING

	status: NATURAL_8

	status_name: STRING
		do
			Result := Status_enum.name (status)
		end

	street: ZSTRING

	zip: ZSTRING

feature -- Element change

	set_country (a_country: like country)
		do
			country := a_country
		end

feature -- Status query

	is_confirmed: BOOLEAN
		do
			Result := status.to_boolean
		end

feature {NONE} -- Implementation

	new_enumerations: like Default_enumerations
		do
			create Result.make (<<
				["status", Status_enum]
			>>)
		end

feature {NONE} -- Constants

	Status_enum: PP_ADDRESS_STATUS_ENUM
		once
			create Result.make
		end

end