note
	description: "Multi-core distributed class parser"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-06-05 16:09:49 GMT (Sunday 5th June 2022)"
	revision: "10"

class
	EIFFEL_CLASS_PARSER

inherit
	EL_DISTRIBUTED_PROCEDURE_CALLBACK

create
	make

feature -- Basic operations

	queue (add_class: PROCEDURE [EIFFEL_CLASS]; source_path: FILE_PATH)
		require
			target_is_ecf: attached {EIFFEL_CONFIGURATION_FILE} add_class.target
		do
			queue_modifier (agent filled_procedure (add_class, source_path))
		end

feature {NONE} -- Separate function

	filled_procedure (add_class: PROCEDURE [EIFFEL_CLASS]; source_path: FILE_PATH): PROCEDURE
		-- create new class and bind to directory in separate thread
		do
			if attached {EIFFEL_CONFIGURATION_FILE} add_class.target as ecf then
				add_class.set_operands ([ecf.new_class (source_path)])
			end
			Result := add_class
		end
end