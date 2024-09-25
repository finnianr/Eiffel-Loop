note
	description: "Reflective Eiffel object builder (from XML) context"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-25 11:10:19 GMT (Wednesday 25th September 2024)"
	revision: "33"

deferred class
	EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT

inherit
	EL_EIF_OBJ_BUILDER_CONTEXT
		export
			{NONE} all
		undefine
			is_equal
		redefine
			make_default
		end

	EL_REFLECTIVELY_SETTABLE
		rename
			foreign_naming as xml_naming
		export
			{NONE} all
			{EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT} current_reflective
		redefine
			make_default, new_meta_data
		end

	EL_MODULE_CONVERT_STRING; EL_MODULE_TUPLE

	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

	EL_ELEMENT_NODE_HINTS

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REFLECTIVELY_SETTABLE}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature {EL_REFLECTION_HANDLER} -- Access

	importable_list: EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
		do
			Result := Importable_fields_table_by_type.item (Current)
		end

feature {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT} -- Factory

	new_build_action (field: EL_REFLECTED_REFERENCE [ANY]; node_type: INTEGER): TUPLE [xpath: STRING; procedure: PROCEDURE]
		require
			valid_current_type: field.valid_type (current_reflective)
		local
			reflective_context: EL_REFLECTIVE_OBJECT_BUILDER_CONTEXT
		do
			create Result
			if attached {EL_REFLECTED_COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]} field as builder_context_list then
				Result.xpath := new_xpath (field, Element_node) + Item.xpath
				Result.procedure := agent extend_context_collection (builder_context_list)

			elseif attached {EL_REFLECTED_COLLECTION [ANY]} field as collection_field then
				Result := [new_xpath (field, Element_node) + Item.text_xpath, agent extend_collection (collection_field)]

			elseif attached {EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT]} field as context_field then
				Result := [new_xpath (field, Element_node), agent set_builder_field_context (context_field)]

			elseif attached {EL_REFLECTED_PATH} field as path_field then
				Result := [new_xpath (field, node_type), agent set_path_field_from_node (path_field)]

			elseif attached {EL_REFLECTED_STRING [READABLE_STRING_GENERAL]} field as string_field
				and then (string_field.is_value_cached or string_field.is_conforming)
			then
			-- The default `set_field_from_readable' is faster for other reflected strings
				Result := [new_xpath (string_field, node_type), agent set_field_from_node (string_field)]

			elseif field.conforms_to_type (Class_id.EL_REFLECTIVE)
				and then attached {EL_REFLECTIVE} field.value (current_reflective) as reflective_value
			then
				create reflective_context.make (reflective_value)
				Result := [new_xpath (field, Element_node), agent set_reflective_field_context (field, reflective_context)]
			else
				Result := [new_xpath (field, node_type), agent set_field_from_readable (field)]
			end
		end

	new_importable_list: EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
		do
			Result := meta_data.field_list.query_if (agent is_importable)
			Result.order_by (agent {EL_REFLECTED_FIELD}.name, True)
		end

	new_meta_data: EL_EIF_OBJ_BUILDER_CONTEXT_CLASS_META_DATA
		do
			create Result.make (Current)
		end

	new_xpath (field: EL_REFLECTED_FIELD; node_type: INTEGER): STRING
		local
			s: EL_STRING_8_ROUTINES
		do
			inspect node_type
				when Attribute_node then
					create Result.make (field.export_name.count  + 1)
					Result.append_character ('@')
					Result.append_string (field.export_name)

				when Text_element_node then
					Result := s.joined (field.export_name, Text_path)
			else
				Result := field.export_name
			end
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			Result := building_actions_for_type ({ANY}, element_node_field_set)
		end

	building_actions_for_each_type (types: ARRAY [TYPE [ANY]]; element_set: EL_FIELD_INDICES_SET): EL_PROCEDURE_TABLE [STRING]
		local
			i: INTEGER_32; table: EL_PROCEDURE_TABLE [STRING]
		do
			from i := 1 until i > types.count loop
				table := building_actions_for_type (types [i], element_set)
				if i = 1 then
					Result := table
				else
					Result.merge (table)
				end
				i := i + 1
			end
		end

	building_actions_for_type (type: TYPE [ANY]; element_set: EL_FIELD_INDICES_SET): EL_PROCEDURE_TABLE [STRING]
		-- table of build actions for fields matching `type' indexed by a relative xpath
		-- by default xpaths select an element attribute except for field in `element_set' which
		-- select the text within an element.
		local
			field_list: like importable_list; node_type, item_type_id: INTEGER; field: EL_REFLECTED_FIELD
			l_xpath: STRING; s: EL_STRING_8_ROUTINES
		do
			field_list := importable_list
			if type /= {ANY} then
				field_list := field_list.query_if (agent {EL_REFLECTED_FIELD}.is_type (type.type_id))
			end
			create Result.make (field_list.count)
			across field_list as list loop
				field := list.item
				if element_set.has (field.index) then
					node_type := Text_element_node
				else
					node_type := Attribute_node
				end
				if attached {EL_REFLECTED_TUPLE} field as tuple_field
						and then attached tuple_field.field_name_list as name_list
				then
					across name_list as name loop
						l_xpath := s.joined (tuple_field.export_name, Attribute_path) +  name.item
						item_type_id := tuple_field.member_types [name.cursor_index].type_id
						Result [l_xpath] := agent set_tuple_item_from_node (tuple_field, name.cursor_index, item_type_id)
					end
				elseif attached {EL_REFLECTED_REFERENCE [ANY]} field as ref_field
					and then attached new_build_action (ref_field, node_type) as action
				then
					Result [action.xpath] := action.procedure
				else
					Result [new_xpath (field, node_type)] := agent set_field_from_readable (field)
				end
			end
		end

	set_builder_field_context (context_field: EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT])
		do
			if attached {EL_EIF_OBJ_XPATH_CONTEXT} context_field.value (Current) as context then
				set_next_context (context)
			end
		end

	set_reflective_field_context (
		field: EL_REFLECTED_REFERENCE [ANY]; reflective_context: EL_REFLECTIVE_OBJECT_BUILDER_CONTEXT
	)
		do
			if attached {EL_REFLECTIVE} field.value (Current) as object then
				reflective_context.set_object (object)
				set_next_context (reflective_context)
			end
		end

	extend_collection (field_collection: EL_REFLECTED_COLLECTION [ANY])
		do
			field_collection.extend_from_readable (Current, node)
		end

	extend_context_collection (builder_context_list: EL_REFLECTED_COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT])
		require
			extendible_collection: builder_context_list.is_extendible (Current)
		do
			builder_context_list.extend_with_new (Current)
			if attached {CHAIN [EL_EIF_OBJ_BUILDER_CONTEXT]}
				builder_context_list.collection (Current) as list
			then
				set_next_context (list.last)
			end
		end

	set_field_from_readable (field: EL_REFLECTED_FIELD)
		do
			field.set_from_readable (Current, node)
		end

	set_field_from_node (field: EL_REFLECTED_STRING [READABLE_STRING_GENERAL])
		-- set string `field' with a cached value from `field.hash_set'
		do
			field.set_from_node (Current, node)
		end

	set_path_field_from_node (field: EL_REFLECTED_PATH)
		do
			field.set_from_readable (Current, node)
			field.expand (Current)
			if field.type_id = Class_id.FILE_PATH
				and then attached {FILE_PATH} field.value (Current) as file_path
				and then not file_path.is_absolute
				and then not node.document_dir.is_empty
			then
				field.set (Current, node.document_dir.plus_file (file_path))
			end
		end

	set_tuple_item_from_node (field: EL_REFLECTED_TUPLE; index: INTEGER; type_id: INTEGER)
		do
			if attached field.value (Current) as l_tuple then
				Tuple.set_i_th (l_tuple, index, node, type_id)
			end
		end

feature {NONE} -- Implementation

	is_importable (field: EL_REFLECTED_FIELD): BOOLEAN
		local
			basic_type, type_id, item_type_id: INTEGER
		do
			basic_type := field.abstract_type; type_id := field.type_id
			if Eiffel.is_type_convertable_from_string (basic_type, type_id)
				or else is_builder_context_field (type_id)
			then
				Result := True

			elseif Eiffel.field_conforms_to_collection (basic_type, type_id) then
				item_type_id := Eiffel.collection_item_type (type_id)
				Result := Convert_string.has (item_type_id) or else is_builder_context_field (item_type_id)
			end
		end

	is_builder_context_field (type_id: INTEGER): BOOLEAN
		do
			Result := Eiffel.type_of_type (type_id).conforms_to ({EL_EIF_OBJ_BUILDER_CONTEXT})
		end

feature {NONE} -- Constants

	Importable_fields_table_by_type: EL_FUNCTION_RESULT_TABLE [
		EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT, EL_ARRAYED_LIST [EL_REFLECTED_FIELD]
	]
		-- table of fields importable from XML
		once
			create Result.make (17, agent {EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT}.new_importable_list)
		end

	Item: TUPLE [name, xpath, text_xpath: STRING]
		-- list item name
		once
			create Result
			Tuple.fill (Result, "item, /item, /item/text()")
		end

note
	descendants: "[
			EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT*
				${RBOX_IRADIO_ENTRY}
					${RBOX_IGNORED_ENTRY}
						${RBOX_SONG}
							${RBOX_CORTINA_SONG}
								${RBOX_CORTINA_TEST_SONG}
							${RBOX_TEST_SONG}
								${RBOX_CORTINA_TEST_SONG}
						${RBOX_PLAYLIST_ENTRY}
				${DJ_EVENT_PUBLISHER_CONFIG}
				${DJ_EVENT_INFO}
				${CORTINA_SET_INFO}
				${EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN*}
					${EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS*}
						${RBOX_MANAGEMENT_TASK*}
							${IMPORT_M3U_PLAYLISTS_TASK}
							${IMPORT_NEW_MP3_TASK}
							${PUBLISH_DJ_EVENTS_TASK}
							${DEFAULT_TASK}
							${UPDATE_DJ_PLAYLISTS_TASK}
							${ID3_TASK*}
								${DISPLAY_MUSIC_BRAINZ_INFO_TASK}
								${ADD_ALBUM_ART_TASK}
								${DELETE_COMMENTS_TASK}
								${DISPLAY_INCOMPLETE_ID3_INFO_TASK}
								${NORMALIZE_COMMENTS_TASK}
								${PRINT_COMMENTS_TASK}
								${REMOVE_ALL_UFIDS_TASK}
								${REMOVE_UNKNOWN_ALBUM_PICTURES_TASK}
								${UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK}
							${COLLATE_SONGS_TASK}
							${ARCHIVE_SONGS_TASK}
							${IMPORT_VIDEOS_TASK}
								${IMPORT_VIDEOS_TEST_TASK}
								${IMPORT_YOUTUBE_M4A_TASK}
							${LIST_VOLUMES_TASK}
							${REPLACE_CORTINA_SET_TASK}
								${REPLACE_CORTINA_SET_TEST_TASK}
							${REPLACE_SONGS_TASK}
								${REPLACE_SONGS_TEST_TASK}
							${RESTORE_PLAYLISTS_TASK}
							${EXPORT_TO_DEVICE_TASK*}
								${EXPORT_MUSIC_TO_DEVICE_TASK}
									${EXPORT_PLAYLISTS_TO_DEVICE_TASK}
				${VOLUME_INFO}
				${PLAYLIST_EXPORT_INFO}
	]"
end