note
	description: "Path to Eiffel project file derived from desktop launcher file"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-11-02 13:50:51 GMT (Thursday 2nd November 2023)"
	revision: "1"

deferred class
	PROJECT_LAUNCHER_I

feature {NONE} -- Initialization

	make (desktop_path: FILE_PATH)
		deferred
		end

feature -- Status query

	is_valid: BOOLEAN
		do
			Result := not ecf_path.is_empty
		end

feature -- Status query

	ecf_path: FILE_PATH

feature {NONE} -- Constants

	Estudio: STRING = "estudio"
end