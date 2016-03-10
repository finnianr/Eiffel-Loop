note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:32 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_PARSING_EVENT

inherit
	EL_MODULE_LOG

create
	make

feature {NONE} -- Initialization

	make (source_text_view: EL_STRING_VIEW; procedure: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]])
			--
		do
			event_procedure := procedure
			create source_text_view_arg.make_from_other (source_text_view)
		end

feature {EL_PARSER} -- Basic Operation

	call
			-- Becareful to use 'out' when accessing the text
		local
			source_text_view_arg_tuple: TUPLE [EL_STRING_VIEW]
		do
			create source_text_view_arg_tuple
			source_text_view_arg_tuple.put (source_text_view_arg, 1)
			event_procedure.call (source_text_view_arg_tuple)
		end

feature {NONE} -- Implementation

	source_text_view_arg: EL_STRING_VIEW

	event_procedure: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]

end -- class EL_PARSING_EVENT

