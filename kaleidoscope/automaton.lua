KAutomatonDescription = {}
KAutomatonDescription.mt = {}

KAutomaton = {}
KAutomaton.mt = {}

AutomatonName = 0

-- Instantiates an automaton from a description
function KAutomatonDescription.new(self)
    local automaton = {}
    setmetatable(automaton, KAutomaton.mt)

    automaton.variables = self.variables

    automaton.actions = self.actions

    automaton.initial = self.initial

    automaton.name = string(AutomatonName)
    AutomatonName = AutomatonName + 1

    return automaton
end

-- Creates an automaton description
function automaton(obj)

end

function KAutomaton.to_jani(self)
    local table = {
        
    }
end
