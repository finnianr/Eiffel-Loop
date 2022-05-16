note
	description: "Conforming singleton"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-12 14:21:57 GMT (Thursday 12th May 2022)"
	revision: "4"

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