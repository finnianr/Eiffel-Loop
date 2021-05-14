note
	description: "Extension to [$source DATE_TIME_TOOLS]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-05-14 8:18:52 GMT (Friday 14th May 2021)"
	revision: "2"

class
	EL_DATE_TIME_TOOLS

inherit
	DATE_TIME_TOOLS

feature -- Constants

	Format_iso_8601: STRING = "yyyy-[0]mm-[0]ddT[0]hh:[0]mi:[0]ssZ"

	format_iso_8601_short: STRING = "yyyy[0]mm[0]ddT[0]hh[0]mi[0]ssZ"

end