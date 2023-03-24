

local function GetTraitorCount(ply_count)
    local traitor_count = math.floor(ply_count * GetConVar("ttt_traitor_pct"):GetFloat())
    traitor_count = math.Clamp(traitor_count, 1, GetConVar("ttt_traitor_max"):GetInt())
    return traitor_count
end


local function GetDetectiveCount(ply_count)
    if ply_count < GetConVar("ttt_detective_min_players"):GetInt() then return 0 end
    local det_count = math.floor(ply_count * GetConVar("ttt_detective_pct"):GetFloat())
    det_count = math.Clamp(det_count, 1, GetConVar("ttt_detective_max"):GetInt())
    return det_count
end

function SelectRolesLuctus()
   local choices = {}
   local prev_roles = {
      [ROLE_INNOCENT] = {},
      [ROLE_TRAITOR] = {},
      [ROLE_DETECTIVE] = {}
   }
   
   local tpassplys = {}
   local dpassplys = {}

   if not GAMEMODE.LastRole then GAMEMODE.LastRole = {} end

   local plys = player.GetAll()

   for k,v in ipairs(plys) do
      -- everyone on the spec team is in specmode
      if IsValid(v) and (not v:IsSpec()) then
         -- save previous role and sign up as possible traitor/detective

         local r = GAMEMODE.LastRole[v:SteamID()] or v:GetRole() or ROLE_INNOCENT

         table.insert(prev_roles[r], v)

         table.insert(choices, v)
         
         if v.tpass then
            table.insert(tpassplys,v)
         end
         if v.dpass then
            table.insert(dpassplys,v)
         end
      end

      v:SetRole(ROLE_INNOCENT)
   end

   -- determine how many of each role we want
   local choice_count = #choices
   local traitor_count = GetTraitorCount(choice_count)
   local det_count = GetDetectiveCount(choice_count)

   if choice_count == 0 then return end

   -- first select traitors
   local ts = 0
   while (ts < traitor_count) and (#choices >= 1) do
      local pick = math.random(1, #choices)
      local pply = choices[pick]
      --print("[DEBUG]","Current T pick:",pply)
      local passply = not table.IsEmpty(tpassplys) and tpassplys[1] or nil
      if IsValid(passply) then
         --print("[DEBUG]","Pass T pick instead:",passply)
         passply:SetRole(ROLE_TRAITOR)
         LuctusNotify(passply,"Your Traitor-Pass was used!")
         passply.tpass = nil
         table.remove(tpassplys,1)
         table.RemoveByValue(choices,passply)
         ts = ts + 1
         continue
      end

      -- make this guy traitor if he was not a traitor last time, or if he makes
      -- a roll
      if IsValid(pply) and
         ((not table.HasValue(prev_roles[ROLE_TRAITOR], pply)) or (math.random(1, 3) == 2)) then
         pply:SetRole(ROLE_TRAITOR)

         table.remove(choices, pick)
         ts = ts + 1
      end
   end

   -- now select detectives, explicitly choosing from players who did not get
   -- traitor, so becoming detective does not mean you lost a chance to be
   -- traitor
   local ds = 0
   local min_karma = GetConVarNumber("ttt_detective_karma_min") or 0
   while (ds < det_count) and (#choices >= 1) do

      -- sometimes we need all remaining choices to be detective to fill the
      -- roles up, this happens more often with a lot of detective-deniers
      if #choices <= (det_count - ds) then
         for k, pply in ipairs(choices) do
            if IsValid(pply) then
               pply:SetRole(ROLE_DETECTIVE)
            end
         end

         break -- out of while
      end


      local pick = math.random(1, #choices)
      local pply = choices[pick]
      
      local passply = not table.IsEmpty(dpassplys) and dpassplys[1] or nil
      if IsValid(passply) then
         passply:SetRole(ROLE_DETECTIVE)
         LuctusNotify(passply,"Your Detective-Pass was used!")
         passply.dpass = nil
         table.remove(dpassplys,1)
         table.RemoveByValue(choices,passply)
         ds = ds + 1
         continue
      end

      -- we are less likely to be a detective unless we were innocent last round
      if (IsValid(pply) and
          ((pply:GetBaseKarma() > min_karma and
           table.HasValue(prev_roles[ROLE_INNOCENT], pply)) or
           math.random(1,3) == 2)) then

         -- if a player has specified he does not want to be detective, we skip
         -- him here (he might still get it if we don't have enough
         -- alternatives)
         if not pply:GetAvoidDetective() then
            pply:SetRole(ROLE_DETECTIVE)
            ds = ds + 1
         end

         table.remove(choices, pick)
      end
   end

   GAMEMODE.LastRole = {}

   for _, ply in ipairs(plys) do
      -- initialize credit count for everyone based on their role
      ply:SetDefaultCredits()

      -- store a steamid -> role map
      GAMEMODE.LastRole[ply:SteamID()] = ply:GetRole()
   end
end

hook.Add("InitPostEntity","luctus_rolepass_overwrite",function()
	SelectRoles = SelectRolesLuctus
    print("[luctus_rolepass] Overwrite done!")
end)

print("[luctus_rolepass] sv loaded!")
