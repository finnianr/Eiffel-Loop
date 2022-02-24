note
	description: "[$source PROTEIN_FOLDING_COMMAND] with the computations distributed over multiple cores"

	author: "Finnian Reilly"
	copyright: "Copyright (C) 2016-2017  Gerrit Leder, Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com; gerrit.leder@gmail.com"

	license: "[https://www.gnu.org/licenses/gpl-3.0.en.html GNU General Public License]"
	date: "2022-02-24 18:35:07 GMT (Thursday 24th February 2022)"
	revision: "5"

deferred class
	MULTI_CORE_PF_COMMAND [G]

inherit
	PROTEIN_FOLDING_COMMAND
		rename
			make as make_one_core
		redefine
			Description, Iterations_per_dot
		end

	EL_MODULE_SYSTEM

feature {EL_COMMAND_CLIENT} -- Initialization

	make (a_strseq: like strseq; a_output_path: FILE_PATH; a_cpu_percent: INTEGER)
		do
			cpu_percent := a_cpu_percent
			make_one_core (a_strseq, a_output_path)

			create pool.make (System.scaled_processor_count (a_cpu_percent))
		end

feature -- Constants

	Description: STRING = "Test optimised calculation of HP sequences in two-dimensional grid using many threads"

feature {NONE} -- Factory

	new_distributer: EL_PROCEDURE_DISTRIBUTER [like pool.item]
		do
--			if Logging.is_active then
--				create {EL_LOGGED_PROCEDURE_DISTRIBUTER [like new_folder]} Result.make (cpu_percent)
--			else
				create Result.make (cpu_percent)
--			end
		end

feature {NONE} -- Internal attributes

	cpu_percent: INTEGER

	pool: ARRAYED_STACK [G]

feature {NONE} -- Constants

	Iterations_per_dot: NATURAL_32
		once
			Result := 20
		end
end