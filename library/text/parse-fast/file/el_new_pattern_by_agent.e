note
	description: "Object that creates a [$source EL_TEXT_PATTERN] using a supplied [$source FUNCTION] agent"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-19 12:34:54 GMT (Saturday 19th November 2022)"
	revision: "1"

deferred class
	EL_NEW_PATTERN_BY_AGENT

feature {NONE} -- Initialization

	make_default
		deferred
		end

	make_with_agent (pattern_function: FUNCTION [EL_TEXT_PATTERN])

		do
			make_default
			new_pattern_function := pattern_function
		end

feature -- Element change

	set_pattern (pattern_function: FUNCTION [EL_TEXT_PATTERN])

		do
			new_pattern_function := pattern_function
			reset_pattern
		end

feature {NONE} -- Implementation

	new_pattern: EL_TEXT_PATTERN
		do
			new_pattern_function.apply
			Result := new_pattern_function.last_result
		end

	reset_pattern
		deferred
		end

feature {NONE} -- Internal attributes

	new_pattern_function: FUNCTION [EL_TEXT_PATTERN]

end