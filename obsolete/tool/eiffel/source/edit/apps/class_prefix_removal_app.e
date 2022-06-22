note
	description: "[
		 Command line inteface to class [$source CLASS_PREFIX_REMOVAL_COMMAND]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-06 16:41:41 GMT (Sunday 6th February 2022)"
	revision: "17"

class
	CLASS_PREFIX_REMOVAL_APP

inherit
	SOURCE_MANIFEST_APPLICATION [CLASS_PREFIX_REMOVAL_COMMAND]
		redefine
			option_name, argument_list
		end

create
	make

feature {NONE} -- Implementation

	argument_list: EL_ARRAYED_LIST [EL_COMMAND_ARGUMENT]
		do
			Result := Precursor + optional_argument ("prefix", "Class prefix to remove", No_checks)
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH}, "EL")
		end

feature {NONE} -- Constants

	Option_name: STRING = "remove_prefix"

end