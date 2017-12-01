note
	description: "Summary description for {CURRENCY_ROUTINES}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-11-18 9:48:53 GMT (Saturday 18th November 2017)"
	revision: "1"

class
	EL_CURRENCY_ROUTINES

feature {NONE} -- Conversion

	amount_x100_from_string (str: ZSTRING): INTEGER
		require
			valid_decimal: str.has ('.') implies str.index_of ('.', 1) = str.count - 2
		local
			l_str: STRING
		do
			if str.has ('.') then
				l_str := str.to_latin_1
				l_str.prune ('.')
				Result := l_str.to_integer
			elseif str.is_integer then
				Result := str.to_integer * 100
			end
		end

end
