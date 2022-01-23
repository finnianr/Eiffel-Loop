note
	description: "Command line interface to command conforming to [$source EL_ML_THUNDERBIRD_ACCOUNT_READER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-23 12:00:25 GMT (Sunday 23rd January 2022)"
	revision: "6"

deferred class
	THUNDERBIRD_ACCOUNT_READER_APP [C -> EL_THUNDERBIRD_ACCOUNT_READER create make_from_file end]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				required_argument ("config", "Thunderbird export configuration file", << file_must_exist >>)
			>>
		end

end