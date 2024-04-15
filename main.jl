using Random

struct Team
    name::String
end


struct Game
    team1::Team
    team2::Team
end


teams = Set([Team("1"), Team("2"), Team("3"), Team("4"), Team("5"), Team("6"), Team("7"), Team("8"), Team("9"), Team("10")])


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
        ),
        4 => Dict{Int, Union{Nothing, Game}}(
            1 => nothing, 
            2 => nothing,
        ),
        5 => Dict{Int, Union{Nothing, Game}}(
            1 => nothing, 
            2 => nothing,
            3 => nothing,
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
    
    )
end    


function check_more_than_4_games(teams, slots)
    counter = Dict(team => 0 for team in teams)
    for slot in keys(slots)
        for field in keys(slots[slot])
            if slots[slot][field] != nothing
                counter[slots[slot][field].team1] += 1
                counter[slots[slot][field].team2] += 1

                if counter[slots[slot][field].team1] > 4 || counter[slots[slot][field].team2] > 4
                    return true 
                end
            end
        end
    end
    return false
end


function check_same_game(slots, team_a, team_b)
    for slot in keys(slots)
        for field in keys(slots[slot])
            if slots[slot][field] != nothing
                if (slots[slot][field].team1 == team_a && slots[slot][field].team2 == team_b) || (slots[slot][field].team1 == team_b && slots[slot][field].team2 == team_a)
                    return true
                end
            end
        end
    end
    return false
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
    if slot == 1 || slot == 6
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


function solve()
    Random.seed!(1234)
    mymatch(teams, get_slots(), 1, 1)
end

function mymatch(teams, slots, slot, field)
    if slot > 8 #slot == 8 && field == 3 
        pretty_print(slots)
        return
    end

    available_teams = get_available_teams(teams, slots, slot)
    for team_a in shuffle!(collect(available_teams))
        delete!(available_teams, team_a)
        for team_b in shuffle!(collect(available_teams))
            if check_same_game(slots, team_a, team_b) == true
                continue 
            end
            
            slots[slot][field] = Game(team_a, team_b)

            if check_more_than_4_games(teams, slots) == true
                slots[slot][field] = nothing
                continue 
            else
                slot_new, field_new = next_slot(slots, slot, field)
                mymatch(teams, slots, slot_new, field_new)
                slots[slot][field] = nothing
            end
        end
        push!(available_teams, team_a)
    end
    return 
end


function pretty_print(slots)
    for slot in sort(collect(keys(slots)))
        print("\nSlot: ", slot)
        for field in sort(collect(keys(slots[slot])))
            print("\t \t Field ", field, ":\t")
            print("Team ", slots[slot][field].team1.name)
            print("\tvs\tTeam ", slots[slot][field].team2.name)
        end
    end
end
