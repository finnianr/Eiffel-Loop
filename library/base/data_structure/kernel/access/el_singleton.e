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
	date: "2019-10-01 11:49:43 GMT (Tuesday   1st   October   2019)"
	revision: "2"

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
			Result := Singleton_table.has (base_type_id)
			if not Result and descendant_allowed then
				Result := conforming_type_id.to_boolean
			end
		end

feature -- Access

	singleton: G
		require
			singleton_created_already: is_singleton_created
		local
			insert: TUPLE
		do
			if Singleton_table.has_key (base_type_id) and then attached {G} Singleton_table.found_item as item
			then
				Result := item

			elseif descendant_allowed and then Singleton_table.has_key (conforming_type_id)
				and then attached {G} Singleton_table.found_item as item
			then
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

	conforming_type_id: INTEGER
		local
			base_id: INTEGER
		do
			base_id := base_type_id
			across Singleton_table.current_keys as type_id until Result.to_boolean loop
				if {ISE_RUNTIME}.type_conforms_to (type_id.item, base_id) then
					Result := type_id.item
				end
			end
		end

end
