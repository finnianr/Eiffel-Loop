note
	description: "Currency code names"
	notes: "[
		**Problem to Solve**
		
		How to add ISK (Icelandic Krona) without changing exists values
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-08-31 14:22:59 GMT (Tuesday 31st August 2021)"
	revision: "9"

class
	EL_CURRENCY_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		rename
			export_name as to_snake_case_upper,
			import_name as from_snake_case_upper
		redefine
			initialize_fields
		end

create
	make

feature {NONE} -- Initialization

	initialize_fields
		do
			Precursor
			unit := << HUF, JPY, KRW, TWD >>
		end

feature -- Access

	format_for (locale: EL_DEFERRED_LOCALE_I; code: NATURAL_8): ZSTRING
		do
			Result := locale * Format_key #$ [name (code)]
		end

	name_for (locale: EL_DEFERRED_LOCALE_I; code: NATURAL_8): ZSTRING
		do
			Result := locale * Name_key #$ [name (code)]
		end

feature -- Status query

	translations_available (locale: EL_DEFERRED_LOCALE_I): BOOLEAN
		do
			Result := across list as code all
				locale.has_key (Format_key #$ [name (code.item)])
			end
			if Result then
				Result := across list as code all
					locale.has_key (Name_key #$ [name (code.item)])
				end
			end
		end

feature -- Codes

	AUD: NATURAL_8

	BGN: NATURAL_8

	BRL: NATURAL_8

	CAD: NATURAL_8

	CHF: NATURAL_8

	CNY: NATURAL_8

	CZK: NATURAL_8

	DKK: NATURAL_8

	EUR: NATURAL_8

	GBP: NATURAL_8

	HKD: NATURAL_8

	HRK: NATURAL_8

	HUF: NATURAL_8

	IDR: NATURAL_8

	ILS: NATURAL_8

	INR: NATURAL_8

	JPY: NATURAL_8

	KRW: NATURAL_8

	MXN: NATURAL_8

	MYR: NATURAL_8

	NOK: NATURAL_8

	NZD: NATURAL_8

	PHP: NATURAL_8

	PLN: NATURAL_8

	RON: NATURAL_8

	RUB: NATURAL_8

	SEK: NATURAL_8

	SGD: NATURAL_8

	THB: NATURAL_8

	TRY: NATURAL_8

	TWD: NATURAL_8

	USD: NATURAL_8

	ZAR: NATURAL_8

	unit: ARRAY [NATURAL_8] note option: transient attribute end
		-- currencies that do not have decimal fractions (according to Paypal at least)

feature {NONE} -- Constants

	Format_key: ZSTRING
		once
			Result := "{%S-format}"
		end

	Name_key: ZSTRING
		once
			Result := "{%S}"
		end

end