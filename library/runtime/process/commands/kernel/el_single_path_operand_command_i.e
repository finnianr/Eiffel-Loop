note
	description: "Single path operand command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2021-09-09 19:16:33 GMT (Thursday 9th September 2021)"
	revision: "11"

deferred class
	EL_SINGLE_PATH_OPERAND_COMMAND_I

inherit
	EL_OS_COMMAND_I
		redefine
			Transient_fields
		end

feature {NONE} -- Initialization

	make (a_path: like path)
			--
		do
			make_default
			path := a_path
		end

feature -- Access

	path: EL_PATH

feature -- Element change

	set_path (a_path: like path)
			--
		do
			path := a_path
		end

feature {NONE} -- Constants

	Default_path: EL_DIR_PATH
		once
			create Result
		end

	Transient_fields: STRING
		once
			Result := Precursor + ", output_path, template_path"
		end

end