note
	description: "Reflective Eiffel object builder (from XML) context"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-08 10:57:42 GMT (Wednesday 8th April 2020)"
	revision: "13"

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
			field_included as is_field_convertable_from_xml,
			export_name as xml_names,
			import_name as xml_names
		export
			{NONE} all
		redefine
			Except_fields, make_default, new_meta_data
		end

	EL_SETTABLE_FROM_XML_NODE
		undefine
			is_equal
		end

feature {NONE} -- Initialization

	make_default
		do
			Precursor {EL_REFLECTIVELY_SETTABLE}
			Precursor {EL_EIF_OBJ_BUILDER_CONTEXT}
		end

feature {NONE} -- Implementation

	new_meta_data: EL_EIF_OBJ_BUILDER_CONTEXT_CLASS_META_DATA
		do
			create Result.make (Current)
		end

feature {NONE} -- Build from XML

	building_action_table: EL_PROCEDURE_TABLE [STRING]
			--
		do
			Result := building_actions_for_type (({ANY}), element_node_type)
		end

	element_node_type: INTEGER
		-- type of XML node mapped to attribute value
		-- Possible values `Text_element_node' or `Attribute_node'
		deferred
		ensure
			valid_node_type: Node_types.has (Result)
		end

feature {NONE} -- Constants

	Except_fields: STRING
		once
			Result := Precursor + ", next_context, xpath"
		end

note
	descendants: "[
			EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT*
				[$source TEST_VALUES]
				[$source EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN]*
					[$source EL_REFLECTIVE_BUILDABLE_AND_STORABLE_AS_XML]*
						[$source TEST_CONFIGURATION]
				[$source RBOX_IRADIO_ENTRY]
					[$source RBOX_IGNORED_ENTRY]
						[$source RBOX_SONG]
							[$source RBOX_CORTINA_SONG]
								[$source RBOX_CORTINA_TEST_SONG]
							[$source RBOX_TEST_SONG]
					rou			[$source RBOX_CORTINA_TEST_SONG]
				[$source EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN]*
					[$source EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS]*
						[$source TASK_CONFIG]
							[$source TEST_TASK_CONFIG]
				[$source DJ_EVENT_PUBLISHER_CONFIG]
				[$source CORTINA_SET_INFO]
				[$source DJ_EVENT_INFO]
				[$source PLAYLIST_EXPORT_INFO]
				[$source VOLUME_INFO]
	]"
end
