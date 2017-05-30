note
	description: "Summary description for {MARKUP_SUBSTITUTION}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2017-05-28 11:08:13 GMT (Sunday 28th May 2017)"
	revision: "1"

class
	MARKUP_SUBSTITUTION

create
	make

feature {NONE} -- Initialization

	make (a_delimiter_start, a_delimiter_end, a_markup_open, a_markup_close: ZSTRING)
		do
			delimiter_start := a_delimiter_start; delimiter_end := a_delimiter_end
			markup_open := a_markup_open; markup_close := a_markup_close
		end

feature -- Access

	delimiter_end: ZSTRING

	delimiter_start: ZSTRING

	markup_close: ZSTRING

	markup_open: ZSTRING

end
