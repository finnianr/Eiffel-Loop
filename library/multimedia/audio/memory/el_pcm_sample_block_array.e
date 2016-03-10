note
	description: "Objects that ..."

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2012 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"
	
	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2012-12-16 11:34:28 GMT (Sunday 16th December 2012)"
	revision: "1"

class
	EL_PCM_SAMPLE_BLOCK_ARRAY [G -> NUMERIC]

inherit
	ARRAY [G]
		rename
			make as array_make,
			put as array_put,
			subarray as array_subarray,
			subcopy as array_subcopy,
			lower as array_lower,
			upper as array_upper,
			valid_index as valid_array_index,
			count as array_count,
			conservative_resize as array_conservative_resize,
			item as array_item
		export
			{NONE} all
			{EL_PCM_SAMPLE_BLOCK_ARRAY} array_subcopy, area
		end

create
	make, make_mono_from_array

feature -- Initialization

	make (min_index, max_index, a_num_channels: INTEGER)
			--
		do
			num_channels := a_num_channels
			-- [2, 3] => [2, 2 + (2) * 2 - 1] => [2, 5]
			array_make (min_index, min_index + (max_index - min_index + 1) * num_channels - 1)
			lower := min_index
			upper := max_index
		ensure
			correct_size:  (array_upper - array_lower + 1) = count * num_channels
		end

	make_mono_from_array (mono_sample_array: ARRAY [G])
			--
		do
			num_channels := 1
			make_from_array (mono_sample_array)
			lower := mono_sample_array.lower
			upper := mono_sample_array.upper
		end

feature -- Measurement

	lower: INTEGER
		-- Minimum index

	upper: INTEGER
		-- Maximum index

	count: INTEGER
			-- Number of available indices
		do
			Result := upper - lower + 1
		ensure then
			consistent_with_bounds: Result = upper - lower + 1
		end

feature --Status report

	valid_index (i: INTEGER): BOOLEAN
			-- Is `i' within the bounds of the array?
		do
			Result := (lower <= i) and then (i <= upper)
		end

feature -- Element change

	put (sample_block: ARRAY [G]; i: INTEGER)
			--
		require
			same_number_of_channels: sample_block.count = num_channels
		do
			array_subcopy (sample_block, 1, sample_block.count, (i - 1) * num_channels + 1)
		end

	subarray (start_pos, end_pos: INTEGER): EL_PCM_SAMPLE_BLOCK_ARRAY [G]
			-- Array made of items of current array within
			-- bounds `start_pos' and `end_pos'.
		require
			valid_start_pos: valid_index (start_pos)
			valid_end_pos: end_pos <= upper
			valid_bounds: (start_pos <= end_pos) or (start_pos = end_pos + 1)
		local
			sample_start_pos, sample_end_pos: INTEGER
		do
			sample_start_pos := (start_pos - 1) * num_channels + 1
			sample_end_pos := end_pos * num_channels
			create Result.make (start_pos, end_pos, num_channels)
			if start_pos <= end_pos then
					-- Only copy elements if needed.
				Result.array_subcopy (Current, sample_start_pos, sample_end_pos, sample_start_pos)
			end
		ensure
			lower: Result.lower = start_pos
			upper: Result.upper = end_pos
		end

	subcopy (other: EL_PCM_SAMPLE_BLOCK_ARRAY [G]; start_pos, end_pos, index_pos: INTEGER)
			-- Copy items of `other' within bounds `start_pos' and `end_pos'
			-- to current array starting at index `index_pos'.
		require
			other_not_void: other /= Void
			valid_start_pos: other.valid_index (start_pos)
			valid_end_pos: other.valid_index (end_pos)
			valid_bounds: (start_pos <= end_pos) or (start_pos = end_pos + 1)
			valid_index_pos: valid_index (index_pos)
			enough_space: (upper - index_pos) >= (end_pos - start_pos)
		do
			area.copy_data (
				other.area,
				(start_pos - other.lower) * num_channels,
				(index_pos - lower) * num_channels,
				(end_pos - start_pos + 1) * num_channels
			)
		end

	channel_subcopy (samples: EL_SUBARRAY [G]; channel, start_pos, end_pos, index_pos: INTEGER)
			-- Copy items of `samples' within bounds `start_pos' and `end_pos'
			-- to current array starting at index `index_pos'.
		require
			valid_channel: channel >= 1 and channel <= num_channels
			samples_not_void: samples /= Void
			valid_start_pos: samples.valid_index (start_pos)
			valid_end_pos: samples.valid_index (end_pos)
			valid_bounds: (start_pos <= end_pos) or (start_pos = end_pos + 1)
			valid_index_pos: valid_index (index_pos)
			enough_space: (upper - index_pos) >= (end_pos - start_pos)
		local
			i: INTEGER
		do
			from i := start_pos until i > end_pos loop
				array_put (samples [i], array_lower + (index_pos - lower + i - start_pos) * num_channels + channel - 1)
				i := i + 1
			end
		end

	zero_pad (new_upper: INTEGER)
			--
		require
			bigger: new_upper > upper
		local
			i: INTEGER
			zero_interval: INTEGER_INTERVAL
			number: G
		do
			create zero_interval.make (upper * num_channels + 1, new_upper * num_channels)
			conservative_resize (lower, new_upper)
			from i := zero_interval.lower until i > zero_interval.upper loop
				array_put (number.zero, i)
				i := i + 1
			end
		end

feature -- Resizing

	conservative_resize (min_index, max_index: INTEGER)
			-- Rearrange array so that it can accommodate
			-- indices down to `min_index' and up to `max_index'.
			-- Do not lose any previously entered item.
		require
			good_indices: min_index <= max_index
		local
			new_lower, new_upper: INTEGER
		do
			if empty_area then
				new_lower := min_index
				new_upper := max_index
			else
				new_lower := min_index.min (lower)
				new_upper := max_index.max (upper)
			end
			array_conservative_resize ((min_index - 1) * num_channels + 1, max_index * num_channels)
			lower := new_lower
			upper := new_upper
		ensure
			no_low_lost: lower = min_index or else lower = old lower
			no_high_lost: upper = max_index or else upper = old upper
		end


feature -- Access

	item (index: INTEGER): EL_COLUMN_VECTOR [G]
			--
		local
			i: INTEGER
		do
			create Result.make (num_channels)
			from i := 1 until i > num_channels loop
				Result [i] := array_item (array_lower + (index - lower) * num_channels + i - 1)
				i := i + 1
			end
		end

	num_channels: INTEGER
		-- Number of channel samples in block

	channel_samples (channel: INTEGER): ARRAY [G]
			--
		local
			i: INTEGER
		do
			create Result.make (lower, upper)
			from i := lower until i > upper loop
				Result [i] := array_item (array_lower + (i - lower) * num_channels + channel - 1)
				i := i + 1
			end
		end

end
