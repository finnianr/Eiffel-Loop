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
	date: "2019-10-04 8:29:42 GMT (Friday   4th   October   2019)"
	revision: "3"

class
	EL_SINGLETON [G]

inherit
	ANY

	EL_SHARED_SINGLETONS

	EL_MODULE_EXCEPTION

create
	make, default_create

feature {NONE} -- Initialization

	make (allow_descendant: BOOLEAN)
		do
			descendant_allowed := allow_descendant
		end

feature -- Status query

	descendant_allowed: BOOLEAN
		--  if `True' then a type conforming to `G' may be also be assigned

	is_singleton_created: BOOLEAN
		do
			Result := Singleton_table.has_type (base_type_id, descendant_allowed)
		end

feature -- Access

	singleton: G
		require
			singleton_created_already: is_singleton_created
		local
			insert: TUPLE
		do
			if attached {G} Singleton_table.item (base_type_id, descendant_allowed) as item then
				Result := item

			else
				if descendant_allowed then
					insert := ["conforming to " + ({G}).name]
				else
					insert := [({G}).name]
				end
				Exception.raise_developer ("Shared `Singleton_table' does not have type %S", insert)
			end
		end

feature {NONE} -- Implementation

	base_type_id: INTEGER
		do
			Result := ({G}).type_id
		end

end
