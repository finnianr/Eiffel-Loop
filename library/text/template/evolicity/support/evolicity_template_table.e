note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2013 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2013-07-25 14:40:05 GMT (Thursday 25th July 2013)"
	revision: "2"

class
	EVOLICITY_TEMPLATE_TABLE

inherit
	HASH_TABLE [EVOLICITY_COMPILED_TEMPLATE, EL_FILE_PATH]
		redefine
			default_create
		end

create
	default_create

feature {NONE} -- Initialization

	default_create
			--
		do
			make (19)
			compare_objects
		end

end
