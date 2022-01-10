note
	description: "Command line interface to command conforming to [$source EL_ML_THUNDERBIRD_ACCOUNT_READER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-01-10 15:31:05 GMT (Monday 10th January 2022)"
	revision: "5"

deferred class
	THUNDERBIRD_ACCOUNT_READER_APP [C -> EL_THUNDERBIRD_ACCOUNT_READER create make_from_file end]

inherit
	EL_COMMAND_LINE_SUB_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				valid_required_argument ("config", "Thunderbird export configuration file", << file_must_exist >>)
			>>
		end

end
