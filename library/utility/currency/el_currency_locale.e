note
	description: "Currency locale"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-11-05 14:27:12 GMT (Monday 5th November 2018)"
	revision: "6"

deferred class
	EL_CURRENCY_LOCALE

inherit
	EL_MODULE_DEFERRED_LOCALE

	EL_SHARED_CURRENCY_ENUM
		rename
			Currency as Currency_code
		end

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

	default_currency_code: NATURAL_8
		deferred
		end

feature -- Element change

	set_currency (code: NATURAL_8)
		local
			list: like currency_list
		do
			list := currency_list
			list.find_first_equal (code, agent {EL_CURRENCY}.code)
			if list.exhausted then
				set_currency (default_currency_code)
			else
				currency := list.item
			end
		end

feature {NONE} -- Constants

	Except_currency_codes: ARRAY [NATURAL_8]
		once
			create Result.make_empty
		end

	Locale_currency_list_table: HASH_TABLE [EL_SORTABLE_ARRAYED_LIST [EL_CURRENCY], STRING]
		local
			list: like Locale_currency_list_table.item
			code_list: like Currency_code.list
		once
			create Result.make_equal (Supported_languages.count)
			code_list := Currency_code.list
			across Supported_languages as lang loop
				create list.make (code_list.count)
				across code_list as code loop
					if not Except_currency_codes.has (code.item) then
						list.extend (create {EL_CURRENCY}.make (lang.item, code.item, not Currency_code.unit.has (code.item)))
					end
				end
				list.sort
				Result [lang.item] := list
			end
		end

	Supported_languages: ARRAY [STRING]
		once
			Result := << "en", "de" >>
		end

end
