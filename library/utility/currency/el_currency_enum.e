note
	description: "Currency code names"
	notes: "[
		**Problem to Solve**
		
		How to add ISK (Icelandic Krona) without changing exists values
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-30 12:27:59 GMT (Wednesday 30th April 2025)"
	revision: "21"

class
	EL_CURRENCY_ENUM

inherit
	EL_ENUMERATION_NATURAL_8
		rename
			new_table_text as Empty_text,
			name_translater as Snake_case_upper
		redefine
			initialize
		end

create
	make

feature {NONE} -- Initialization

	initialize
		do
			unit := << HUF, JPY, KRW, TWD >>
		end

feature -- Status query

	has_decimal (code: NATURAL_8): BOOLEAN
		do
			Result := not unit.has (code)
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

feature {NONE} -- Internal attributes

	unit: ARRAY [NATURAL_8] note option: transient attribute end
		-- currencies that do not have decimal fractions (according to Paypal at least)

feature {NONE} -- Constants

	Snake_case_upper: EL_SNAKE_CASE_TRANSLATER
		once
			Result := {EL_CASE}.Upper
		end
end