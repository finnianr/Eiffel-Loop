note
	description: "Summary description for {EL_XML_FILE_PERSISTENT}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-12-31 11:42:41 GMT (Tuesday 31st December 2013)"
	revision: "3"

deferred class
	EL_XML_FILE_PERSISTENT

inherit
	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			save_as_xml as store_as,
			make as make_serializeable,
			make_from_file as make_serializeable_from_file
		redefine
			encoding_name, output_file_exists
		end

	EL_FILE_PERSISTENT
		rename
			file_path as output_path,
			set_file_path as set_output_path
		redefine
			make, make_from_file
		end

feature {NONE} -- Initialization

	make
		do
			Precursor
			encoding_name := Default_encoding_name
			make_serializeable
		end

	make_from_file (a_file_path: EL_FILE_PATH)
			--
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			Precursor (a_file_path)
			make_serializeable_from_file (a_file_path)
			create root_node.make_from_file (a_file_path)
			encoding_name := root_node.encoding_name
			make_from_root_node (root_node)
		end

	make_from_other (other: like Current)
		local
			root_node: EL_XPATH_ROOT_NODE_CONTEXT
		do
			make
			output_path := other.output_path.twin
			create root_node.make_from_string (other.to_xml)
			encoding_name := root_node.encoding_name
			make_from_root_node (root_node)
		end

	make_from_root_node (root_node: EL_XPATH_ROOT_NODE_CONTEXT)
		deferred
		end

feature -- Access

	encoding_name: STRING

feature {NONE} -- Implementation

	output_file_exists: BOOLEAN
			-- True if output file exists after creation
		do
			Result := True
		end

end
