note
	description: "Initialized hash table factory"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-04 8:18:30 GMT (Wednesday 4th September 2024)"
	revision: "1"

class
	EL_INITIALIZED_HASH_TABLE_FACTORY

inherit
	EL_INITIALIZED_OBJECT_FACTORY [
		EL_HASH_TABLE_FACTORY [HASH_TABLE [ANY, HASHABLE]], HASH_TABLE [ANY, HASHABLE]
	]

feature -- Access

	new_equal_item (
		base_type: TYPE [ANY]; parameter_types: ARRAY [TYPE [ANY]]; n: INTEGER
	): detachable HASH_TABLE [ANY, HASHABLE]
		do
			if attached new_generic_type_factory (base_type, parameter_types) as l_factory then
				Result := l_factory.new_equal_item (n)
			end
		end

	new_item (
		base_type: TYPE [ANY]; parameter_types: ARRAY [TYPE [ANY]]; n: INTEGER
	): detachable HASH_TABLE [ANY, HASHABLE]
		do
			if attached new_generic_type_factory (base_type, parameter_types) as l_factory then
				Result := l_factory.new_item (n)
			end
		end

end