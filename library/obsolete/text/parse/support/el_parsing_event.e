note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2014 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2015-03-16 15:20:12 GMT (Monday 16th March 2015)"
	revision: "3"

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
			source_text_view_arg := source_text_view.twin
		end

feature {EL_PARSER} -- Basic Operation

	call
			-- Becareful to use 'out' when accessing the text
		local
			tuple: like Procedure_argument
		do
			tuple := Procedure_argument
			tuple.put (source_text_view_arg, 1)
			event_procedure.call (tuple)
		end

feature {NONE} -- Implementation

	event_procedure: PROCEDURE [ANY, TUPLE [EL_STRING_VIEW]]

	source_text_view_arg: EL_STRING_VIEW

feature {NONE} -- Constants

	Procedure_argument: TUPLE [EL_STRING_VIEW]
		once
			create Result
		end

end -- class EL_PARSING_EVENT

