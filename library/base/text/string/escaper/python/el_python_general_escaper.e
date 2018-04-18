note
	description: "Summary description for {EL_PYTHON_STRING_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-10 14:41:55 GMT (Tuesday 10th April 2018)"
	revision: "4"

deferred class
	EL_PYTHON_GENERAL_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER
		rename
			make as make_escaper
		end

feature {NONE} -- Initialization

	make (quote_count: INTEGER)
		require
			single_or_double_quotes: quote_count = 1 or quote_count = 2
		do
			if quote_count = 1 then
				make_escaper (once "%T%N\'")
			else
				make_escaper (once "%T%N\%"")
			end
		end

end
