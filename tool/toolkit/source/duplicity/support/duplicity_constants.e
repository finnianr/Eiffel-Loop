note
	description: "Duplicity constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "5"

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