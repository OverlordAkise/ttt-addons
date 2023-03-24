--Luctus Levelsystem (TTT)
--Made by OverlordAkise

--Config start

LUCTUS_XP_WIN = 5
LUCTUS_XP_ROUND = 5
LUCTUS_XP_KILL = 2

--Config end

function levelReqExp(lvl)
    return math.Min(5+(lvl*5),50)
end

local plymeta = FindMetaTable("Player")

function plymeta:GetLevel()
    return self:GetNWInt("level",1)
end

function plymeta:GetXP()
    return self:GetNWInt("xp",0)
end

function plymeta:GetPoints()
    return self:GetNWInt("pts",0)
end

function plymeta:HasLevel(level)
    return self:GetNWInt("level",1) >= level
end

print("[luctus_levels] sh loaded!")
