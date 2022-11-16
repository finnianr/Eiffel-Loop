note
	description: "Currency locale"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:07 GMT (Tuesday 15th November 2022)"
	revision: "13"

deferred class
	EL_CURRENCY_LOCALE

inherit
	ANY

	EL_SHARED_CURRENCY_ENUM
		export
			{ANY} Currency_enum
		end

	EL_SHARED_LOCALIZED_CURRENCY_TABLE

feature {NONE} -- Initialization

	make_default
		do
			set_currency (default_currency_code)
		end

feature -- Access

	currency: EL_CURRENCY
		do
			Result := Currency_table.item (language, currency_code)
		end

	default_currency_code: NATURAL_8
		deferred
		end

	language: STRING
		deferred
		end

	currency_code: NATURAL_8

feature -- Element change

	set_currency (code: NATURAL_8)
		require
			valid_code: Currency_enum.is_valid_value (code)
		do
			currency_code := code
		end

end