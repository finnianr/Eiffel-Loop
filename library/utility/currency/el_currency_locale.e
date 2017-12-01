note
	description: "Summary description for {CURRENCY_LOCALE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-18 10:12:31 GMT (Saturday 18th November 2017)"
	revision: "1"

deferred class
	EL_CURRENCY_LOCALE

inherit
	EL_MODULE_DEFERRED_LOCALE

	EL_CURRENCY_CONSTANTS

feature {NONE} -- Initialization

	make_default
		do
			set_currency (Default_currency_code)
		end

feature -- Access

	currency: EL_CURRENCY

	currency_list: like Locale_currency_list_table.item
		local
			currency_list_table: like Locale_currency_list_table
		do
			currency_list_table := Locale_currency_list_table
			currency_list_table.search (language)
			if currency_list_table.found then
				Result := currency_list_table.found_item
			else
				Result := currency_list_table [once "en"]
			end
		end

	language: STRING
		deferred
		end

	default_currency_code: STRING
		deferred
		end

feature -- Element change

	set_currency (currency_code: STRING)
		local
			list: like currency_list
		do
			list := currency_list
			list.find_first (currency_code, agent {EL_CURRENCY}.code)
			if list.exhausted then
				set_currency (default_currency_code)
			else
				currency := list.item
			end
		end

feature {NONE} -- Constants

	Locale_currency_list_table: HASH_TABLE [EL_SORTABLE_ARRAYED_LIST [EL_CURRENCY], STRING]
		local
			list: like Locale_currency_list_table.item
		once
			create Result.make_equal (Supported_languages.count)
			across Supported_languages as lang loop
				create list.make (currency_codes.count)
				across currency_codes as code loop
					list.extend (create {EL_CURRENCY}.make (lang.item, code.item, not Unit_currencies.has (code.item)))
				end
				list.sort
				Result [lang.item] := list
			end
		end

	Supported_languages: ARRAY [STRING]
		once
			Result := << "en", "de" >>
		end

	Unit_currencies: ARRAY [STRING]
		once
			Result := << "HUF", "JPY" >>
			Result.compare_objects
		end

end
