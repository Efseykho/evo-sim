#!/usr/bin/ruby

# predefined bases
BASE_STC = 0
BASE_A   = 1
BASE_B   = 2
BASE_C   = 3
BASE_D   = 4

# complimentary bases
BASE_STC_ = BASE_STC
BASE_A_   = BASE_B
BASE_B_   = BASE_C
BASE_C_   = BASE_D
BASE_D_   = BASE_A

# mutation rates
MUT_RATE__CHANGE    = 0.01
MUT_RATE__DELETE    = 0.01
MUT_RATE__ADD 	    = 0.01
MUT_RATE__DUPLICATE = 0.001

# lookup for values of bases
VAL_LOOKUP_TABLE = [ -1, 1, 3, 5, 10 ]

# lookup for exp of bases
EXP_LOOKUP_TABLE = [ -1, 0.5, 0.0, 1.0, 2.0 ]

# lookup for operation of bases
OPER_LOOKUP_TABLE = [-1, :+, :-, :/, :* ] #/
  
  
class RandomSequence
  attr_accessor :num_rands
  
  def initialize(num_rands = 100)
    @num_rands = num_rands
    @sequence = []
    @rand = Random.new
    
    1.upto(@num_rands){ @sequence.push( @rand.rand(0.0 .. 1.0) ) }
  end
  
  def rand
    1.upto(@num_rands){ @sequence.push( @rand.rand(0.0 .. 1.0) ) } if @sequence.size <= 0

    return @sequence.pop
  end
  
  def range(max=4) #overloaded rand call that takes Range input, BAH!!!
    @rand.rand(0..4)
  end
  
end


class Genome
  attr_accessor :sequence
  
  def initialize(sequence=[],rand=RandomSequence.new)
    @sequence = sequence
    @rand = rand
  end 
             
  def replicate
    #simple replication rules: draw rand for each effect for each base
    repl = @sequence.dup
    repl.each_index{ |i|
                     
      r = @rand.rand
      if r < MUT_RATE__CHANGE
        repl[i] = @rand.range
      end
                   
      r = @rand.rand
      if r < MUT_RATE__DELETE
        repl.delete_at(i)
      end   

      r = @rand.rand
      if r < MUT_RATE__ADD
        repl.insert(i+1,@rand.range)
      end          
                   
      r = @rand.rand
      if r < MUT_RATE__DUPLICATE
        repl.insert(i+1,repl.slice(i+1,repl.size) ).flatten
      end  
    }
    
    return repl if !repl.eql?(@sequence)
    return -1
  end
  
  def eql?(genome)
    return @sequence.eql?(genome.sequence)
  end
  
  def _test_mutate(index_to_mutate,mutation)
    repl = @sequence.dup
    
    case mutation
      when 'CHANGE' then repl[index_to_mutate] = @rand.range
      when 'DELETE' then repl.delete_at(index_to_mutate)
      when 'ADD'    then repl.insert(index_to_mutate+1,@rand.range)
      when 'DUP'    then repl.insert(index_to_mutate+1,repl.slice(index_to_mutate+1,repl.size) ).flatten
    end
    
    return repl
  end
  
  def self.absorbance(sequence)
    abs = []
    val = -1; exp = -1; oper = -1; temp_abs = [];
    
    sequence.each_index { |i|
      if sequence[i] == BASE_STC              
        #clean up first: if last value in 'temp_abs' is a operator, remove it
        temp_abs.push(val) if val != -1  
        temp_abs.pop if temp_abs[-1].is_a?(Symbol)
                                                   
        val = -1; exp = -1; oper = -1;
        next
      end
      
      if val == -1
        val = VAL_LOOKUP_TABLE[sequence[i]]
        next
      end 
                        
      if exp == -1
        exp = EXP_LOOKUP_TABLE[sequence[i]]
        val = val**exp #can calculate intermediate value
                        
        next
      end 
                        
      if oper == -1   
         oper = OPER_LOOKUP_TABLE[sequence[i]]
         temp_abs.push(val)
         temp_abs.push(oper) #push operator, reset all variables
         val = -1; exp = -1; oper = -1;             
        next
      end               
    }
    
    #must process abs again to apply operators to intermediate results 
    while (val=temp_abs.shift)
      if val.is_a?(Symbol)
        t1 = temp_abs.shift
        t2 = abs.shift
        t2 = t2.method(val).call(t1)
        abs.unshift(t2)
      else
        abs.unshift(val)
      end
    end
                    
    return abs
  end
  
  
end

