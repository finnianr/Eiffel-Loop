note
	description: "[
		Provide previously created singleton item conforming to **G** or else assign a default using
		make routine.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-05-13 8:29:23 GMT (Friday 13th May 2022)"
	revision: "1"

class
	EL_SINGLETON_OR_DEFAULT [G -> EL_SOLITARY, DEFAULT -> G create make end]

inherit
	EL_CONFORMING_SINGLETON [G]
		redefine
			is_created, item
		end

convert
	item: {G}

feature -- Status query

	Is_created: BOOLEAN = True

feature -- Access

	item: G
		do
			if attached {G} Singleton_table.item (base_type.type_id, match_conforming) as l_item then
				Result := l_item
			else
				create {DEFAULT} Result.make
			end
		end
end