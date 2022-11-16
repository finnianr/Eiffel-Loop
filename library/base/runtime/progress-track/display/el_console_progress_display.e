note
	description: "Console file progress display"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2022-11-15 19:56:04 GMT (Tuesday 15th November 2022)"
	revision: "12"

class
	EL_CONSOLE_PROGRESS_DISPLAY

inherit
	EL_PROGRESS_DISPLAY

	EL_MODULE_LIO

create
	make

feature {NONE} -- Initialization

	make
		do
			create filled_space.make_filled (' ', Space_count)
		end

feature -- Element change

	set_identified_text (id: INTEGER; a_text: READABLE_STRING_GENERAL)
		do
			lio.put_line (a_text)
		end

feature {NONE} -- Event handling

	on_finish
		do
			set_progress (One)
			lio.put_new_line
			index := 0
			filled_space.wipe_out
			filled_space.fill_character (' ')
		end

	on_start (tick_byte_count: INTEGER)
		do
			set_progress (0)
		end

feature -- Basic operations

	set_progress (a_proportion: DOUBLE)
		local
			count, old_index: INTEGER; c: CHARACTER; proportion: DOUBLE
		do
			proportion := a_proportion.min (a_proportion.one)
			count := (Space_count * proportion).rounded
			old_index := index
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
			if index > old_index or else a_proportion = One then
				lio.put_character ('%R')
				lio.put_substitution (Template, [filled_space, Double.formatted (100 * proportion)])
			end
		end

feature {NONE} -- Implementation

	filled_space: ZSTRING

	index: INTEGER

feature {NONE} -- Constants

	One: DOUBLE
		once
			Result := Result.one
		end

	Template: ZSTRING
		once
			Result := "[%S] %S%%"
		end

	Space_count: INTEGER
		once
			Result := 100
		end

	Double: FORMAT_DOUBLE
		once
			create Result.make (5, 1)
		end
end