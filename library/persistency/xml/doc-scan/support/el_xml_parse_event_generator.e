note
	description: "Parse event generator specifically for XML"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2025-03-18 7:03:32 GMT (Tuesday 18th March 2025)"
	revision: "13"

class
	EL_XML_PARSE_EVENT_GENERATOR

inherit
	EL_PARSE_EVENT_GENERATOR
		rename
			make as make_generator
		redefine
			event_source, default_event_source
		end

create
	make

feature {NONE} -- Initialization

	make
			--
		do
			make_generator ({like event_source})
		end

feature -- Basic operations

	send_object (object: EVC_SERIALIZEABLE_AS_XML; a_output: like output)
			-- send `object' to `a_output' as binary encoded XML
		do
			output := a_output
			if is_lio_enabled then
				lio.put_labeled_string ("send_object", object.generator)
				lio.put_new_line
			end
			event_source.parse_from_serializable_object (object)
			output := Default_output
		end

feature {NONE} -- Implementation

	default_event_source: EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM
		do
			create Result.make (Current)
		end

feature {NONE} -- Internal attributes

	event_source: EL_EXPAT_XML_PARSER_OUTPUT_MEDIUM

end