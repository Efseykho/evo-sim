#!/usr/bin/ruby

load 'genome.rb'

rand = RandomSequence.new
g = Genome.new([BASE_STC,BASE_A,BASE_STC],rand)

gene_pool = Array.new
gene_pool.push(g)


1.upto(10) do
  gene_pool.each{ |g|
    temp = g.replicate
    p temp
    gene_pool.push(Genome.new(temp,rand)) if temp != -1
  }
  
end