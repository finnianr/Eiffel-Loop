note
	description: "Summary description for {EL_CONSOLE_FILE_PROGRESS}."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2016 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2016-07-11 18:47:53 GMT (Monday 11th July 2016)"
	revision: "5"

class
	EL_CONSOLE_FILE_PROGRESS

inherit
	EL_FILE_PROGRESS_LISTENER
		redefine
			make
		end

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make
		do
			Precursor
			create filled_space.make_filled (' ', Space_count)
		end

feature -- Element change

	set_text (a_text: ZSTRING)
		do
			lio.put_line (a_text)
		end

feature {NONE} -- Event handling

	on_finish
		do
			set_progress (1.0)
			lio.put_new_line
		end

	on_time_estimation (a_seconds: INTEGER)
			-- called when completion time is estimatated
		do
		end

feature -- Basic operations

	set_progress (proportion: DOUBLE)
		local
			count, percentage: INTEGER; c: CHARACTER
		do
			count := (Space_count * proportion).rounded
			percentage := (100 * proportion).rounded
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
			lio.put_substitution (Template, [filled_space, Integer.formatted (percentage)])
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

	Integer: FORMAT_INTEGER
		once
			create Result.make (3)
		end
end
