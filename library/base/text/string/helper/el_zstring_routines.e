note
	description: "Convenience routines for [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-12-26 11:52:16 GMT (Wednesday 26th December 2018)"
	revision: "9"

class
	EL_ZSTRING_ROUTINES

feature {EL_MODULE_ZSTRING} -- Conversion

	as_zstring, to (general: READABLE_STRING_GENERAL): ZSTRING
		do
			if attached {ZSTRING} general as str then
				Result := str
			else
				create Result.make_from_general (general)
			end
		end

	new_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (general)
		end

	joined (separator: CHARACTER_32; a_list: ITERABLE [ZSTRING]): ZSTRING
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_from_list (a_list)
			Result := list.joined (separator)
		end

feature {EL_MODULE_ZSTRING} -- Status query

	is_variable_name (str: ZSTRING): BOOLEAN
		local
			i: INTEGER
		do
			Result := str.count > 1
			from i := 1 until not Result or i > str.count loop
				inspect i
					when 1 then
						Result := str [i] = '$'
					when 2 then
						Result := str.is_alpha_item (i)
				else
					Result := str.is_alpha_numeric_item (i) or else str [i] = '_'
				end
				i := i + 1
			end
		end

end
