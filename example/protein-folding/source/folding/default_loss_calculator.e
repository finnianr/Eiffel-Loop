note
	description: "Default loss calculator"

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
	DEFAULT_LOSS_CALCULATOR

inherit
	LOSS_CALCULATOR
		redefine
			find_losses, is_default
		end

create
	make

feature -- Basic operations

	find_losses
		do
		end

feature -- Constants

	is_default: BOOLEAN = True

end
