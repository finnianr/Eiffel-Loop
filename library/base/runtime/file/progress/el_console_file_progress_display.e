note
	description: "Summary description for {EL_CONSOLE_FILE_PROGRESS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-10-12 12:28:22 GMT (Wednesday 12th October 2016)"
	revision: "2"

class
	EL_CONSOLE_FILE_PROGRESS_DISPLAY

inherit
	EL_FILE_PROGRESS_DISPLAY

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make
		do
			create filled_space.make_filled (' ', Space_count)
		end

feature -- Element change

	set_identified_text (id: INTEGER; a_text: ZSTRING)
		do
			lio.put_line (a_text)
		end

feature {NONE} -- Event handling

	on_finish
		do
			set_progress (1.0)
			lio.put_new_line
		end

	on_start (tick_byte_count: INTEGER)
		do
		end

feature -- Basic operations

	set_progress (proportion: DOUBLE)
		local
			count: INTEGER; c: CHARACTER
		do
			count := (Space_count * proportion).rounded
			from until index > count loop
				if index > 0 then
					if index > 1 then
						filled_space.put ('=', index - 1)
					end
					if index = count then
						c := '>'
					else
						c := '='
					end
					filled_space.put (c, index)
				end
				index := index + 1
			end
			lio.put_character ('%R')
			lio.put_substitution (Template, [filled_space, Double.formatted (100 * proportion)])
		end

feature {NONE} -- Implementation

	filled_space: ZSTRING

	index: INTEGER

feature {NONE} -- Constants

	Template: ZSTRING
		once
			Result := "[%S] %S%%"
		end

	Space_count: INTEGER
		once
			Result := 80
		end

	Double: FORMAT_DOUBLE
		once
			create Result.make (5, 1)
		end
end
