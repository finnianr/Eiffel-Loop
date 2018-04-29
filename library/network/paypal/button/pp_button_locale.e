note
	description: "Button locale parameters as for example: `en_US, de_DE'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-28 14:35:45 GMT (Saturday 28th April 2018)"
	revision: "7"

class
	PP_BUTTON_LOCALE

inherit
	PP_CONVERTABLE_TO_PARAMETER_LIST

create
	make

convert
	make ({STRING})

feature {NONE} -- Initialization

	make (locale_code: STRING)
			-- examples: en_US, de_DE
		require
			valid_locale_code: locale_code.count = 5
					and then (locale_code.item (1).is_lower and locale_code [3] = '_' and locale_code.item (5).is_upper)
		do
			make_default
			across locale_code.split ('_') as code loop
				if code.cursor_index = 1 then
					button_language := code.item
				else
					button_country := code.item
				end
			end
		end

feature -- Paypal parameters

	button_language: STRING

	button_country: STRING

end
