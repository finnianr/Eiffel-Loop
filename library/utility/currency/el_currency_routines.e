note
	description: "Summary description for {CURRENCY_ROUTINES}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

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
