note
	description: "[
		${TP_DIGITS} optimized for ${ZSTRING} source text
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:59 GMT (Monday 21st November 2022)"
	revision: "3"

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

