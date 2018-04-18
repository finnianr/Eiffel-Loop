note
	description: "Summary description for {EL_JSON_GENERAL_ESCAPER}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2018-04-08 17:15:55 GMT (Sunday 8th April 2018)"
	revision: "1"

deferred class
	EL_JSON_GENERAL_ESCAPER

inherit
	EL_STRING_GENERAL_ESCAPER
		rename
			make as make_escaper
		end

feature {NONE} -- Initialization

	make
		do
			make_from_table (Escape_table)
		end

feature {NONE} -- Constants

	Escape_table: HASH_TABLE [CHARACTER_32, CHARACTER_32]
		once
			create Result.make (11)
			Result ['%B'] := 'b'
			Result ['%F'] := 'f'
			Result ['%N'] := 'n'
			Result ['%R'] := 'r'
			Result ['%T'] := 't'
			Result ['"'] := '"'
			Result ['\'] := '\'
		end

end
