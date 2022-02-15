note
	description: "Single path operand command i"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-02-15 14:00:13 GMT (Tuesday 15th February 2022)"
	revision: "14"

deferred class
	EL_SINGLE_PATH_OPERAND_COMMAND_I

inherit
	EL_OS_COMMAND_I

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

	Default_path: DIR_PATH
		once
			create Result
		end

end