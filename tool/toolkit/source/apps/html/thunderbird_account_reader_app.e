note
	description: "Command line interface to command conforming to ${TB_MULTI_LANG_ACCOUNT_READER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-04-02 14:07:57 GMT (Tuesday 2nd April 2024)"
	revision: "13"

deferred class
	THUNDERBIRD_ACCOUNT_READER_APP [C -> TB_ACCOUNT_READER create make_from_file end]

inherit
	EL_COMMAND_LINE_APPLICATION [C]

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := << config_argument ("Thunderbird export configuration file") >>
		end

end