
math.randomseed(12042015)

-- input sizes
N = {
   100,
   125,
   156,
   195,
   243,
   303,
   378,
   472,
   590,
   737,
   921,
   1151,
   1438,
   1797,
   2246,
   2807
}


--N = {100,1000}
-- dimensions
D = {1,2,3,4,5}
-- number of ranges
R = {1000}
-- size of dimensions
S = function(n,d) return n^(1/d) end
-- range sizes
RS = function(s,d) return (0.1*(s^d))^(1/d) end  --((0.1^(1/d))*s)^d 

local currentDir = ""

for di,d in ipairs(D) do
   currentDir = "dimension_"..d
   os.execute("mkdir " .. currentDir)
   for ni,n in ipairs(N) do
      for ri,r in ipairs(R) do
         local s = S(n,d)
         local rs = RS(s,d)
         local fileName = currentDir.."/".."n_"..n.."_d_"..d.."_r_"..r.."_s_"..s.."_rs_"..rs..".txt"
         local command = "luajit createCustomTest.lua -n " ..n .." -d " ..d.." -r "..r.." -s ".. s.." -rs "..rs.." > "..fileName 
         print()
         print("creating file:\t"   .. fileName) 
         print("with command:\t"    .. command)
         os.execute(command)
      end
   end
end
