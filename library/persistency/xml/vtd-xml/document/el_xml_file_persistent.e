note
	description: "XML file persistent"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:32 GMT (Tuesday 18th March 2025)"
	revision: "14"

deferred class
	EL_XML_FILE_PERSISTENT

inherit
	EVC_SERIALIZEABLE_AS_XML
		rename
			save_as_xml as store_as
		export
			{EL_XML_FILE_PERSISTENT} template_path
		redefine
			make_from_file, file_must_exist
		end

	EL_FILE_PERSISTENT_I
		rename
			file_path as output_path,
			set_file_path as set_output_path
		end

feature {NONE} -- Initialization

	make_from_file (a_file_path: FILE_PATH)
			--
		local
			xdoc: EL_XML_DOC_CONTEXT
		do
			Precursor {EVC_SERIALIZEABLE_AS_XML} (a_file_path)
			create xdoc.make_from_file (a_file_path)
			set_encoding_from_name (xdoc.encoding_name)
			make_from_xdoc (xdoc)
		end

	make_from_other (other: like Current)
		local
			xdoc: EL_XML_DOC_CONTEXT
		do
			make_from_template_and_output (other.template_path.twin, other.output_path.twin)
			create xdoc.make_from_string (other.to_xml)
			set_encoding_from_name (xdoc.encoding_name)
			make_from_xdoc (xdoc)
		end

	make_from_xdoc (xdoc: EL_XML_DOC_CONTEXT)
		deferred
		end

feature {NONE} -- Implementation

	file_must_exist: BOOLEAN
			-- True if output file exists after creation
		do
			Result := True
		end

end