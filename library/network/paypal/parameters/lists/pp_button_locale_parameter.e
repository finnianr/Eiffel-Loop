note
	description: "Button locale parameters as for example: `en_US, de_DE'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-13 13:30:29 GMT (Friday 13th April 2018)"
	revision: "6"

class
	PP_BUTTON_LOCALE_PARAMETER

inherit
	EL_HTTP_PARAMETER_LIST [PP_NAME_VALUE_PARAMETER]
		rename
			make as make_list
		end

	PP_SHARED_PARAMETER_ENUM
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
			var: NATURAL_8
		do
			make_size (2)
			across locale_code.split ('_') as code loop
				if code.cursor_index = 1 then
					var := Parameter.button_language
				else
					var := Parameter.button_country
				end
				extend (create {PP_NAME_VALUE_PARAMETER}.make (var, code.item))
			end
		end
end
