return function(player, loadCharacter, onCharacterDied)
    if player.Character then
        loadCharacter(player.Character)
    end

    return player.CharacterAdded:Connect(function(character)
        loadCharacter(character)

        if onCharacterDied ~= nil then
            character:WaitForChild("Humanoid").Died:Connect(function()
                onCharacterDied(character)
            end)
        end
    end)
end
