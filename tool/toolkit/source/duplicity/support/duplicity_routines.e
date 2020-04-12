note
	description: "Duplicity routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-12 12:59:43 GMT (Sunday 12th April 2020)"
	revision: "2"

class
	DUPLICITY_ROUTINES

inherit
	DUPLICITY_CONSTANTS

feature {NONE} -- Implementation

	formatted (time: DATE_TIME): STRING
		do
			if time = Time_now then
				Result := "now"
			else
				Result := time.formatted_out (once "yyyy-[0]mm-[0]dd [0]hh24:[0]mi:[0]ss")
				Result [Result.index_of (' ', 1)] := 'T'
			end
		end

end
