note
	description: "Remote call constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-09-23 13:25:21 GMT (Monday 23rd September 2024)"
	revision: "15"

deferred class
	EROS_REMOTE_CALL_CONSTANTS

inherit
	EL_ANY_SHARED

feature {NONE} -- Constants

	Client_classname_suffix: STRING = "_PROXY"

	Event_source: EL_HASH_TABLE [TYPE [EL_PARSE_EVENT_SOURCE], INTEGER]
		once
			create Result.make_assignments (<<
				[Type_binary,		{EL_BINARY_ENCODED_PARSE_EVENT_SOURCE}],
				[Type_plaintext,	{EL_EXPAT_XML_WITH_CTRL_Z_PARSER}]
			>>)
		end

	Event_source_name: EL_HASH_TABLE [STRING, INTEGER]
		once
			Result := << [Type_binary, "binary"], [Type_plaintext, "plaintext"] >>
		end

	Type_binary: INTEGER = 2

	Type_plaintext: INTEGER = 1

end