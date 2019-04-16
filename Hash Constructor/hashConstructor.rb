=begin

Array of lines with pipe separation

@input = (
'app1|server1|uptime|5',
'app1|server1|loadavg|0.01 0.02 0.03',
'app1|server1|conn1|state|up',
'app1|server2|uptime|10',
'app1|server2|loadavg|0.11 0.22 0.33',
'app1|server2|conn1|state|down',
'app1|running|true',
);

@input = [
"app1|server1|uptime|5",
"app1|server1|loadavg|0.01 0.02 0.03",
"app1|server1|conn1|state|up",
"app1|server2|uptime|10",
"app1|server2|loadavg|0.11 0.22 0.33",
"app1|server2|conn1|state|down",
"app1|running|true"
]

["app1|server1|uptime|5","app1|server1|loadavg|0.01 0.02 0.03","app1|server1|conn1|state|up","app1|server2|uptime|10","app1|server2|loadavg|0.11 0.22 0.33","app1|server2|conn1|state|down","app1|running|true"]

$VAR1 = {
	'app1' => {
		'server2' => {
			'loadavg' => '0.11 0.22 0.33',
			'conn1' => {
				'state' => 'down'
			},
			'uptime' => '10'
		},
		'server1' => {
			'loadavg' => '0.01 0.02 0.03',
			'conn1' => {
				'state' => 'up'
			},
			'uptime' => '5'
		},
	'running' => 'true'
	} 
};
=end

# Method to merge nested hashes with like terms 
class ::Hash
    def deep_merge(second)
        merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
        self.merge(second, &merger)
    end
end

def construct_hash(input)
	# create new hash object
	hashObj = Hash.new
	# iterate across each line in array
	input.each do |line|
		# check for pipe separation
		if line.include?('|')
			# remove new line char if present and split into array
			linearr = line.chomp(",\n").split('|')
			# final array item is our hash value
			value = linearr.pop
			# convert current into hash
			linehash = linearr.reverse.inject(value) { |a, n| { n => a } }

			# merge each concurrent array with our hash object
			hashObj = hashObj.deep_merge(linehash)
		else
			puts "Pipe separation not found. Skipping line."
		end
		
		# puts hashObj
		output = File.open( "output.txt","w" )
		output << hashObj
		output.close
	end
end

# Cmd input
# puts "Enter an array of pipe-separated lines"
# @input = gets

# Variable input 1
# @input = [
# 'app1|server1|uptime|5',
# 'app1|server1|loadavg|0.01 0.02 0.03',
# 'app1|server1|conn1|state|up',
# 'app1|server2|uptime|10',
# 'app1|server2|loadavg|0.11 0.22 0.33',
# 'app1|server2|conn1|state|down',
# 'app1|running|true',
# ]

# Variable input 2 (deeper nesting)
# @input = [
# 'app1|server1|uptime|5',
# 'app1|server1|loadavg|server1|loadavg|server1|loadavg|0.01 0.02 0.03',
# 'app1|server1|conn1|state|up',
# 'app1|server2|uptime|10',
# 'app1|server2|loadavg|0.11 0.22 0.33',
# 'app1|server2|conn1|state|down',
# 'app1|running|true',
# ]

# File input
@input = File::readlines("input.txt")


# Execute nested hash constructor
if @input.kind_of?(Array)
	construct_hash(@input)
else
	puts "Invalid input: Not an array."
end
