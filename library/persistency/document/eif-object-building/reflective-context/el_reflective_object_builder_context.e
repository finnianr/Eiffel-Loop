note
	description: "${EL_EIF_OBJ_BUILDER_CONTEXT} for ${EL_REFLECTIVE} object attribute"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-04-15 11:19:26 GMT (Tuesday 15th April 2025)"
	revision: "12"

class
	EL_REFLECTIVE_OBJECT_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT

	EL_STRING_GENERAL_ROUTINES_I

	EL_MODULE_EIFFEL; EL_MODULE_TUPLE

	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

	EL_SHARED_CLASS_ID

create
	make

feature {NONE} -- Initialization

	make (a_object: EL_REFLECTIVE)
		do
			object := a_object
			create context_table.make (3)
			set_default_attributes
			building_actions := new_building_actions
		end

feature -- Element change

	set_object (a_object: EL_REFLECTIVE)
		do
			object := a_object
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			-- Nodes relative to root element: bix
		local
			type: EL_ATTRIBUTE_TYPE_ROUTINES; item_type_id: INTEGER
			l_xpath: STRING; field: EL_REFLECTED_FIELD
		do
			create Result.make (object.field_table.count)
			across object.field_table as table loop
				field := table.item
				if type.attribute_id (object, field) > 0 then
					l_xpath := Shared_super_8.character_string ('@') + field.name
					if field.has_representation then
						Result [l_xpath] := agent set_from_representation (field)
					else
						Result [l_xpath] := agent set_from_node (field)
					end
				elseif attached {EL_REFLECTED_TUPLE} field as tuple_field
						and then attached tuple_field.field_name_list as name_list
				then
					across name_list as list loop
						l_xpath := field.name + Attribute_path + list.item
						item_type_id := tuple_field.member_types [list.cursor_index].type_id
						Result [l_xpath] := agent set_tuple_item_from_node (tuple_field, list.cursor_index, item_type_id)
					end
				elseif attached {EL_REFLECTED_REFERENCE [ANY]} field as ref_field
					and then attached new_build_action (ref_field, field.name) as action
				then
					Result [action.xpath] := action.procedure
				else
					Result [field.name + Text_path] := agent set_from_node (field)
				end
			end
		end

	extend_collection (field: EL_REFLECTED_COLLECTION [ANY])
		do
			field.extend_from_readable (object, node)
		end

	extend_reflective_collection (field: EL_REFLECTED_COLLECTION [EL_REFLECTIVE])
		local
			item_context: EL_REFLECTIVE_OBJECT_BUILDER_CONTEXT
		do
			field.extend_with_new (object)
			if attached {CHAIN [EL_REFLECTIVE]} field.collection (object) as list then
				if context_table.has_key (field.name) then
					context_table.found_item.set_object (list.last)
				else
					create item_context.make (list.last)
					context_table.put (item_context, field.name)
				end
			 	set_next_context (context_table.found_item)
			end
		end

	set_from_node (field: EL_REFLECTED_FIELD)
		require
			not_has_representation: not field.has_representation
		do
			field.set_from_readable (object, node)
		end

	set_from_representation (field: EL_REFLECTED_FIELD)
		do
			field.set_from_string (object, node.adjusted (False))
		end

	set_reflective_field (field: EL_REFLECTED_REFERENCE [ANY])
		local
			context: EL_REFLECTIVE_OBJECT_BUILDER_CONTEXT
		do
			if attached {EL_REFLECTIVE} field.value (object) as value then
				if context_table.has_key (field.name) then
					context_table.found_item.set_object (value)
				else
					create context.make (value)
					context_table.put (context, field.name)
				end
			 	set_next_context (context_table.found_item)
			end
		end

	set_string_from_node (field: EL_REFLECTED_STRING [READABLE_STRING_GENERAL])
		do
			field.set_from_node (object, node)
		end

	set_tuple_item_from_node (field: EL_REFLECTED_TUPLE; index: INTEGER; type_id: INTEGER)
		do
			if attached field.value (object) as l_tuple then
				Tuple.set_i_th (l_tuple, index, node, type_id)
			end
		end

feature {NONE} -- Implementation

	new_build_action (field: EL_REFLECTED_REFERENCE [ANY]; name: STRING): TUPLE [xpath: STRING; procedure: PROCEDURE]
		do
			create Result
			if attached {EL_REFLECTED_STRING [READABLE_STRING_GENERAL]} field as string_field then
				Result := [name + Text_path, agent set_string_from_node (string_field)]

			elseif attached {EL_REFLECTED_COLLECTION [ANY]} field as collection_field then
				if attached {EL_REFLECTED_COLLECTION [EL_REFLECTIVE]} collection_field as reflective then
					Result := [name + Item_path, agent extend_reflective_collection (reflective)]
				else
					Result := [name + Item_path + Text_path, agent extend_collection (collection_field)]
				end
			elseif attached {EL_REFLECTED_REFERENCE [ANY]} field as reflective
				and then reflective.conforms_to_type (Class_id.EL_REFLECTIVE)
			then
				Result := [name, agent set_reflective_field (reflective)]

			else
				Result := [name + Text_path, agent set_from_node (field)]
			end
		end

feature {NONE} -- Internal attributes

	context_table: EL_HASH_TABLE [EL_REFLECTIVE_OBJECT_BUILDER_CONTEXT, STRING]

	object: EL_REFLECTIVE

end