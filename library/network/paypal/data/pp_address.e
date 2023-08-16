note
	description: "Paypal postal address"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-08-02 14:42:22 GMT (Wednesday 2nd August 2023)"
	revision: "17"

class
	PP_ADDRESS

inherit
	EL_REFLECTIVELY_SETTABLE
		rename
			field_included as is_any_field,
			foreign_naming as eiffel_naming,
			has_default_strings as is_empty
		redefine
			new_representations, new_field_printer
		end

	EL_MAKEABLE
		rename
			make as make_default
		undefine
			is_equal
		end

	EL_SHARED_ESCAPE_TABLE

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

	street_escaped: like street
		-- escape line breaking control characters `%R', `%N' for display in one line
		do
			Result := street.escaped (Line_break_escaper)
		end

	zip: ZSTRING

feature -- Element change

	set_country (a_country: like country)
		do
			country := a_country
		end

feature -- Status query

	is_confirmed: BOOLEAN
		do
			Result := status = Status_enum.confirmed
		end

feature {NONE} -- Implementation

	new_field_printer: EL_REFLECTIVE_CONSOLE_PRINTER
		-- Fields that will not be output by `print_fields'
		-- Must be comma-separated names
		do
			create Result.make_default
			Result.put_escaper (Line_break_escaper, "street")
		end

	new_representations: like Default_representations
		do
			create Result.make (<<
				["status", Status_enum.to_representation]
			>>)
		end

feature {NONE} -- Constants

	Line_break_escaper: EL_STRING_ESCAPER [ZSTRING]
		once
			create Result.make (Escape_table.Eiffel)
		end

	Status_enum: PP_ADDRESS_STATUS_ENUM
		once
			create Result.make
		end

end