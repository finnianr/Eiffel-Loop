note
	description: "[
		Allow implementation of shared [https://en.wikipedia.org/wiki/Singleton_pattern singleton] for type `G'.
		See class ${EL_SHARED_SINGLETONS} for details.
		
		if `descendant_allowed' is enabled then `item' may also be a type conforming to `G'
	]"
	descendants: "[
			EL_SINGLETON [G]
				${EL_CONFORMING_SINGLETON [G]}
					${EL_SINGLETON_OR_DEFAULT [G -> EL_SOLITARY, DEFAULT -> G create make end]}
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2008-04-21 19:24:48 GMT (Monday 21st April 2008)"
	revision: "12"

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
			if match_conforming then
				Result := Singleton_table.has_conforming_type (base_type)
			else
				Result := Singleton_table.has_type (base_type)
			end
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