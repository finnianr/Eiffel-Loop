note
	description: "Command line interface to commands conforming to [$source PROTEIN_FOLDING_COMMAND]"
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
	PROTEIN_FOLDING_APPLICATION [C -> PROTEIN_FOLDING_COMMAND create make end]

inherit
	EL_LOGGED_COMMAND_LINE_APPLICATION [C]
		rename
			log_filter_set as empty_log_filter_set,
			new_command as new_pf_hp_command
		redefine
			run
		end

	EL_SHARED_CYCLIC_REDUNDANCY_CHECK_32

feature -- Basic operations

	run
		do
			lio.set_timer
			Precursor
			lio.put_new_line
			lio.put_elapsed_time
			lio.put_new_line
		end

feature {NONE} -- Implementation

	argument_specs: ARRAY [EL_COMMAND_ARGUMENT]
		do
			Result := <<
				optional_argument ("sequence", "Input sequence", << ["Length must be >= 3", agent is_valid_sequence] >> ),
				optional_argument ("out", "Output file path", No_checks)
			>>
		end

	default_make: PROCEDURE [like command]
		do
			Result := agent make_default (?, Default_sequence, default_output_path)
		end

	make_default (a_command: like command; a_strseq: STRING_8; a_output_path: FILE_PATH)
		do
			a_command.make (a_strseq, a_output_path)
		end

	is_valid_sequence (sequence: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := sequence.count >= 3
		end

	default_output_path: FILE_PATH
		do
			Result := "workarea/" + option_name.to_string_8
		end

	new_command (sequence: STRING; output_path: FILE_PATH): like command
		do
			create Result.make (sequence, output_path)
		end

feature {NONE} -- Constants

	Default_sequence: STRING = "0010010010010"

end


