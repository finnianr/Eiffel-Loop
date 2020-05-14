note
	description: "Zstring benchmark app"
	notes: "[
		**Usage**
		
			-zstring_benchmark [-logging]
	]"

	author: "Finnian Reilly"
	copyright: "Copyright (c) 2001-2017 Finnian Reilly"
	contact: "finnian at eiffel hyphen loop dot com"

	license: "MIT license (See: en.wikipedia.org/wiki/MIT_License)"
	date: "2020-05-14 13:42:28 GMT (Thursday 14th May 2020)"
	revision: "12"

class
	ZSTRING_BENCHMARK_APP

inherit
	EL_LOGGED_SUB_APPLICATION
		redefine
			standard_options
		end

	SHARED_HEXAGRAM_STRINGS

	EL_SHARED_ZSTRING_CODEC

create
	make

feature {NONE} -- Initialization

	initialize
		do
			log.enter ("initialize")
			call (Hexagram)
			create benchmark_html.make_from_file (Output_path #$ [codec.id])
			log.exit
		end

feature -- Basic operations

	run
			--
		do
			log.enter ("run")
			lio.put_labeled_string ("{ZSTRING}.codec", codec.name)
			lio.put_new_line
			lio.put_integer_field ("Runs per test", Benchmark_option.number_of_runs)
			lio.put_new_line
			lio.put_new_line

			add_benchmarks ([
				create {ZSTRING_BENCHMARK}.make (Benchmark_option),
				create {STRING_32_BENCHMARK}.make (Benchmark_option)
			])
			add_benchmarks ([
				create {MIXED_ENCODING_ZSTRING_BENCHMARK}.make (Benchmark_option),
				create {MIXED_ENCODING_STRING_32_BENCHMARK}.make (Benchmark_option)
			])

			benchmark_html.serialize

			log.exit
		end

feature {NONE} -- Implementation

	add_benchmarks (benchmark: TUPLE [STRING_BENCHMARK, STRING_BENCHMARK])
		do
			benchmark_html.performance_tables.extend (create {PERFORMANCE_BENCHMARK_TABLE}.make (codec.id, benchmark))
			benchmark_html.memory_tables.extend (create {MEMORY_BENCHMARK_TABLE}.make (codec.id, benchmark))
		end

	log_filter: ARRAY [like CLASS_ROUTINES]
			--
		do
			Result := <<
				[{ZSTRING_BENCHMARK_APP}, All_routines],
				[{STRING_32_BENCHMARK}, All_routines],
				[{ZSTRING_BENCHMARK}, All_routines],
				[{MIXED_ENCODING_STRING_32_BENCHMARK}, All_routines],
				[{MIXED_ENCODING_ZSTRING_BENCHMARK}, All_routines]
			>>
		end

	standard_options: EL_DEFAULT_COMMAND_OPTION_LIST
		do
			Result := Precursor + Benchmark_option
		end

feature {NONE} -- Internal attributes

	benchmark_html: BENCHMARK_HTML

feature {NONE} -- Constants

	Benchmark_option: ZSTRING_BENCHMARK_COMMAND_OPTIONS
		once
			create Result.make
		end

	Description: STRING = "Benchmark ZSTRING in relation to STRING_32"

	Output_path: ZSTRING
		once
			Result := "doc/benchmark/ZSTRING-benchmarks-latin-%S.html"
		end

end
