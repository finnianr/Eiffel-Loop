note
	description: "Module pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-19 14:18:15 GMT (Saturday 19th November 2022)"
	revision: "9"

deferred class
	EL_MODULE_PATTERN

inherit
	EL_MODULE

	EL_TEXT_PATTERN_FACTORY
		export
			{NONE} all
		end

feature {NONE} -- Constants

	Pattern: EL_TEXTUAL_PATTERN_MATCH_ROUTINES
			--
		once
			create Result.make (agent start_of_line)
		end

end