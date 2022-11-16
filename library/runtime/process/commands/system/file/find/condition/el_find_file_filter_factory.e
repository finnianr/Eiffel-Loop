note
	description: "Path filters applicable to classes conforming to [$source EL_FIND_COMMAND_I]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_FIND_FILE_FILTER_FACTORY

feature -- Access

	base_name_in (list: ITERABLE [READABLE_STRING_GENERAL]): EL_BASE_NAME_IN_LIST_FIND_CONDITION
		do
			create Result.make (list)
		end

	predicate (a_predicate: PREDICATE [ZSTRING]): EL_PREDICATE_FIND_CONDITION
		do
			create Result.make (a_predicate)
		end

end