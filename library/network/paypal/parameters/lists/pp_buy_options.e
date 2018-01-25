note
	description: "Summary description for {PP_BUY_OPTIONS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-16 19:14:00 GMT (Saturday 16th December 2017)"
	revision: "4"

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

	EL_SHARED_CURRENCY_CODES
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
			make (0, Empty_string, Currency.EUR)
		end

feature -- Access

	currency_code: NATURAL_8

	id: INTEGER

feature -- Element change

	extend (option_name: ZSTRING; price_x100: INTEGER)
		do
			select_parameters.extend (option_name)
			price_parameters.extend (price_string (price_x100))
		end

feature {NONE} -- Implementation

	price_string (price_x100: INTEGER): ZSTRING
		local
			l_price_x100: INTEGER
		do
			create Result.make (5)
			if Currency.unit.has (currency_code) then
				l_price_x100 := (price_x100 / 100).rounded
			else
				l_price_x100 := price_x100
			end
			Result.append_integer (l_price_x100)
			if not Currency.unit.has (currency_code) then
				Result.insert_character ('.', Result.count - 1)
			end
		end


	parameter_name: ZSTRING
		do
			Result := "OPTION?NAME"
			Result [7] := id.out [1]
		end

	price_parameters: PP_OPTION_PRICE_PARAMETER_LIST

	select_parameters: PP_OPTION_SELECT_SUB_PARAMETER_LIST

end
