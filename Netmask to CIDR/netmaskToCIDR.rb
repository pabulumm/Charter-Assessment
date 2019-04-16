require 'IPAddr'


# extending IPAddr with method to convert IPAddr to CIDR
class ::IPAddr
  def to_cidr
    return self.to_i.to_s(2).count("1")
  end
end

# request IP from cmd line
puts "Enter an IP Address"
ip = gets.chomp("\n")
# check format
if ip.count('.') == 3

	# Unable to determine correct conditions for returning invalid IP Address conversion 

	# convert
	cidr = IPAddr.new(ip).to_cidr

	# output CIDR 
	puts cidr
else
	puts "Invalid IP Address."
end