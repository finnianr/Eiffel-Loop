note
	description: "Tl id3 frame code iteration cursor"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2019-11-10 19:05:28 GMT (Sunday 10th November 2019)"
	revision: "1"

class
	TL_ID3_FRAME_CODE_ITERATION_CURSOR

inherit
	ITERATION_CURSOR [NATURAL_8]

	EL_OWNED_CPP_OBJECT
		redefine
			dispose
		end

	TL_ID3_FRAME_LIST_ITERATOR_CPP_API

	STRING_HANDLER

	TL_SHARED_FRAME_CODE

create
	make

feature {NONE} -- Initialization

	make (a_iterator_begin, a_iterator_end: POINTER)
			--
		do
			make_from_pointer (a_iterator_begin)
			iterator_end := a_iterator_end
		end

feature -- Access

	item: NATURAL_8
		local
			code: like Once_code
			area: like Once_code.area; i: INTEGER
		do
			code := Once_code
			area := code.area
			area.fill_with ('%U', 0, 4)
			cpp_copy_frame_id (self_ptr, area.base_address)
			from i := 0 until i = 4 or else area [i] = '%U' loop
				i := i + 1
			end
			code.set_count (i)
			Result := Frame_code.value (code)
		end

feature -- Cursor movement

	forth
		-- Move to next position
		do
			cpp_next (self_ptr)
		end

feature -- Status query

	after: BOOLEAN
			-- Is there no valid position?
		do
			Result := cpp_after (self_ptr, iterator_end)
		end

feature {NONE} -- Implementation

	dispose
			--
		do
			Precursor
			if is_attached (iterator_end) then
				cpp_delete (iterator_end)
				iterator_end := Default_pointer
			end
		end

feature {NONE} -- Internal attributes

	iterator_end: POINTER

feature {NONE} -- Constants

	Once_code: STRING
		once
			create Result.make_filled (' ', 4)
		end

end
