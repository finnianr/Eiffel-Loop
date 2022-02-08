note
	description: "[
		An optimized form of fold direction sequences using a sequence of mini-sequences each packed
		into a 64 bit integer. Each mini-sequence contains 18 bit-shifted direction letters of 3 bits each.
		The highest 10 bits contain two 5-bit numbers representing the mini-sequence current item and current count.
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-08 15:50:35 GMT (Tuesday 8th February 2022)"
	revision: "3"

class
	FOLD_SEQUENCE

inherit
	ARRAYED_LIST [NATURAL_64]
		rename
			item as block,
			i_th as i_th_block,
			extend as add_block,
			count as list_count,
			last as last_block,
			first as first_block,
			forth as forth_block,
			put_i_th as put_i_th_block
		export
			{NONE} all
			{FOLD_SEQUENCE} list_count, i_th_block, index
		redefine
			block, start, after, is_empty, make, finish, is_equal
		end

	DIRECTION_ROUTINES
		undefine
			is_equal, copy
		end

create
	make

feature {NONE} -- Initialization

	make (a_n: INTEGER)
		local
			l_n: INTEGER
		do
			l_n := a_n // Block_capacity
			if (a_n \\ Block_capacity) > 0 then
				l_n := l_n + 1
			end
			Precursor (l_n.min (1))
		end

feature -- Access

	item_1: NATURAL_64
		do
			Result := item_pair |>> shift (1)
		end

	item_2: NATURAL_64
		do
			Result := item_pair & Direction_first_mask
		end

	item_pair: NATURAL_64

	i_th (i: INTEGER): NATURAL_64
		require
			valid_index: 1 <= i and i <= count
		local
			l_index, l_block_index, l_block_count, bit_shift_n: INTEGER
			b, items: NATURAL_64
		do
			l_index := i // Block_capacity
			l_block_index := i \\ Block_capacity
			if l_block_index = 0 then
				l_block_index := Block_capacity
			else
				l_index := l_index + 1
			end
			b := area_v2.item (l_index - 1)
			l_block_count := block_count (b)
			items := block_items (b)
			bit_shift_n := shift (l_block_count - l_block_index)
			items := items & (Direction_bits |<< bit_shift_n) -- Mask out other values
			Result := items |>> bit_shift_n
		end

feature -- Measurement

	count: INTEGER
		do
			Result :=  block_count (last_block) + (list_count - 1).max (0) * Block_capacity
		end

feature -- Conversion

	to_string: STRING
		local
			l_index: INTEGER; l_block: NATURAL_64
		do
			if is_empty then
				create Result.make (0)
			else
				l_index := index; l_block := block
				create Result.make (list_count * Block_capacity)
				from start until after loop
					Result.extend (direction_letter (item_1))
					forth
				end
				Result.extend (direction_letter (item_2))
				index := l_index; block := l_block
			end
		end

feature -- Element change

	extend (direction: NATURAL_64)
		-- extend with `direction', do not move cursor
		local
			new_count: INTEGER; b: NATURAL_64
		do
			if is_empty then
				add_block (new_block (0, 1, direction))
			else
				b := last_block
				new_count := block_count (b) + 1
				if new_count <= Block_capacity then
					put_i_th_block (new_block (block_index (b), new_count, extended (block_items (b), direction)), list_count)
				else
					add_block (new_block (0, 1, direction))
				end
			end
		end

	put_i_th (direction: NATURAL_64; i: INTEGER)
		require
			valid_index: 1 <= i and i <= count
		local
			l_index, l_block_index, l_block_count, bit_shift_n: INTEGER
			b, items: NATURAL_64; l_area: like area_v2
		do
			l_area := area_v2
			l_index := i // Block_capacity
			l_block_index := i \\ Block_capacity
			if l_block_index = 0 then
				l_block_index := Block_capacity
			else
				l_index := l_index + 1
			end
			b := l_area.item (l_index - 1)
			l_block_count := block_count (b)
			items := block_items (b)
			bit_shift_n := shift (l_block_count - l_block_index)
			items := items & (Direction_bits |<< bit_shift_n).bit_not -- Mask out current value
			items := items | (direction |<< bit_shift_n) -- insert new value
			l_area.put (new_block (0, l_block_count, items), l_index - 1)
		ensure
			direction_set: i_th (i) = direction
		end

feature -- Cursor movement

	finish
			-- Move cursor to last position if any.
		local
			b, items, last_item, first_item: NATURAL_64; l_count, i: INTEGER
		do
			i := list_count
			index := i
			if i > 0 then
				b := area_v2.item (i - 1)
				l_count := block_count (b)
				items := block_items (b)
				if l_count = 1 and then i > 1 then
					-- straddling two blocks, so combine last and first items
					last_item := items
					block := new_block (1, l_count, items)
					b := i_th_block (i - 1)
					first_item := block_items (b) |>> shift (block_count (b) - 1)
					item_pair := first_item |<< shift (1) | last_item

				elseif l_count > 1 then
					set_item_pair (items, l_count - 1, l_count)
					block := new_block (l_count - 1, l_count, items)
				else
					block := b
				end
			end
		end

	forth
			-- Move cursor one position forward.
		local
			b, items, last_item, first_item: NATURAL_64
			l_count, new_index: INTEGER
		do
			b := block
			l_count := block_count (b)
			new_index := block_index (b) + 1
			items := block_items (b)
			if new_index + 1 <= l_count then
				block := new_block (new_index, l_count, items)
				set_item_pair (items, new_index, l_count)

			elseif new_index = l_count then
				if new_index = Block_capacity then
					-- straddling two blocks, so combine last and first items
					if index < list_count then
						last_item := items & Direction_first_mask
						block := new_block (new_index, l_count, items)
						b := i_th_block (index + 1)
						first_item := block_items (b) |>> shift (block_count (b) - 1)
						item_pair := last_item |<< shift (1) | first_item
					else
						after := True
					end
				else
					after := True
				end
			elseif new_index > l_count then
				if index < list_count then
					index := index + 1
					block := area_v2.item (index - 1)
					b := block
					l_count := block_count (b)
					if l_count > 0 then
						items := block_items (b)
						block := new_block (1, l_count, items)
						set_item_pair (items, 1, l_count)
					else
						after := True
					end
				else
					after := True
				end
			else
				after := True
			end
		end

	start
			-- Move cursor to first position if any.
		local
			b, items: NATURAL_64; l_count: INTEGER
		do
			if list_count = 0 then
				after := True
			else
				index := 1
				block := area_v2.item (0)
				b := block
				l_count := block_count (b)
				if l_count = 0 then
					after := True
				else
					items := block_items (b)
					set_item_pair (items, 1, l_count)
					block := new_block (1, l_count, items)
					after := False
				end
			end
		end

feature -- Status query

	after: BOOLEAN

	is_empty: BOOLEAN
		do
			Result := Precursor or else block_count (first_block) = 0
		end

feature -- Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is array made of the same items as `other'?
		local
			i: INTEGER
		do
			if other = Current then
				Result := True
			elseif list_count = other.list_count then
				from
					Result := True
					i := lower
				until
					not Result or i > upper
				loop
					Result := i_th_block (i) & Block_index_mask = other.i_th_block (i) & Block_index_mask
					i := i + 1
				end
			end
		end

feature {NONE} -- Implementation

	block_count (a_block: NATURAL_64): INTEGER
		--
		do
			Result := (block_info (a_block) & Index_mask).to_integer_32
		end

	block_index (a_block: NATURAL_64): INTEGER
		--
		do
			Result := (block_info (a_block) |>> Info_bit_count).to_integer_32
		end

	block_info (a_block: NATURAL_64): NATURAL_64
		-- return 10 bits of info at high end of block
		do
			Result := a_block |>> shift (Block_capacity)
		end

	block_items (a_block: NATURAL_64): NATURAL_64
		do
			Result := a_block & Block_info_mask
		end

	extended (items: NATURAL_64; direction: NATURAL_64): NATURAL_64
		-- block items extended by `direction'
		do
			Result := items |<< shift (1) | direction
		end

	new_block (a_index, a_count: INTEGER; items: NATURAL_64): NATURAL_64
		local
			info: INTEGER
		do
			info := a_index |<< Info_bit_count | a_count
			Result := info.to_natural_64 |<< shift (Block_capacity) | items
		ensure
			has_index: block_index (Result) = a_index
			has_count: block_count (Result) = a_count
			has_items: block_items (Result) = items
		end

	set_item_pair (items: NATURAL_64; i, a_count: INTEGER)
		do
			item_pair := (items |>> shift (a_count - i - 1)) & Direction_mask
		end

	shift (item_count: INTEGER): INTEGER
		do
			Result := item_count * Item_bit_count
		end

feature {NONE} -- Internal attributes

	block: NATURAL_64

feature {NONE} -- Constants

	Block_capacity: INTEGER = 18

	Block_index_mask: NATURAL_64 = 0x7FF_FFFF_FFFF_FFFF
		-- masks out top 5 bits

	Block_info_mask: NATURAL_64 = 0x3F_FFFF_FFFF_FFFF
		-- mask out 10 highest bits

	Direction_bits: NATURAL_64 = 0x7

	Index_mask: NATURAL_64 = 0x1F
		-- masks out everything except lowest 5 bits

	Info_bit_count: INTEGER = 5
		-- number of bits to store block information count or index

	Item_bit_count: INTEGER = 3;
		-- count of bits to store 1 direction item

end