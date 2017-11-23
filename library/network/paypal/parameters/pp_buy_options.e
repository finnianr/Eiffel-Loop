note
	description: "Summary description for {PP_BUY_OPTIONS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-10-12 18:21:00 GMT (Thursday 12th October 2017)"
	revision: "2"

class
	PP_BUY_OPTIONS

inherit
	EL_HTTP_PARAMETER_LIST [EL_HTTP_PARAMETER]
		rename
			make as make_list,
			extend as extend_list
		end

	EL_STRING_CONSTANTS
		undefine
			is_equal, copy
		end

create
	make, make_default

feature {NONE} -- Initialization

	make (a_id: like id; name: ZSTRING; a_currency_code: like currency_code)
		require
			valid_id: a_id >= 0 and a_id <= 9
		do
			id := a_id; currency_code := a_currency_code

			create select_parameters.make (id)
			create price_parameters.make (id)
			make_from_array (<<
				create {EL_HTTP_NAME_VALUE_PARAMETER}.make (parameter_name, name), select_parameters, price_parameters
			>>)
		end

	make_default
		do
			make (0, Empty_string, Empty_string_8)
		end

feature -- Access

	currency_code: STRING

	id: INTEGER

feature -- Element change

	extend (option_name: ZSTRING; price_x100: INTEGER)
		local
			price_string: ZSTRING
		do
			select_parameters.extend (option_name)

			price_string := price_x100.out
			if Unit_currencies.has (currency_code) then
				price_string.remove_tail (2)
			else
				price_string.insert_character ('.', price_string.count - 1)
			end
			price_parameters.extend (price_string)
		end

feature {NONE} -- Implementation

	parameter_name: ZSTRING
		do
			Result := "OPTION?NAME"
			Result [7] := id.out [1]
		end

	price_parameters: PP_OPTION_PRICE_PARAMETER_LIST

	select_parameters: PP_OPTION_SELECT_SUB_PARAMETER_LIST

feature {NONE} -- Constants

	Unit_currencies: ARRAY [STRING]
			-- Currencies that do not permit decimals
			-- See: https://developer.paypal.com/docs/classic/api/currency_codes/#id09A6G0U0GYK
		once
			Result := << "HUF", "JPY", "TWD" >>
			Result.compare_objects
		end

end
