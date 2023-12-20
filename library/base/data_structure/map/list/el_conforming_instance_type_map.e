note
	description: "[
		Map an array of base types to associated shared objects to function as an alternative
		to the following kind of **elseif* branching:
		
			if attached {TYPE_A} obj then
				Result := thing_for_type_a
				
			elseif attached {TYPE_B} obj then
				Result := thing_for_type_b
				
			elseif attached {TYPE_C} obj then
				Result := thing_for_type_c
			end
	]"
	notes: "[
		Benchmark [$source IF_ATTACHED_ITEM_VS_CONFORMING_INSTANCE_TABLE] shows this is about
		7% slower than equivalent branching attachment attempts
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-20 19:36:51 GMT (Wednesday 20th December 2023)"
	revision: "2"

class
	EL_CONFORMING_INSTANCE_TYPE_MAP [G]

inherit
	EL_ARRAYED_MAP_LIST [INTEGER, G]
		rename
			make as make_sized
		end

create
	make

feature {NONE} -- Initialization

	make (array: like type_mapping_array)
			--
		do
			make_sized (array.count)
			type_mapping_array := array
		end

feature -- Access

	type_related_item (object: ANY): detachable G
		local
			type_id, i: INTEGER; found_type: BOOLEAN
		do
			type_id := {ISE_RUNTIME}.dynamic_type (object)
			if attached area as l_area then
				from until i = l_area.count or found_type loop
					if l_area [i] = type_id then
						Result := internal_value_list.area [i]
						found_type := True
					end
					i := i + 1
				end
			end
			if not found_type then
				across type_mapping_array as array until attached Result loop
					if attached array.item as map then
						if {ISE_RUNTIME}.type_conforms_to (type_id, map.parent_type.type_id) then
							Result := map.instance
							extend (type_id, Result)
						end
					end
				end
			end
		end

feature {NONE} -- Internal attributes

	type_mapping_array: ARRAY [TUPLE [parent_type: TYPE [ANY]; instance: G]]
end