local lpeg = require "lpeglabel"
local re = require'relabel'

function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local errors = {
    ErrType = "expecting a type",
    ErrId = "expecting an identifier",
    ErrVar = "expecting a variable name",
    ErrNum = "expecting a number",
    ErrExpr = "expecting an expression",
    ErrEnd = "expecting EOF",
    fail = "undefined",
}

local S = lpeg.S(" ")^0
local E = lpeg.S(" ")^1
local EOL = lpeg.S("\r\n")^0

local Number = lpeg.C(lpeg.P"-"^-1 * lpeg.R("09")^1 * (lpeg.P"." * lpeg.R("09")^0)^-1) + lpeg.T"ErrNum"

local Letters = lpeg.R("az") + lpeg.R("AZ")
local Name = lpeg.C(Letters * (Letters + lpeg.R("09"))^0) + lpeg.T"ErrVar"

local Comma = "," * S

local OpenRound = "(" * S
local CloseRound = ")" * S
local OpenSquare = "[" * S
local CloseSquare = "]" * S
local OpenCurly = "{" * S
local CloseCurly = "}" * S

local PowOp = lpeg.C(lpeg.S("^")) * S
local TermOp = lpeg.C(lpeg.S("+-")) * S
local FactorOp = lpeg.C(lpeg.S("*/")) * S

local Exp, Term, Factor, Literal = lpeg.V"Exp", lpeg.V"Term", lpeg.V"Factor", lpeg.V"Literal"
local Expression = lpeg.P { Exp,
    Exp = lpeg.Ct((Term * (TermOp * Term)^0) + (OpenRound * Exp * CloseRound)) + lpeg.T"ErrExpr";
    Term = lpeg.Ct(Factor * (FactorOp * Factor)^0);
    Factor = lpeg.Ct(Literal * (PowOp * Literal)^0);
    Literal = lpeg.Ct(Number + Name);
}

-- Types
local Typ = lpeg.V"Typ"
local Type = lpeg.P { Typ,
    Typ = lpeg.Ct(lpeg.P"bool")
        -- A (ranged) int type
        + lpeg.Ct(lpeg.P"int" * (OpenSquare * Expression * Comma * Expression * CloseSquare)^-1)
        + lpeg.Ct(lpeg.P"real")
        -- A list of some stuff of length "expression"
        + lpeg.Ct(lpeg.P"list" * OpenSquare * Typ * Comma * Expression * CloseSquare)
        -- A reference type
        + lpeg.Ct(lpeg.P"ref" * OpenSquare * Typ * CloseSquare)
        + lpeg.Ct(lpeg.T"ErrType");
}

VariableDeclaration = lpeg.Ct(lpeg.P"const"^-1 * E * Name * lpeg.P":" * E * Type * (S * lpeg.P"=" * S * Expression)^-1)

Comment = lpeg.Ct(lpeg.P"--" * lpeg.P(true))

local Lang, Statement = lpeg.V"Lang", lpeg.V"Statement"
local Language = lpeg.P { Lang,
    Lang = lpeg.Ct((Statement)^1 * lpeg.P(-1) + lpeg.T"ErrEnd");
    Statement = lpeg.Ct(VariableDeclaration + S) * Comment^-1 * EOL;
}

local file = io.open("input.ksc", "rb")
if not file then return nil end
local content = file:read "*a" -- *a or *all reads the whole file
file:close()

function match(grammar, str)
    local result, lab, pos = lpeg.match(grammar, str)

    if not result then
        local line, col = re.calcline(str, pos)
        local msg = "Error at line " .. line .. " (col " .. col .. "): "
        return msg .. errors[lab] .. " before '" .. str:sub(pos) .. "'"
    end
    return dump(result)
end

print(match(Language, content))
