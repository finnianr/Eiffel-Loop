note
	description: "Object that creates a ${TP_PATTERN} using a supplied ${FUNCTION} agent"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:56 GMT (Monday 21st November 2022)"
	revision: "2"

deferred class
	EL_NEW_PATTERN_BY_AGENT

feature {NONE} -- Initialization

	make_default
		deferred
		end

	make_with_agent (pattern_function: FUNCTION [TP_PATTERN])

		do
			make_default
			new_pattern_function := pattern_function
		end

feature -- Element change

	set_pattern (pattern_function: FUNCTION [TP_PATTERN])

		do
			new_pattern_function := pattern_function
			reset_pattern
		end

feature {NONE} -- Implementation

	new_pattern: TP_PATTERN
		do
			new_pattern_function.apply
			Result := new_pattern_function.last_result
		end

	reset_pattern
		deferred
		end

feature {NONE} -- Internal attributes

	new_pattern_function: FUNCTION [TP_PATTERN]

end