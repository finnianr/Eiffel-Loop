note
	description: "[
		Allow implementation of shared [https://en.wikipedia.org/wiki/Singleton_pattern singleton] for type G.
		See class [$source EL_SHARED_SINGLETONS] for details.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EL_SINGLETON [G]

inherit
	ANY

	EL_SHARED_SINGLETONS

	EL_MODULE_EXCEPTION

feature -- Status query

	is_singleton_created: BOOLEAN
		do
			Result := Singleton_table.has_key (({G}).type_id)
		end

feature -- Access

	singleton: G
		require
			singleton_created_already: is_singleton_created
		do
			if is_singleton_created and then attached {G} Singleton_table.found_item as item
			then
				Result := item
			else
				Exception.raise_developer ("Shared `Singleton_table' does not have type %S", [({G}).name])
			end
		end

end
