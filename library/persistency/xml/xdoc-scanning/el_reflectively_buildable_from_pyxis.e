note
	description: "Reflectively buildable from pyxis"
	descendants: "See end of class"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-09-02 12:14:22 GMT (Monday 2nd September 2019)"
	revision: "3"

deferred class
	EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS

inherit
	EL_BUILDABLE_FROM_PYXIS
		rename
			xml_name_space as xmlns
		undefine
			is_equal, new_building_actions
		redefine
			make_default
		end

	EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN
		rename
			element_node_type as	Attribute_node,
			xml_names as export_default,
			xml_name_space as xmlns
		export
			{NONE} all
		redefine
			make_default
		end

	EL_MODULE_XML

feature {NONE} -- Initialization

	make_default
		do
			register_default_values
			create node_source.make (agent new_node_source)
			Precursor {EL_REFLECTIVELY_BUILDABLE_FROM_NODE_SCAN}
		end

feature {NONE} -- Implementation

	register_default_values
		-- Implement this as a once routine to register a default value for any attributes
		-- conforming to class `EL_REFLECTIVE_EIF_OBJ_BUILDER_CONTEXT'.
	 	-- For example:
		-- once
		--		Default_value_table.extend_from_array (<< create {like values}.make_default >>)
		--	end
		deferred
		end

	root_node_name: STRING
			--
		do
			Result := Naming.class_as_lower_snake (Current, 0, 0)
		end

note
	descendants: "[
			EL_REFLECTIVELY_BUILDABLE_FROM_PYXIS*
				[$source MANAGEMENT_TASK]*
					[$source COLLATE_SONGS_TASK]
					[$source DEFAULT_TASK]
					[$source ADD_ALBUM_ART_TASK]
					[$source EXPORT_MUSIC_TO_DEVICE_TASK]
						[$source EXPORT_MUSIC_TO_DEVICE_TEST_TASK]
						[$source EXPORT_PLAYLISTS_TO_DEVICE_TASK]
							[$source EXPORT_PLAYLISTS_TO_DEVICE_TEST_TASK]
					[$source TEST_MANAGEMENT_TASK]*
						[$source EXPORT_MUSIC_TO_DEVICE_TEST_TASK]
						[$source EXPORT_PLAYLISTS_TO_DEVICE_TEST_TASK]
						[$source IMPORT_VIDEOS_TEST_TASK]
						[$source UPDATE_DJ_PLAYLISTS_TEST_TASK]
						[$source REPLACE_SONGS_TEST_TASK]
						[$source REPLACE_CORTINA_SET_TEST_TASK]
					[$source IMPORT_VIDEOS_TASK]
						[$source IMPORT_VIDEOS_TEST_TASK]
					[$source ARCHIVE_SONGS_TASK]
					[$source DELETE_COMMENTS_TASK]
					[$source DISPLAY_INCOMPLETE_ID3_INFO_TASK]
					[$source DISPLAY_MUSIC_BRAINZ_INFO_TASK]
					[$source UPDATE_DJ_PLAYLISTS_TASK]
						[$source UPDATE_DJ_PLAYLISTS_TEST_TASK]
					[$source PRINT_COMMENTS_TASK]
					[$source PUBLISH_DJ_EVENTS_TASK]
					[$source REMOVE_ALL_UFIDS_TASK]
					[$source REPLACE_CORTINA_SET_TASK]
						[$source REPLACE_CORTINA_SET_TEST_TASK]
					[$source REPLACE_SONGS_TASK]
						[$source REPLACE_SONGS_TEST_TASK]
					[$source REMOVE_UNKNOWN_ALBUM_PICTURES_TASK]
					[$source UPDATE_COMMENTS_WITH_ALBUM_ARTISTS_TASK]
					[$source NORMALIZE_COMMENTS_TASK]
	]"	
end
