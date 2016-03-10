note
	description: "Summary description for {EL_XML_STORABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-22 18:08:01 GMT (Monday 22nd July 2013)"
	revision: "3"

deferred class
	EL_BUILDABLE_XML_FILE_PERSISTENT

inherit
	EL_BUILDABLE_FROM_XML
		rename
			make_default as make,
			make_from_file as make_buildable_from_file,
			make as make_buildable
		redefine
			make_from_binary_stream, make_from_binary_file
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			save_as_xml as store_as,
			make as make_serializeable,
			make_from_file as make_serializeable_from_file
		undefine
			utf8_encoded
		redefine
			encoding_name
		end

	EL_FILE_PERSISTENT
		rename
			file_path as output_path,
			set_file_path as set_output_path
		redefine
			make_from_file, make
		end

feature {EL_EIF_OBJ_FACTORY_ROOT_BUILDER_CONTEXT} -- Initialization

	make
			--
		do
			Precursor
			make_buildable
			make_serializeable
		end

	make_from_file (a_file_path: like output_path)
			--
		do
			Precursor (a_file_path)
			make_serializeable_from_file (a_file_path)
			if a_file_path.exists then
				make_buildable_from_file (a_file_path)
			end
		end

	make_from_binary_file (a_file_path: like output_path)
			--
		do
			if attached {like output_path} a_file_path.without_extension as a_output_file_path then
				make_from_file (a_output_file_path)
			end
		end

	make_from_binary_stream (a_stream: IO_MEDIUM)
			--
		do
			make
			Precursor (a_stream)
		end

feature -- Access

	encoding_name: EL_ASTRING
		do
			Result := Builder.encoding_name
		end

feature -- Status query

	utf8_encoded: BOOLEAN
		do
			Result := Builder.encoding_type ~ "UTF" and then Builder.encoding = 8
		end

end
