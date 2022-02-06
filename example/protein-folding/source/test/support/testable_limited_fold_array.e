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
	TESTABLE_LIMITED_FOLD_ARRAY

inherit
	LIMITED_FOLD_ARRAY
		undefine
			make, calc_losses
		end

	TESTABLE_FOLD_ARRAY
		undefine
			is_done
		end

create
	make

end
