note
	description: "Console file progress display"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2022 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2023-12-10 15:22:24 GMT (Sunday 10th December 2023)"
	revision: "14"

class
	EL_CONSOLE_PROGRESS_DISPLAY

inherit
	EL_PROGRESS_DISPLAY

	EL_MODULE_LIO

	EL_SHARED_FORMAT_FACTORY

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
			filled_space.fill_blank
		end

	on_start (tick_byte_count: INTEGER)
		do
			set_progress (0)
		end

feature -- Basic operations

	set_progress (a_proportion: DOUBLE)
		local
			count, old_index: INTEGER; c: CHARACTER; proportion: DOUBLE
			percentile: STRING
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
				percentile := Format.double_as_string (100 * proportion, once "999.9%%|")
				lio.put_substitution (Bar_template, [filled_space, percentile])
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

	Bar_template: ZSTRING
		once
			Result := "[%S] %S"
		end

	Space_count: INTEGER
		once
			Result := 100
		end

end