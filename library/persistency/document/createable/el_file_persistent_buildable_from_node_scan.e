note
	description: "File persistent buildable from node scan"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-06-30 9:49:20 GMT (Friday 30th June 2023)"
	revision: "13"

deferred class
	EL_FILE_PERSISTENT_BUILDABLE_FROM_NODE_SCAN

inherit
	EL_BUILDABLE_FROM_NODE_SCAN
		redefine
			make_default, make_from_file
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			save_as_xml as store_as
		redefine
			make_from_file, make_default
		end

	EL_FILE_PERSISTENT_I
		rename
			file_path as output_path,
			set_file_path as set_output_path
		end

feature {EL_EIF_OBJ_ROOT_BUILDER_CONTEXT} -- Initialization

	make_default
		do
			Precursor {EL_BUILDABLE_FROM_NODE_SCAN}
			Precursor {EVOLICITY_SERIALIZEABLE_AS_XML}
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

end