note
	description: "Localized currency specifications in format: `<full-name> (<currency-format>)'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-08-31 9:12:31 GMT (Saturday 31st August 2024)"
	revision: "8"

class
	EL_CURRENCY_TEXTS

inherit
	EL_REFLECTIVE_LOCALE_TEXTS
		redefine
			translation_key
		end

	EL_SHARED_CURRENCY_ENUM

create
	make, make_with_locale

feature -- Access

	format (code: NATURAL_8): ZSTRING
		do
			Result := information (code).substring_between (Bracket.left, Bracket.right, 1)
		end

	information (code: NATURAL_8): ZSTRING
		-- name and format in brackets
		do
			if field_table.has_immutable_key (Currency_enum.name (code).as_lower)
				and then attached {EL_REFLECTED_ZSTRING} field_table.found_item as field
			then
				Result := field.value (Current)
			else
				Result := USD
			end
		end

	name (code: NATURAL_8): ZSTRING
		do
			Result := information (code).substring_to ('(')
			Result.right_adjust
		end

feature -- Specifications

	AUD: ZSTRING

	BGN: ZSTRING

	BRL: ZSTRING

	CAD: ZSTRING

	CHF: ZSTRING

	CNY: ZSTRING

	CZK: ZSTRING

	DKK: ZSTRING

	EUR: ZSTRING

	GBP: ZSTRING

	HKD: ZSTRING

	HRK: ZSTRING

	HUF: ZSTRING

	IDR: ZSTRING

	ILS: ZSTRING

	INR: ZSTRING

	JPY: ZSTRING

	KRW: ZSTRING

	MXN: ZSTRING

	MYR: ZSTRING

	NOK: ZSTRING

	NZD: ZSTRING

	PHP: ZSTRING

	PLN: ZSTRING

	RON: ZSTRING

	RUB: ZSTRING

	SEK: ZSTRING

	SGD: ZSTRING

	THB: ZSTRING

	TRY: ZSTRING

	TWD: ZSTRING

	USD: ZSTRING

	ZAR: ZSTRING

feature {NONE} -- Implementation

	translation_key (a_name: IMMUTABLE_STRING_8; text_case: NATURAL_8; text_differs: BOOLEAN): ZSTRING
		local
			l_name: STRING
		do
			l_name := Key_buffer.copied_general (a_name)
			l_name.to_upper
			Result := Key_template #$ [l_name]
		end

	english_table: STRING_32
		do
			Result := {STRING_32} "[
				aud:
					Australian Dollars ($ # ###.##)
				bgn:
					Bulgarian Lev (#.###,## Лв)
				brl:
					Brazilian Real (R$ #.###,##)
				cad:
					Canadian Dollars ($ #,###.##)
				chf:
					Swiss Francs (#'###.## CHF)
				cny:
					Yuan Renminbi (¥ #,###.##)
				czk:
					Czech Koruna (#.###,## Kč)
				dkk:
					Danish Krones (kr #.###,##)
				eur:
					Euros (€ #,###.##)
				gbp:
					British Pounds (£ #,###.##)
				hkd:
					Hong Kong Dollars (HK$ #,###.##)
				hrk:
					Croatian kuna (#.###,## Kn)
				huf:
					Hungarian Forints (#.### Ft)
				idr:
					Indonesian Rupiah (Rp #.###,##)
				ils:
					Israeli New Sheqels (#,###.## ₪)
				inr:
					Indian Rupee (₹ #,##,###.##)
				jpy:
					Japanese Yen (¥ #,###)
				krw:
					South Korea Won (₩ #,###)
				mxn:
					Mexican Pesos ($ #,###.##)
				myr:
					Malaysian Ringgit (RM #,###.##)
				nok:
					Norwegian Krones (kr #.###,##)
				nzd:
					New Zealand Dollars ($ #,###.##)
				php:
					Philippine Pesos (₱ #,###.##)
				pln:
					Polish Zlotys (# ###,## zł)
				ron:
					Romanian New Leu (leu #.###,##)
				rub:
					Russian Rubles (#.###,## руб)
				sek:
					Swedish Kronas (# ###,## kr)
				sgd:
					Singapore Dollar ($ #,###.##)
				thb:
					Thai Bahts (฿ #,###.##)
				try:
					New Turkish Lira (YTL #,###.##)
				twd:
					Taiwan New Dollar (NT$ #,###)
				usd:
					US Dollars ($ #,###.##)
				zar:
					South African Rand (R # ###.##)
			]"
		end

feature {NONE} -- Constants

	Bracket: TUPLE [left, right: ZSTRING]
		once
			create Result
			Tuple.fill (Result, "(, )")
		end

	Key_template: ZSTRING
		once
			Result := "{currency_%S}"
		end

end