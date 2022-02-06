note
	description: "[$source PROTEIN_FOLDING_COMMAND] with the computations distributed over multiple cores"
	
	author: "Finnian Reilly"

	copyright: "[
		Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly

		Gerrit Leder, Overather Str. 10, 51429 Bergisch-Gladbach, GERMANY
		gerrit.leder@gmail.com

		Finnian Reilly, Dunboyne, Co Meath, Ireland.
		finnian@eiffel-loop.com
	]"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"

deferred class
	MULTI_CORE_PF_COMMAND [G]

inherit
	PROTEIN_FOLDING_COMMAND
		rename
			make as make_one_core
		redefine
			Description, Iterations_per_dot
		end

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_strseq: like strseq; a_output_path: FILE_PATH; a_max_thread_count: INTEGER)
		do
			max_thread_count := a_max_thread_count
			make_one_core (a_strseq, a_output_path)

			create pool.make (max_thread_count)
		end

feature -- Constants

	Description: STRING = "Test optimised calculation of HP sequences in two-dimensional grid using many threads"

feature {NONE} -- Factory

	new_distributer: EL_PROCEDURE_DISTRIBUTER [like pool.item]
		do
--			if Logging.is_active then
--				create {EL_LOGGED_PROCEDURE_DISTRIBUTER [like new_folder]} Result.make (max_thread_count)
--			else
				create Result.make (max_thread_count)
--			end
		end

feature {NONE} -- Internal attributes

	max_thread_count: INTEGER;

	pool: ARRAYED_STACK [G]

feature {NONE} -- Constants

	Iterations_per_dot: NATURAL_32
		once
			Result := 20
		end
end

