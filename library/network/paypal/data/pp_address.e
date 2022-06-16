note
	description: "Postal address"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-16 9:02:33 GMT (Thursday 16th June 2022)"
	revision: "10"

class
	PP_ADDRESS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming
		redefine
			new_representations
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

	new_representations: like Default_representations
		do
			create Result.make (<<
				["status", Status_enum.to_representation]
			>>)
		end

feature {NONE} -- Constants

	Status_enum: PP_ADDRESS_STATUS_ENUM
		once
			create Result.make
		end

end