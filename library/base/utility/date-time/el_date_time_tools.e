note
	description: "El DATE TIME TOOLS"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-13 13:52:02 GMT (Thursday 13th May 2021)"
	revision: "1"

class
	EL_DATE_TIME_TOOLS

inherit
	DATE_TIME_TOOLS

feature -- Constants

	Format_iso_8601: STRING = "yyyy-[0]mm-[0]ddT[0]hh:[0]mi:[0]ssZ"

	format_iso_8601_short: STRING = "yyyy[0]mm[0]ddT[0]hh[0]mi[0]ssZ"

end