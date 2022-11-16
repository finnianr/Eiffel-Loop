note
	description: "File list filter condition is met if agent predicate returns `True'"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:06 GMT (Tuesday 15th November 2022)"
	revision: "2"

class
	EL_PREDICATE_FIND_CONDITION

inherit
	EL_FIND_FILE_CONDITION

create
	make

convert
	make ({PREDICATE [ZSTRING]})

feature {NONE} -- Initialization

	make (predicate: like is_predicate_true)
		require
			valid_predicate: predicate.open_count = 1
		do
			is_predicate_true := predicate
		end

feature {NONE} -- Status query

	met (path: ZSTRING): BOOLEAN
		do
			Result := is_predicate_true (path)
		end

feature {NONE} -- Internal attributes

	is_predicate_true: PREDICATE [ZSTRING]

end