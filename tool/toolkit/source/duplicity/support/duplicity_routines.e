note
	description: "Duplicity routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "4"

deferred class
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