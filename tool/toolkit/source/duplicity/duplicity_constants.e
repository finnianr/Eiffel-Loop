note
	description: "Summary description for {DUPLICITY_CONSTANTS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	DUPLICITY_CONSTANTS

feature {NONE} -- Constants

	Command_template: STRING = "[
		duplicity $type $options $exclusions $target "$destination"
	]"

end
