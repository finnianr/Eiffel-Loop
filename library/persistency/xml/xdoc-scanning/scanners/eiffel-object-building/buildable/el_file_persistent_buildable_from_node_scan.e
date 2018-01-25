note
	description: "Summary description for {EL_FILE_PERSISTENT_BUILDABLE_FROM_NODE_SCAN}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-12-11 8:20:21 GMT (Monday 11th December 2017)"
	revision: "2"

deferred class
	EL_FILE_PERSISTENT_BUILDABLE_FROM_NODE_SCAN [EVENT_SOURCE -> EL_PARSE_EVENT_SOURCE]

inherit
	EL_BUILDABLE_FROM_NODE_SCAN
		redefine
			make_default, make_from_file
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			save_as_xml as store_as
--			make_default as make_serializeable
		redefine
			make_from_file, make_default
		end

	EL_FILE_PERSISTENT
		rename
			file_path as output_path,
			set_file_path as set_output_path
		redefine
			make_from_file
		end

feature {EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT} -- Initialization

	make_default
		do
			-- NOT THIS:
			Precursor {EVOLICITY_SERIALIZEABLE_AS_XML}
--			make_empty
			Precursor {EL_BUILDABLE_FROM_NODE_SCAN}
		end

	make_from_file (a_file_path: like output_path)
			--
		do
			Precursor {EVOLICITY_SERIALIZEABLE_AS_XML} (a_file_path)
			if a_file_path.exists then
				build_from_file (a_file_path)
				set_encoding_from_name (node_source.encoding_name)
			end
		end

feature {NONE} -- Factory

	new_node_source: EL_XML_NODE_SCAN_TO_EIFFEL_OBJECT_BUILDER
			--
		do
			create Result.make ({EVENT_SOURCE})
		end

end
