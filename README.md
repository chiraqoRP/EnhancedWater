## Changes
- far fewer entity __index calls
- changed swim hook from [PlayerTick](https://wiki.facepunch.com/gmod/GM:PlayerTick) to [Move](https://wiki.facepunch.com/gmod/GM:Move)
- removed sound.Add usage due to them being slower than paths fed into [ENT:EmitSound](https://wiki.facepunch.com/gmod/Entity:EmitSound)
- bad usage of [table.HasValue](https://wiki.facepunch.com/gmod/table.HasValue) removed from physics callback and [EntityTakeDamage](https://wiki.facepunch.com/gmod/GM:EntityTakeDamage) hook
- fixed accidental global var declarations in effect files

# Credit
Go support [vuthakral](https://steamcommunity.com/id/Vuthakral), his addons are great. <br />
<br />
Original addon: http://steamcommunity.com/profiles/76561198050250649