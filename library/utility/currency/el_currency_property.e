note
	description: "[
		Object with `currency_code' enumeration field and support for reflective translation
		to code name, USD, EUR etc.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-29 7:23:49 GMT (Tuesday 29th April 2025)"
	revision: "12"

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

	new_representations: EL_IMMUTABLE_KEY_8_TABLE [EL_FIELD_REPRESENTATION [ANY, ANY]]
		do
			create Result.make_one ("currency_code", Currency_enum.to_representation)
		end
end