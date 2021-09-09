note
	description: "Duplicity constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 16:17:28 GMT (Thursday 9th September 2021)"
	revision: "4"

deferred class
	DUPLICITY_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Command_template: STRING = "[
		duplicity $type $options $exclusions $target "$destination"
	]"

	Time_now: EL_DATE_TIME
		once
			create Result.make_now
		end

end