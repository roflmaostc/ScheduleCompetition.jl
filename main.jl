using Random

struct Team
    name::String
end

struct Game
    team1::Team
    team2::Team
end


teams = Set([Team("1"), Team("2"), Team("3"), Team("4"), Team("5"), Team("6"), Team("7"), Team("8"), Team("9"), Team("10")])


function pretty_print(slots)
    for slot in sort(collect(keys(slots)))
        print("\nSlot: ", slot)
        for field in sort(collect(keys(slots[slot])))
            if slot == 10 && field == 1
                print("\tField ", field, ":\t")
            else
                print("\t\tField ", field, ":\t")
            end
            print("Team ", slots[slot][field].team1.name)
            print("\tvs\tTeam ", slots[slot][field].team2.name)
        end
    end
end

function pretty_print_csv(slots)
    println("New solution found!")
    for slot in sort(collect(keys(slots)))
        for field in sort(collect(keys(slots[slot])))
            print(slots[slot][field].team1.name,"\t")
            print(slots[slot][field].team2.name, "\t")
        end
        print("\n")
    end
    println("\n\n")
end



function get_slots()
    SLOTS = Dict(
        1 => Dict{Int, Union{Nothing, Game}}(
            1 => nothing, 
            2 => nothing,
            3 => nothing,
        ),
        2 => Dict{Int, Union{Nothing, Game}}(
            1 => nothing, 
            2 => nothing,
        ),
        3 => Dict{Int, Union{Nothing, Game}}(
            1 => nothing, 
            2 => nothing,
            3 => nothing,
        ),
        4 => Dict{Int, Union{Nothing, Game}}(
            1 => nothing, 
            2 => nothing,
        ),
        5 => Dict{Int, Union{Nothing, Game}}(
            1 => nothing, 
            2 => nothing,
        ),
        6 => Dict{Int, Union{Nothing, Game}}(
            1 => nothing, 
            2 => nothing,
            3 => nothing,
        ),
        7 => Dict{Int, Union{Nothing, Game}}(
            1 => nothing, 
            2 => nothing,
        ),
        8 => Dict{Int, Union{Nothing, Game}}(
            1 => nothing, 
            2 => nothing,
            3 => nothing,
        ),
        # sunday morning
         9 => Dict{Int, Union{Nothing, Game}}(
             1 => nothing,
             2 => nothing,
             3 => nothing,
         ),
         10 => Dict{Int, Union{Nothing, Game}}(
             1 => nothing,
             2 => nothing,
         ),
    )
end    


function get_available_teams(teams, slots, slot)
    available_teams = copy(teams)

    for field in keys(slots[slot])
        if slots[slot][field] != nothing
            delete!(available_teams, slots[slot][field].team1)
            delete!(available_teams, slots[slot][field].team2)
        end
    end
    

    # morning or lunch break
    if slot == 1 || slot == 6 || slot == 9
        return available_teams
    end

    for field in keys(slots[slot - 1])
        if slots[slot - 1][field] != nothing
            delete!(available_teams, slots[slot - 1][field].team1)
            delete!(available_teams, slots[slot - 1][field].team2)
        end
    end


    return available_teams
end


function next_slot(slots, slot, field)
    if length(slots[slot]) == field
        return slot + 1, 1
    else
        return slot, field + 1
    end

end


function mymatch(teams, slots, slot, field, games, opponents)
    if slot > 10
        pretty_print_csv(slots)
        return
    end

    available_teams = get_available_teams(teams, slots, slot)
    for team_a in shuffle!(collect(available_teams))
        delete!(available_teams, team_a)
        for team_b in shuffle!(collect(available_teams))
            if team_a in opponents[team_b] || team_b in opponents[team_a] 
                continue 
            end
            
            slots[slot][field] = Game(team_a, team_b)
            games[team_a] += 1
            games[team_b] += 1
            push!(opponents[team_a], team_b)
            push!(opponents[team_b], team_a)
        
            g = getindex.(Ref(games), keys(games))
            if ((any(g .> 4) && slot < 9) ||
                (any(g .> 5)))

                slots[slot][field] = nothing
                games[team_a] -= 1
                games[team_b] -= 1
                delete!(opponents[team_a], team_b)
                delete!(opponents[team_b], team_a)
                    
                continue 
            else
                slot_new, field_new = next_slot(slots, slot, field)
                mymatch(teams, slots, slot_new, field_new, games, opponents)
                games[team_a] -= 1
                games[team_b] -= 1
                delete!(opponents[team_a], team_b)
                delete!(opponents[team_b], team_a)
                slots[slot][field] = nothing
            end
        end
        push!(available_teams, team_a)
    end
    return 
end


function solve()
    Random.seed!(1234)
    games = Dict{Team, Int}(team => 0 for team in teams) 
    opponents = Dict{Team, Set{Team}}(team => Set{Team}() for team in teams)
    mymatch(teams, get_slots(), 1, 1, games, opponents)
end
