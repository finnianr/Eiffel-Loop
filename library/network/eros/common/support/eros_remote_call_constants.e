note
	description: "Remote call constants"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-01-19 16:20:12 GMT (Sunday 19th January 2020)"
	revision: "10"

class
	EROS_REMOTE_CALL_CONSTANTS

feature {NONE} -- Constants

	Client_classname_suffix: STRING = "_PROXY"

	Event_source: EL_HASH_TABLE [TYPE [EL_PARSE_EVENT_SOURCE], INTEGER]
		once
			create Result.make (<<
				[Type_binary,		{EL_BINARY_ENCODED_XML_PARSE_EVENT_SOURCE}],
				[Type_plaintext,	{EL_EXPAT_XML_WITH_CTRL_Z_PARSER}]
			>>)
		end

	Event_source_name: EL_HASH_TABLE [STRING, INTEGER]
		once
			create Result.make (<<
				[Type_binary,		"binary"],
				[Type_plaintext,	"plaintext"]
			>>)
		end

	Type_binary: INTEGER = 2

	Type_plaintext: INTEGER = 1

end
