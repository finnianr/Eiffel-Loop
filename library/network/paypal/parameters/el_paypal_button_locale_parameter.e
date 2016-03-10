note
	description: "Summary description for {EL_PAYPAL_LOCALE_PARAMETER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_PAYPAL_BUTTON_LOCALE_PARAMETER

inherit
	EL_HTTP_PARAMETER_LIST [EL_HTTP_NAME_VALUE_PARAMETER]
		rename
			make as make_list
		end

	EL_SHARED_PAYPAL_VARIABLES
		undefine
			copy, is_equal
		end

create
	make

feature {NONE} -- Initialization

	make (locale_code: STRING)
			-- examples: en_US, de_DE
		require
			valid_locale_code: locale_code.count = 5
					and then (locale_code.item (1).is_lower and locale_code [3] = '_' and locale_code.item (5).is_upper)
		local
			variable_name: ASTRING
		do
			make_list (2)
			across locale_code.split ('_') as code loop
				if code.cursor_index = 1 then
					variable_name := Variable.button_language
				else
					variable_name := Variable.button_country
				end
				extend (create {EL_HTTP_NAME_VALUE_PARAMETER}.make (variable_name, code.item))
			end
		end
end
