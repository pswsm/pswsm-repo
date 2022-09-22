<?php namespace pswsm\dna {
define ('ATCG', ['a' => 't', 't' => 'a', 'c' => 'g', 'g' => 'c']);

function base_exists(string $base): bool {
	if (!array_key_exists($base, ATCG)) {
		return false;
	}
	return true;
}

function test() {
	$test_sequence = 'atcga';
	$compl_sequence = [];
	foreach (str_split($test_sequence) as $c) {
		if (base_exists($c)) {
			$compl_sequence[count($compl_sequence)] = ATCG[$c];
		} else {
			printf("Found %s: not a DNA character.\n", $c);
			return;
		}
	}
	$compl_sequence = implode('', $compl_sequence);
	printf("Original sequence is: %s\nFinal sequence is: %s\n", $test_sequence, $compl_sequence);
}
}?>
