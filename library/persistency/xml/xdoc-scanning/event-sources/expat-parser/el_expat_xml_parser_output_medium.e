note
	description: "Summary description for {EL_EXPAT_XML_PARSER_INPUT_MEDIUM}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:29 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM

inherit
	EL_EXPAT_XML_PARSER
		redefine
			make
		end

	EL_XML_PARSER_OUTPUT_MEDIUM
		rename
			make as make_output
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

end
