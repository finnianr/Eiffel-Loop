note
	description: "Convenience routines for [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-01-02 13:49:09 GMT (Wednesday 2nd January 2019)"
	revision: "10"

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

	joined (separator: CHARACTER_32; a_list: FINITE [READABLE_STRING_GENERAL]): ZSTRING
		local
			count: INTEGER; list: LINEAR [READABLE_STRING_GENERAL]
		do
			list := a_list.linear_representation
			from list.start until list.after loop
				if count > 0 then
					count := count + 1
				end
				count := count + list.item.count
				list.forth
			end
			create Result.make (count)
			from list.start until list.after loop
				if list.index > 1 then
					Result.append_character (separator)
				end
				if attached {ZSTRING} list.item as zstr then
					Result.append (zstr)
				else
					Result.append_string_general (list.item)
				end
				list.forth
			end
		end

	new_zstring (general: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (general)
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
