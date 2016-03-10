note
	description: ""

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:31 GMT (Sunday 16th December 2012)"
	revision: "1"

deferred class
	EL_STRING_EDITION

feature {NONE} -- Initialization

	make (a_caret_position, a_start_index: like start_index)
		do
			caret_position := a_caret_position
			start_index := a_start_index
		end

feature -- Access

	start_index: NATURAL_16

	caret_position: NATURAL_16

	applied (target: EL_ASTRING): EL_ASTRING
		do
			Result := target.twin
			apply (Result)
		end

feature -- Basic operations

	apply (target: EL_ASTRING)
		deferred
		end

end
