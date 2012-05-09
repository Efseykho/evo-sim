#!/usr/bin/ruby

CHLOROPHYLL_TYPE_A = 1
CHLOROPHYLL_TYPE_B = 2

CHLOROPHYLL_TYPE_BACTERIAL_A = 3
CHLOROPHYLL_TYPE_BACTERIAL_B = 4
CHLOROPHYLL_TYPE_BACTERIAL_C = 5
CHLOROPHYLL_TYPE_BACTERIAL_D = 6

# all datum derived from: http://www.bio.ku.dk/nuf/resources/scitab/chlabs/index.htm
class Chlorophyll
  attr_reader :chl_type, :abs_maxima, :abs
  
  def initialize(chl_type=CHLOROPHYLL_TYPE_A)
     case chl_type
        when CHLOROPHYLL_TYPE_A  
          fname = 'chlorophyll_a.dat'
        when CHLOROPHYLL_TYPE_B  
          fname = 'chlorophyll_b.dat'
        else
          raise ArgumentError, 'Chlorophyll type unknown'
     end
     
     @chl_type = chl_type
     @abs = Hash.new
     
     file = File.open(fname,'r')
     @abs_maxima = file.readline.strip.split(' ')
     @abs_maxima.each_index do |i| @abs_maxima[i] = @abs_maxima[i].to_f end
     
     file.readline
     file.each_line do |line| 
       line = line.strip.split('  ')
       @abs[line[0].to_f] = line[1].to_f
     end
    
     file.close
     
       
  
  end
  
  
end