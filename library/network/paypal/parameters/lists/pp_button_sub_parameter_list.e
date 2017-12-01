note
	description: "Summary description for {PP_BUTTON_VARIABLE_LIST}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-23 14:46:02 GMT (Thursday 23rd November 2017)"
	revision: "3"

class
	PP_BUTTON_SUB_PARAMETER_LIST

inherit
	PP_SUB_PARAMETER_LIST

create
	make

feature -- Element change

	currency_code: STRING
		do
			find_first (Var_currency_code, agent {EL_HTTP_NAME_VALUE_PARAMETER}.name)
			if exhausted then
				create Result.make_empty
			else
				Result := item.value.to_string_8
			end
		end

	set_currency_code (code: STRING)
		do
			extend (Var_currency_code, code)
		end

	set_item_name (name: ZSTRING)
		do
			extend (Var_item_name, name)
		end

	set_item_product_code (code: ZSTRING)
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
