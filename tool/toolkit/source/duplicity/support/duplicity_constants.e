note
	description: "Duplicity constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-04-12 12:56:12 GMT (Sunday 12th April 2020)"
	revision: "2"

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
