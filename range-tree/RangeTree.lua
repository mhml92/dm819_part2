local Class = require "middleclass/middleclass"

--local RBTree = require "RBTree/RBTree"
local RangeTree = Class('RangeTree')

function RangeTree:initialize(P)

   -- Set of nd points
   self.P = P


   -- The root of the tree
   self.T = self:BuildNDRangeTree(P,1,true)

end


function RangeTree:FindSplitNode()
end

function RangeTree:BuildNDRangeTree(P,level,sort)
   print(level)
   if sort then
      table.sort(P,
         -- composit number space comparetor
         function(a,b) 
            local l = level 
            while a[l] == b[l] and l < #a do
               l = l + 1
            end
            return a[l] < b[l]
         end
      )
   end
   local v = {}
   if level < #P[1] then
      v.T_assoc = self:BuildNDRangeTree(P,level+1,true)
   end
   if #P == 1 then
      v.value = P[1]
      v.left = nil
      v.right = nil
   else
      local x_mid_i = math.ceil(#P/2)
      local P_left = {}
      local P_right = {}
      for k,point in ipairs(P) do
         if k <= x_mid_i then
            table.insert(P_left,point)
         else
            table.insert(P_right,point)
         end
      end
      v.value = P[x_mid_i]
      v.left = self:BuildNDRangeTree(P_left,level,false)
      v.right = self:BuildNDRangeTree(P_right,level,false)
   end
   return v
end

function RangeTree:NDRangeQuery()
end

-- Composit number space comparetor
function RangeTree:compare(p1,p2,d)
end

return RangeTree
