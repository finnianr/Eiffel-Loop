note
	description: "Convenience routines for [$source EL_ZSTRING]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-06-17 8:46:26 GMT (Sunday 17th June 2018)"
	revision: "7"

class
	EL_ZSTRING_ROUTINES

feature {EL_MODULE_ZSTRING} -- Conversion

	as_zstring, to (str: READABLE_STRING_GENERAL): ZSTRING
		do
			create Result.make_from_general (str)
		end

	joined (separator: CHARACTER_32; a_list: ITERABLE [ZSTRING]): ZSTRING
		local
			list: EL_ZSTRING_LIST
		do
			create list.make_from_list (a_list)
			Result := list.joined (separator)
		end

end
