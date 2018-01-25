note
	description: "Summary description for {PP_BUTTON_VARIABLE_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-18 5:51:51 GMT (Monday 18th December 2017)"
	revision: "5"

class
	PP_BUTTON_SUB_PARAMETER_LIST

inherit
	PP_SUB_PARAMETER_LIST

	EL_SHARED_CURRENCY_CODES
		undefine
			is_equal, copy
		end

create
	make

feature -- Element change

	currency_code: NATURAL_8
		do
			find_first (Var_currency_code, agent {EL_HTTP_NAME_VALUE_PARAMETER}.name)
			if found then
				Result := Currency.value (item.value)
			end
		end

	set_currency_code (code: NATURAL_8)
		do
			extend (Var_currency_code, Currency.name (code))
		end

	set_item_name (name: ZSTRING)
		do
			extend (Var_item_name, name)
		end

	set_item_number (code: ZSTRING)
		do
			extend (Var_item_number, code)
		end

feature {NONE} -- Constants

	Name_prefix: ZSTRING
		once
			Result := "L_BUTTONVAR"
		end

	Var_currency_code: ZSTRING
		once
			Result := "currency_code"
		end

	Var_item_name: ZSTRING
		once
			Result := "item_name"
		end

	Var_item_number: ZSTRING
		once
			Result := "item_number"
		end
end
