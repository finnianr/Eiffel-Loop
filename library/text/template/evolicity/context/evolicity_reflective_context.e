note
	description: "Factory functions to reflectively create an Eiffel context table"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-10-28 13:27:12 GMT (Sunday 28th October 2018)"
	revision: "1"

deferred class
	EVOLICITY_REFLECTIVE_CONTEXT

inherit
	EL_REFLECTOR_CONSTANTS

feature -- Factory

	new_getter_table_for_each_type (types: ARRAY [TYPE [ANY]]): like new_getter_table_for_type
		local
			i: INTEGER_32
		do
			from i := 1 until i > types.count loop
				if i = 1 then
					Result := new_getter_table_for_type (types [i])
				else
					Result.merge (new_getter_table_for_type (types [i]))
				end
				i := i + 1
			end
		end

	new_getter_table_for_type (type: TYPE [ANY]): EVOLICITY_OBJECT_TABLE [FUNCTION [ANY]]
		local
			meta_data: like meta_data_by_type.item; table: EL_REFLECTED_FIELD_TABLE
			field_list: LIST [EL_REFLECTED_FIELD]; name: ZSTRING
		do
			meta_data := meta_data_by_type.item (current_reflective)
			table := meta_data.field_table
			table.query_by_type (type)
			field_list := table.last_query
			create Result.make_equal (field_list.count)
			from field_list.start until field_list.after loop
				name := field_list.item.name
				Result [name] := agent get_field_value (field_list.item)
				field_list.forth
			end
		end

feature {NONE} -- Implementation

	current_reflective: EL_REFLECTIVE
		deferred
		end

	get_field_value (field: EL_REFLECTED_FIELD): ANY
		do
			if attached {EL_REFLECTED_EXPANDED_FIELD [ANY]} field as expanded_field then
				Result := expanded_field.reference_value (current_reflective)
			elseif is_xml_escaped
				and then Escaper_table.has_key (field.type_id)
				and then attached {READABLE_STRING_GENERAL} field.value (current_reflective) as general
			then
				Result := Escaper_table.found_item.escaped (general, True)
			else
				Result := field.value (current_reflective)
			end
		end

	is_xml_escaped: BOOLEAN
		deferred
		end

	meta_data_by_type: EL_FUNCTION_RESULT_TABLE [EL_REFLECTIVE, EL_CLASS_META_DATA]
		deferred
		end

feature {NONE} -- Constants

	Escaper_table: EL_HASH_TABLE [EL_XML_GENERAL_ESCAPER, INTEGER]
		once
			create Result.make (<<
				[String_z_type, create {EL_XML_ZSTRING_ESCAPER}.make],
				[String_8_type, create {EL_XML_STRING_8_ESCAPER}.make],
				[String_32_type, create {EL_XML_STRING_32_ESCAPER}.make]
			>>)
		end
end
