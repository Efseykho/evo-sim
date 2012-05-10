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
       line = line.strip.split(/\s+/)
       @abs[line[0].to_f] = line[1].to_f
     end
    
     file.close
  end
  
  #for now this performs brute-force absorbance search
  #it should really be binary-search
  def find_absorbance(abs_val)
    return 0.0 if @abs.keys[0] > abs_val #lower-bound of absorption
    return 0.0 if abs_val > @abs.keys[-1] #upper-bound of absorption
    
    @abs.keys.each_index do |i|
       #exact match
       return @abs[@abs.keys[i]]  if @abs.keys[i] == abs_val
       
       #weighted average of distance between points
       if @abs.keys[i] < abs_val && @abs.keys[i+1] > abs_val
         
         #point_1 = xi, point_2 = xj, distance = x, d1+d2=x
         #mean_weight = xi*d2/x + x2*d1/x
         distance =  @abs.keys[i+1] - @abs.keys[i]
         ##puts('distance ' +distance.to_s)
         d1 = (abs_val - @abs.keys[i])*1.0/distance
         d2 = (@abs.keys[i+1] - abs_val)*1.0/distance
         ##puts('d1 ' +d1.to_s)
         ##puts('d2 ' +d2.to_s)
         
         return   @abs[@abs.keys[i]]*d2 +   @abs[@abs.keys[i+1]]*d1
       end
    end
    
  end
  
  
end





























