note
	description: "[
		${TP_DIGITS} optimized for ${ZSTRING} source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:26 GMT (Saturday 20th January 2024)"
	revision: "4"

class
	TP_ZSTRING_DIGITS

inherit
	TP_DIGITS
		undefine
			i_th_is_digit
		end

	TP_OPTIMIZED_FOR_ZSTRING
		rename
			i_th_is_numeric as i_th_is_digit
		end

create
	make

end