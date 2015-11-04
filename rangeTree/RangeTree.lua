local Class = require "middleclass/middleclass"
local I = require "inspect"
--local RBTree = require "RBTree/RBTree"
local RangeTree = Class('RangeTree')

function RangeTree:initialize(P)
   -- Set of nd points
   self.P = P
   self.result = nil
   -- The root of the tree
   self.T = self:BuildNDRangeTree(P,1,true)
end

function RangeTree:deepcopy(orig)
   local orig_type = type(orig)
   local copy
   if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
         copy[self:deepcopy(orig_key)] = self:deepcopy(orig_value)
      end
      setmetatable(copy, self:deepcopy(getmetatable(orig)))
   else -- number, string, boolean, etc
      copy = orig
   end
   return copy
end


function RangeTree:reportSubtree(node)
   print(I(node))
   if self:isLeaf(node) then
      --if not self.result then self.result = {} end
      table.insert(self.result,node.value)
   else
      self:reportSubtree(node.left)
      self:reportSubtree(node.right)
   end
end

function RangeTree:isLeaf(v)
   if v.left == nil and v.right == nil then
      return true
   else 
      return false
   end
end

function RangeTree:FindSplitNode(node,range,level)
   local x,x_p = range[level].min,range[level].max
   local v = node
   while not self:isLeaf(v) and (x_p <= v.value[level] or x > v.value[level]) do
      if x_p <= v.value[level] then
         v = v.left 
      else
         v = v.right
      end
   end
   return v
end

function RangeTree:findPointsInRange(range)
   self.result = {}
   self:NDRangeQuery(self.T,range,1)
   return self.result
end

function RangeTree:BuildNDRangeTree(PP,level,sort)
   local P = self:deepcopy(PP)
   if sort then
      --print("sort on level: "..level)
      table.sort(P,
      -- composit number space comparetor
      function(a,b) 
         local l = level 
         while a[l] == b[l] and l < #a do
            l = l + 1
         end
         return a[l] < b[l]
      end)
   end

   local v = {}
   if level < #P[1] then
      v.T_assoc = self:BuildNDRangeTree(P,level+1,true)
   else
      v.T_assoc = nil
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

function RangeTree:NDRangeQuery(node,range,level)
   local v_split = self:FindSplitNode(node,range,level)

   if self:isLeaf(v_split) then
      if range[level].min <= v_split.value[level] and v_split.value[level] <= range[level].max then
         if #range == level then
            self:reportSubtree(v_split)
         else
            self:NDRangeQuery(v_split.T_assoc,range,level+1)
         end
      end
   else
      -- LEFT SUBTEE
      local v = v_split.left
      while not self:isLeaf(v) do
         if range[level].min <= v.value[level] then
            if #range == level then
               self:reportSubtree(v.right)
            else
               self:NDRangeQuery(v.right.T_assoc,range,level+1)
            end
            v = v.left
         else
            v = v.right
         end
      end
      -- LEFT SUBTREE LEAF
      if range[level].min <= v.value[level] then
         if #range == level then
            self:reportSubtree(v)
         else
            self:NDRangeQuery(v.T_assoc,range,level+1)
         end
      end
       
      -- RIGHT SUBTEE
      v = v_split.right
      while not self:isLeaf(v) do
         if range[level].max >= v.value[level] then
            if #range == level then
               self:reportSubtree(v.left)
            else
               self:NDRangeQuery(v.left.T_assoc,range,level+1)
            end
            v = v.right
         else
            v = v.left
         end
      end
      -- RIGHT SUBTREE LEAF
      if range[level].max >= v.value[level] then
         if #range == level then
            self:reportSubtree(v)
         else
            self:NDRangeQuery(v.T_assoc,range,level+1)
         end
      end
   end
end

return RangeTree
