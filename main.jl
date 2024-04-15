using Random

struct Team
    name::String
end


struct Game
    team1::Team
    team2::Team
end


teams = Set([Team("1"), Team("2"), Team("3"), Team("4"), Team("5"), Team("6"), Team("7"), Team("8"), Team("9"), Team("10")])



slots = Dict(
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
        3 => nothing,
    ),
    6 => Dict{Int, Union{Nothing, Game}}(
        1 => nothing, 
        2 => nothing,
    ),
    7 => Dict{Int, Union{Nothing, Game}}(
        1 => nothing, 
        2 => nothing,
    ),
    8 => Dict{Int, Union{Nothing, Game}}(
        1 => nothing, 
        2 => nothing,
    ),
    9 => Dict{Int, Union{Nothing, Game}}(
        1 => nothing, 
        2 => nothing,
        3 => nothing,
    ),

)



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


function get_available_teams(teams, slots, slot)
    available_teams = copy(teams)
    
    if slot == 1
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





function match(teams, slots)
    Random.seed!(1) 
    for slot in sort(collect(keys(slots)))
        available_teams = get_available_teams(teams, slots, slot)
        for field in sort(collect(keys(slots[slot])))
            for _ in 1:20
                team_a = rand(available_teams)
                delete!(available_teams, team_a)
                team_b = rand(available_teams)
                delete!(available_teams, team_b)
                slots[slot][field] = Game(team_a, team_b)

                if check_more_than_4_games(teams, slots) == true 
                    push!(available_teams, team_a) 
                    push!(available_teams, team_b)
                    slots[slot][field] = nothing
                    continue 
                else
                    if slot == 9 && field == 3
                        return pretty_print(slots)
                    end
                end
            end
            break
        end
    end
    
end



function pretty_print(slots)
    for slot in sort(collect(keys(slots)))
        print("\nSlot: ", slot)
        for field in sort(collect(keys(slots[slot])))
            print("\t \t Field ", field, ":\t")
            print("", slots[slot][field].team1.name)
            print("\tvs\t", slots[slot][field].team2.name)
        end
    end
end
