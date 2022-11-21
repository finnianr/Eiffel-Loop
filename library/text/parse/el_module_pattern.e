note
	description: "Module pattern"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-21 14:24:56 GMT (Monday 21st November 2022)"
	revision: "10"

deferred class
	EL_MODULE_PATTERN

inherit
	EL_MODULE

	TP_FACTORY
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