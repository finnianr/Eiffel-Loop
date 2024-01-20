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
		Benchmark ${IF_ATTACHED_ITEM_VS_CONFORMING_INSTANCE_TABLE} shows this is about
		31% slower than equivalent branching attachment attempts.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:24 GMT (Saturday 20th January 2024)"
	revision: "3"

class
	EL_CONFORMING_INSTANCE_TABLE [G]

inherit
	EL_HASH_TABLE [G, INTEGER]
		rename
			make as make_from_array
		end

create
	make

feature {NONE} -- Initialization

	make (array: like type_mapping_array)
			--
		do
			make_size (array.count)
			type_mapping_array := array
		end

feature -- Status query

	has_related (object: ANY): BOOLEAN
		local
			type_id: INTEGER; type_conforms: BOOLEAN
		do
			type_id := {ISE_RUNTIME}.dynamic_type (object)
			if has_key (type_id) then
				Result := True
			else
				across type_mapping_array as array until type_conforms loop
					if attached array.item as map then
						if {ISE_RUNTIME}.type_conforms_to (type_id, map.parent_type.type_id) then
							put (map.instance, type_id) -- `found_item' now `True'
							type_conforms := True
						end
					end
				end
				Result := type_conforms
			end
		end

feature {NONE} -- Internal attributes

	type_mapping_array: ARRAY [TUPLE [parent_type: TYPE [ANY]; instance: G]]
end