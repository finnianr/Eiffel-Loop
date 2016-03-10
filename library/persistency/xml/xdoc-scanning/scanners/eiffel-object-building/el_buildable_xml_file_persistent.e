note
	description: "Summary description for {EL_XML_STORABLE}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "5"

deferred class
	EL_BUILDABLE_XML_FILE_PERSISTENT

inherit
	EL_BUILDABLE_FROM_XML
		redefine
			make_default, make_from_file, make_from_binary_stream, make_from_binary_file
		end

	EVOLICITY_SERIALIZEABLE_AS_XML
		rename
			save_as_xml as store_as
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
			Precursor {EVOLICITY_SERIALIZEABLE_AS_XML}
			Precursor {EL_BUILDABLE_FROM_XML}
		end

	make_from_file (a_file_path: like output_path)
			--
		do
			Precursor {EVOLICITY_SERIALIZEABLE_AS_XML} (a_file_path)
			if a_file_path.exists then
				build_from_file (a_file_path)
				set_encoding_from_name (Builder.encoding_name)
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
			make_default
			Precursor (a_stream)
		end

end
