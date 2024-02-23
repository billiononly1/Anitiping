Cfg = {}
Cfg['Hp'] = {
    ['Use'] = true,     --◄ true = Enables kicking players with higher ping than specified.
    ['limit'] = 100,      --◄ The number of pings required before a player is kicked.
    ['Interval'] = 10,   --◄ Ping monitoring time (in minutes)
    ['KickPeriod'] = 2, --◄ Number of times to check ping before kicking a player (times)
    ['online'] = 1,     --◄ You must be online on the server for 1 minute before the check ping system can start working (in minutes).
    ['Exempt'] = {      --◄ Except for Steam, which needs to check the ping.
        'steam:1234567897878787'
    },
    ['Discord'] = {
        ['Webhook'] ='https://discord.com/api/webhooks/1207824846604472330/80MQocnbPpWmX--pI1OyOeat-caPl8cVUImVeA3PN7lxdUvOddxpaPP-XKPQI4C3Pytv',
    }
}