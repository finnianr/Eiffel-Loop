note
	description: "Duplicity constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-07-16 13:02:47 GMT (Thursday 16th July 2020)"
	revision: "3"

class
	DUPLICITY_CONSTANTS

feature {NONE} -- Constants

	Command_template: STRING = "[
		duplicity $type $options $exclusions $target "$destination"
	]"

	Time_now: DATE_TIME
		once
			create Result.make_now
		end

end
