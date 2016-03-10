note
	description: "Summary description for {EL_EXPAT_XML_PARSER_INPUT_MEDIUM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2014-09-02 10:55:12 GMT (Tuesday 2nd September 2014)"
	revision: "2"

class
	EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM

inherit
	EL_EXPAT_XML_PARSER
		rename
			position as xml_position
		redefine
			make
		end

	EL_XML_PARSER_OUTPUT_MEDIUM
		rename
			make as make_output,
			put_string as put_string_8
		end

	EL_OUTPUT_MEDIUM
		rename
			codec as output_codec
		undefine
			set_encoding
		end

create
	make, make_delimited

feature {NONE}  -- Initialisation

	make (a_scanner: like scanner)
			--
		do
			make_output
			Precursor (a_scanner)
		end

feature -- Basic operations

	parse_from_serializable_object (object: EVOLICITY_SERIALIZEABLE_AS_XML)
			--
		do
			reset
			protect_C_callbacks
			scanner.on_start_document
			object.serialize_to_stream (Current)
			if is_correct then
				finish_incremental
			end
			unprotect_C_callbacks
		end

feature {NONE} -- Unimplemented

	open_read
		do
		end

	open_write
		do
		end

	position: INTEGER
		do
		end
end
