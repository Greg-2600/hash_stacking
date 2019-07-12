# hash_stacking
Recursively hash some salted data X iterations - returns JSON result

The data to hash can be sent via STDIN or as an argument
Usage:

./hash_stacking.sh data

cat data.file|./hash_stacking.sh


Example output:

{

	"block": "test",
  
	"salt": "982021955",
  
	"algorithms": "SHA: 256",
  
	"iterations": "100",
  
	"hash": "79521b8bd9c36209f304ab005576eca116dafb7fcecfd80241e1aa7d37ee97c6"
}
