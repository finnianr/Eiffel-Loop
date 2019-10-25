note
	description: "[
		Allow implementation of shared [https://en.wikipedia.org/wiki/Singleton_pattern singleton] for type `G'.
		See class [$source EL_SHARED_SINGLETONS] for details.
		
		if `descendant_allowed' is enabled then `singleton' may also be a type conforming to `G'
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-10-04 17:40:53 GMT (Friday   4th   October   2019)"
	revision: "4"

class
	EL_SINGLETON [G]

inherit
	ANY

	EL_SHARED_SINGLETONS

	EL_MODULE_EXCEPTION

convert
	singleton: {G}

feature -- Status query

	is_singleton_created: BOOLEAN
		do
			Result := Singleton_table.has_type (base_type_id, match_conforming)
		end

feature -- Access

	singleton: G
		require
			singleton_created_already: is_singleton_created
		do
			if attached {G} Singleton_table.item (base_type_id, match_conforming) as item then
				Result := item
			else
				Exception.raise_developer ("Shared `Singleton_table' does not have type %S", exception_insert)
			end
		end

feature {NONE} -- Implementation

	base_type_id: INTEGER
		do
			Result := ({G}).type_id
		end

	match_conforming: BOOLEAN
		--  if `True' then a type conforming to `G' may be also be assigned
		do
		end

	exception_insert: TUPLE
		do
			Result := [({G}).name]
		end

end
