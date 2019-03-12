note
	description: "Duplicity constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-03-12 18:18:55 GMT (Tuesday 12th March 2019)"
	revision: "1"

class
	DUPLICITY_CONSTANTS

feature {NONE} -- Constants

	Command_template: STRING = "[
		duplicity $type $options $exclusions $target "$destination"
	]"

end
