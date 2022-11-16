note
	description: "Conforming singleton"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

class
	EL_CONFORMING_SINGLETON [G]

inherit
	EL_SINGLETON [G]
		redefine
			exception_insert, match_conforming
		end

convert
	item: {G}

feature {NONE} -- Implementation

	exception_insert: TUPLE
		do
			Result := ["conforming to " + base_type.name]
		end

feature {NONE} -- Constants

	Match_conforming: BOOLEAN = True
		--  if `True' then a type conforming to `G' may be also be assigned
end