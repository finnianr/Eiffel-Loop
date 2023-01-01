note
	description: "Reflective Eiffel object builder (from XML) context"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-01-01 17:29:10 GMT (Sunday 1st January 2023)"
	revision: "23"

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
		redefine
			make_default, new_meta_data
		end

	EL_MODULE_CONVERT_STRING; EL_MODULE_TUPLE

	EL_EIF_OBJ_BUILDER_CONTEXT_TYPE_CONSTANTS

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
					Result := s.character_string ('@') + field.export_name
				when Text_element_node then
					Result := field.export_name + once "/text()"
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
			field_list: like importable_list; l_xpath: STRING_8
			node_type: INTEGER; field: EL_REFLECTED_FIELD
		do
			field_list := importable_list
			if type /= {ANY} then
				field_list := field_list.query_if (agent {EL_REFLECTED_FIELD}.is_type (type.type_id))
			end
			create Result.make_equal (field_list.count)
			across field_list as list loop
				field := list.item
				if element_set.has (field.index) then
					node_type := Text_element_node
				else
					node_type := Attribute_node
				end
				if attached {EL_REFLECTED_COLLECTION [EL_EIF_OBJ_BUILDER_CONTEXT]} field as builder_context_list then
					l_xpath := new_xpath (field, Element_node) + Item.xpath
					Result [l_xpath] := agent extend_context_collection (builder_context_list)

				elseif attached {EL_REFLECTED_COLLECTION [ANY]} field as collection_field then
					l_xpath := new_xpath (field, Element_node) + Item.text_xpath
					Result [l_xpath] := agent extend_collection (collection_field)

				elseif attached {EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT]} field as context_field then
					Result [new_xpath (field, Element_node)] := agent change_context (context_field)

				elseif attached {EL_REFLECTED_PATH} field as path_field then
					Result [new_xpath (field, node_type)] := agent set_path_field_from_node (path_field)

				elseif attached {EL_REFLECTED_STRING [READABLE_STRING_GENERAL]} field as string_field
					and then string_field.is_value_cached
				then
					-- Field value caching
					l_xpath := new_xpath (string_field, node_type)
					Result [l_xpath] := agent set_cached_field_from_node (string_field)
				else
					Result [new_xpath (field, node_type)] := agent set_field_from_node (field)
				end
			end
		end

	change_context (context_field: EL_REFLECTED_REFERENCE [EL_EIF_OBJ_BUILDER_CONTEXT])
		do
			if attached {EL_EIF_OBJ_XPATH_CONTEXT} context_field.value (Current) as context then
				set_next_context (context)
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

	set_field_from_node (field: EL_REFLECTED_FIELD)
		do
			field.set_from_readable (Current, node)
		end

	set_cached_field_from_node (field: EL_REFLECTED_STRING [READABLE_STRING_GENERAL])
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
				field.set (Current, node.document_dir.plus (file_path))
			end
		end

feature {NONE} -- Implementation

	element_node_field_set: EL_FIELD_INDICES_SET
		do
			if element_node_fields = All_fields then
				create Result.make_for_any (field_table)
			else
				create Result.make_from_reflective (Current, element_node_fields)
			end
		end

	is_importable (field: EL_REFLECTED_FIELD): BOOLEAN
		local
			basic_type, type_id, item_type_id: INTEGER
		do
			basic_type := field.category_id; type_id := field.type_id
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

feature {NONE} -- Deferred

	element_node_fields: STRING
		-- list of fields that will be treated as XML elements
		-- (default is element attributes)
		deferred
		ensure
			renamed_to_once_fields: Result.is_empty implies Result = Empty_set or Result = All_fields
			valid_field_names: valid_field_names (Result)
		end

feature {NONE} -- Constants

	All_fields: STRING
		-- rename `element_node_fields' as this to treat all fields as XML elements rather than
		-- attributes
		once ("PROCESS")
			create Result.make_empty
		end

	Empty_set: STRING = ""
		-- rename `element_node_fields' as this to exclude all

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
				[$source RBOX_IRADIO_ENTRY]
					[$source RBOX_IGNORED_ENTRY]
						[$source RBOX_SONG]
							[$source RBOX_CORTINA_SONG]
								[$source RBOX_CORTINA_TEST_SONG]
							[$source RBOX_TEST_SONG]
								[$source RBOX_CORTINA_TEST_SONG]
						[$source RBOX_PLAYLIST_ENTRY]
				[$source CORTINA_SET_INFO]
				[$source DJ_EVENT_PUBLISHER_CONFIG]
				[$source VOLUME_INFO]
				[$source PLAYLIST_EXPORT_INFO]
				[$source DJ_EVENT_INFO]
				[$source EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN]*
					[$source EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS]*
						[$source RBOX_MANAGEMENT_TASK]*
							[$source COLLATE_SONGS_TASK]
							[$source IMPORT_M3U_PLAYLISTS_TASK]
							[$source IMPORT_NEW_MP3_TASK]
							[$source PUBLISH_DJ_EVENTS_TASK]
							[$source DEFAULT_TASK]
							[$source UPDATE_DJ_PLAYLISTS_TASK]
							[$source ARCHIVE_SONGS_TASK]
							[$source IMPORT_VIDEOS_TASK]
								[$source IMPORT_VIDEOS_TEST_TASK]
								[$source IMPORT_YOUTUBE_M4A_TASK]
							[$source LIST_VOLUMES_TASK]
							[$source REPLACE_CORTINA_SET_TASK]
								[$source REPLACE_CORTINA_SET_TEST_TASK]
							[$source REPLACE_SONGS_TASK]
								[$source REPLACE_SONGS_TEST_TASK]
							[$source RESTORE_PLAYLISTS_TASK]
							[$source EXPORT_TO_DEVICE_TASK]*
								[$source EXPORT_MUSIC_TO_DEVICE_TASK]
									[$source EXPORT_PLAYLISTS_TO_DEVICE_TASK]
							[$source ID3_TASK]*
								[$source ADD_ALBUM_ART_TASK]
								[$source DELETE_COMMENTS_TASK]
								[$source DISPLAY_INCOMPLETE_ID3_INFO_TASK]
								[$source DISPLAY_MUSIC_BRAINZ_INFO_TASK]
								[$source NORMALIZE_COMMENTS_TASK]
								[$source PRINT_COMMENTS_TASK]
								[$source REMOVE_ALL_UFIDS_TASK]
								[$source REMOVE_UNKNOWN_ALBUM_PICTURES_TASK]
								[$source UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK]
	]"
end