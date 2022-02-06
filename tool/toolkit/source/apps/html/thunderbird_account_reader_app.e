note
	description: "Command line interface to command conforming to [$source EL_ML_THUNDERBIRD_ACCOUNT_READER]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-06 17:11:36 GMT (Sunday 6th February 2022)"
	revision: "8"

deferred class
	THUNDERBIRD_ACCOUNT_READER_APP [C -> EL_THUNDERBIRD_ACCOUNT_READER create make_from_file end]

inherit
	EL_COMMAND_LINE_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := << config_argument ("Thunderbird export configuration file") >>
		end

end