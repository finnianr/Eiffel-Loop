note
	description: "Command line interface to class ${SOURCE_LEADING_SPACE_CLEANER}"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2024-01-20 19:18:27 GMT (Saturday 20th January 2024)"
	revision: "2"

class
	SOURCE_LEADING_SPACE_CLEANER_APP

inherit
	SOURCE_MANIFEST_APPLICATION [SOURCE_LEADING_SPACE_CLEANER]
		redefine
			Option_name
		end

create
	make

feature {NONE} -- Implementation

	default_make: PROCEDURE [like command]
		do
			Result := agent {like command}.make (create {FILE_PATH})
		end

feature {NONE} -- Constants

	Option_name: STRING = "leading_space_cleaner"

end