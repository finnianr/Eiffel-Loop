note
	description: "Fold array that updates CRC checksum in `calc_losses'"
	author: "Finnian Reilly"

	copyright: "[
		Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly

		Gerrit Leder, Overather Str. 10, 51429 Bergisch-Gladbach, GERMANY
		gerrit.leder@gmail.com

		Finnian Reilly, Dunboyne, Co Meath, Ireland.
		finnian@eiffel-loop.com
	]"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

class
	TESTABLE_FOLD_ARRAY

inherit
	FOLD_ARRAY
		redefine
			make, calc_losses
		end

create
	make

feature {NONE} -- Initialization

	make (strseq: STRING)
		do
			Precursor (strseq)
			create crc.make
		end

feature -- Access

	checksum: NATURAL
		do
			Result := crc.checksum
		end

feature {NONE} -- Implementation

	calc_losses (pf: PROTEIN_FOLDING_COMMAND_2_0 [GRID_2_X]; iteration_count: NATURAL_32)
		do
			update_crc (crc)
		end

feature {NONE} -- Internal attributes

	crc: EL_CYCLIC_REDUNDANCY_CHECK_32;

end

