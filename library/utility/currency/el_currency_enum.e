note
	description: "Currency code names"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 5:37:39 GMT (Monday 18th December 2017)"
	revision: "2"

class
	EL_CURRENCY_ENUM

inherit
	EL_ENUMERATION [NATURAL_8]
		redefine
			export_name, import_name
		end

create
	make

feature -- Access

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

	MYR: NATURAL_8

	MXN: NATURAL_8

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

	unit: ARRAY [NATURAL_8]
		-- currencies that do no have decimal fractions (according to Paypal at least)
		do
			Result := << HUF, JPY, TWD >>
		end

feature {NONE} -- Implementation

	export_name: like Naming.Default_export
		do
			Result := agent Naming.to_upper_snake_case
		end

	import_name: like Naming.Default_import
		do
			Result := agent Naming.from_upper_snake_case
		end

end
