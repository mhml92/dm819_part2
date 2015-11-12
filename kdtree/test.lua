local kd = require("kdtree/kdtree")

--local list = {{1,1},{9,9},{3,3},{4,4},{5,5},{6,6},{7,7},{8,8},{2,2},{10,10}} 

--local tree = kd.BUILDKDTREE(list,0,2)

--local R = {{1,1},{10,10}}



--print(I(kd.INITKDSEARCH(tree, R)))--, kd.naiveMaxMinRegion(list))))

if #arg > 0 then

   local performanceTest = false
   local inputfile = ""
   for k,v in ipairs(arg) do
      if v == "-R" then
         performanceTest = true
      else
         inputfile = v
      end
   end
   
      print("TEST")

   P = {}
   R = {}
   -- read input
   for l in io.lines(inputfile) do
      if string.match(l, ":") then
         local r = {}
         for elem in string.gmatch(l,"[^\t]*") do
            if elem ~= "" then
               local tmp ={}
               for part in string.gmatch(elem,"[^:]*") do
                  if part ~= "" then
                     table.insert(tmp,part)
                  end
               end
               table.insert(r,{tonumber(tmp[1]),tonumber(tmp[2])})
            end
         end
         table.insert(R,r)
      else
         local point = {}
         for elem in string.gmatch(l,"[^\t]*") do
            if elem ~= "" then
               table.insert(point,tonumber(elem))
            end
         end
		if #point ~= 0 then
			table.insert(P,point)
		end
      end
   end

   if performanceTest then
      
      local measures = {}
      measures.n = #P
      measures.build_t1 = os.clock()
      local kdt = kd.BUILDKDTREE(P, 0, #P[1])
      measures.build_t2 = os.clock()
      measures.querys = {}
      for k,r in ipairs(R) do
        measures.querys[k] = {}
        local q = measures.querys[k]
        q.t1 = os.clock()
        local res = kd.INITKDSEARCH(kdt, r)
        q.t2 = os.clock()
        q.outSize = #res
      end
      print("alg\tn\toutputSize\tbuildTime\tsearchTime") 
      for k,v in ipairs(measures.querys) do
         print("kdTree\t"..measures.n.."\t"..v.outSize.."\t"..measures.build_t2-measures.build_t1.."\t"..v.t2-v.t1)
      end
   else
      local kdt = kd.BUILDKDTREE(P, 0, #P[1])
      local res = {}
      for k,r in ipairs(R) do
        table.insert(res,kd.INITKDSEARCH(kdt, r))
      end
      for k,v in ipairs(res) do
         for k1,v1 in ipairs(v) do
            local strPoint = ""
            for k2,v2 in ipairs(v1) do
               strPoint = strPoint .. v2 .. "\t" 
            end
            print(strPoint)
         end
         print()
      end
   end
end



