note
	description: "File open routines"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-05 12:40:16 GMT (Tuesday 5th May 2020)"
	revision: "1"

deferred class
	EL_FILE_OPEN_ROUTINES

inherit
	EL_ANY_SHARED

feature {NONE} -- Basic operations

	close
		do
			if Open_stack.count > 0 then
				if not Open_stack.item.is_closed then
					Open_stack.item.close
				end
				Open_stack.remove
			end
		end

	close_all
		do
			from until Open_stack.is_empty loop
				close
			end
		end

	open (path: READABLE_STRING_GENERAL; mode: NATURAL): EL_PLAIN_TEXT_FILE
		do
			create Result.make_with_name (path)
			if mode = Append then
				Result.open_append

			elseif mode = Read and then Result.exists then
				Result.open_read

			elseif mode = Write then
				Result.open_write

			elseif mode = Read | Append then
				Result.open_read_append

			elseif mode = Read | Write then
				Result.open_read_write

			elseif mode = Create_new | Read | Write then
				Result.create_read_write
			else
			end
			Open_stack.put (Result)
		end

feature {NONE} -- Status query

	all_closed: BOOLEAN
		do
			Result := Open_stack.is_empty
		end

feature {NONE} -- Modes

	Append: NATURAL = 1

	Closed: NATURAL = 0

	Create_new: NATURAL = 2

	Read: NATURAL = 4

	Write: NATURAL = 8

feature {NONE} -- Constants

	Open_stack: ARRAYED_STACK [FILE]
		once
			create Result.make (5)
		end

end
