note
	description: "[
		Allow implementation of shared [https://en.wikipedia.org/wiki/Singleton_pattern singleton] for type `G'.
		See class [$source EL_SHARED_SINGLETONS] for details.
		
		if `descendant_allowed' is enabled then `item' may also be a type conforming to `G'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-03-08 11:01:21 GMT (Monday 8th March 2021)"
	revision: "7"

class
	EL_SINGLETON [G]

inherit
	ANY

	EL_SHARED_SINGLETONS

	EL_MODULE_EXCEPTION

convert
	item: {G}

feature -- Status query

	is_created: BOOLEAN
		-- True if `item' has been created
		do
			Result := Singleton_table.has_type (base_type, match_conforming)
		end

feature -- Access

	item: G
		require
			item_created: is_created
		do
			if attached {G} Singleton_table.item (base_type.type_id, match_conforming) as l_item then
				Result := l_item
			else
				Exception.raise_developer ("Shared `Singleton_table' does not have type %S", exception_insert)
			end
		end

feature {NONE} -- Implementation

	match_conforming: BOOLEAN
		--  if `True' then a type conforming to `G' may be also be assigned
		do
		end

	exception_insert: TUPLE
		do
			Result := [base_type.name]
		end

	base_type: TYPE [G]
		do
			Result := {G}
		end

end