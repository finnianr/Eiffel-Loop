note
	description: "[
		Object with `currency_code' enumeration field and support for reflective translation
		to code name, USD, EUR etc.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 12:26:35 GMT (Monday 23rd September 2024)"
	revision: "11"

deferred class
	EL_CURRENCY_PROPERTY

inherit
	EL_SHARED_CURRENCY_ENUM

feature -- Access

	currency_code: NATURAL_8

	currency_code_name: STRING
		do
			Result := Currency_enum.name (currency_code)
		end

feature -- Element change

	set_currency_code (a_currency_code: NATURAL_8)
		do
			currency_code := a_currency_code
		end

feature {NONE} -- Implementation

	new_representations: EL_HASH_TABLE [EL_FIELD_REPRESENTATION [ANY, ANY], STRING]
		do
			create Result.make_one ("currency_code", Currency_enum.to_representation)
		end
end