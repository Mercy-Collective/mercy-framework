Config = {
    Debug = true,
    NotificationDistance = 10.0,
    PropsToRemove = {
        vector3(1992.803, 3047.312, 46.22865),
        vector3(-36.301, 6391.44, 31.6047),
        vector3(550.147, -174.76, 50.6930),
        vector3(-574.17, 288.834, 79.1766),
    },

    --[[
        -- To use custom notifications, implement client event handler, example:

        AddEventHandler('mercy-pool:notification', function(serverId, message)
            print(serverId, message)
        end)
    ]]
    AllowedPoolPlaces = nil, -- {vector3(-574.52, 288.8, 79.17)},

    CustomNotifications = true,

    --[[
        -- To use custom menu, implement following client handlers
        AddEventHandler('mercy-pool:openMenu', function()
            -- open menu with your system
        end)

        AddEventHandler('mercy-pool:closeMenu', function()
            -- close menu, player has walked far from table
        end)


        -- After selecting game type, trigger one of the following setupTable events
        TriggerEvent('mercy-pool:setupTable', 'BALL_SETUP_8_BALL')
        TriggerEvent('mercy-pool:setupTable', 'BALL_SETUP_STRAIGHT_POOL')
    ]]
    CustomMenu = true,

    --[[
        When you want your players to pay to play pool, set this to true
        AND implement the following server handler in your framework of choice.
        The handler MUST deduct money from the player and then CALL the callback
        if the payment is successful, or inform the player of payment failure.

        This script itself DOES NOT implement ESX/vRP logic, you have to do that yourself.

        AddEventHandler('mercy-pool:payForPool', function(playerServerId, cb)
            print("This should be replaced by deducting money from " .. playerServerId)
            cb() -- successfuly set balls on table
        end)
    ]]
    PayForSettingBalls = false,
    BallSetupCost = nil, -- for example: "$1" or "$200" - any text

    --[[
        You can integrate pool cue into your system with

        SERVERSIDE HANDLERS
            - mercy-pool:onReturnCue - called when player takes cue
            - mercy-pool:onTakeCue   - called when player returns cue

        CLIENTSIDE EVENTS
            - mercy-pool:takeCue   - forces player to take cue in hand
            - mercy-pool:removeCue - removes cue from player's hand

        This prevents players from taking cue from cue rack if `false`
    ]]
    
    AllowTakePoolCueFromStand = false,

    --[[
        This option is for servers whose anticheats prevents
        this script from setting players invisible.

        When player's ped is blocking camera when aiming,
        set this to true
    ]]
    DoNotRotateAroundTableWhenAiming = false,

    MenuColor = {245, 127, 23},
    Keys = {
        BACK = {code = 200, label = 'INPUT_FRONTEND_PAUSE_ALTERNATE'},
        ENTER = {code = 38, label = 'INPUT_PICKUP'},
        SETUP_MODIFIER = {code = 21, label = 'INPUT_SPRINT'},
        CUE_HIT = {code = 179, label = 'INPUT_CELLPHONE_EXTRA_OPTION'},
        CUE_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        CUE_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        AIM_SLOWER = {code = 21, label = 'INPUT_SPRINT'},
        BALL_IN_HAND = {code = 29, label = 'INPUT_SPECIAL_ABILITY_SECONDARY'},

        BALL_IN_HAND_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        BALL_IN_HAND_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        BALL_IN_HAND_UP = {code = 172, label = 'INPUT_CELLPHONE_UP'},
        BALL_IN_HAND_DOWN = {code = 173, label = 'INPUT_CELLPHONE_DOWN'},
    },
    Text = {
        BACK = "Terug",
        HIT = "Bal spelen",
        BALL_IN_HAND = "Bal verplaatsen",
        BALL_IN_HAND_BACK = "Bal plaatsen",
        AIM_LEFT = "Beweeg links",
        AIM_RIGHT = "Beweeg rechts",
        AIM_SLOWER = "Verander snelheid",

        POOL = 'Mercy: Poolen',
        POOL_GAME = 'Pool game',
        POOL_SUBMENU = 'Start een nieuw spel',
        TYPE_8_BALL = 'Poolen met 8 ballen',
        TYPE_STRAIGHT = 'Poolen met 15 ballen',

        HINT_SETUP = 'Een nieuw spel starten',
        HINT_TAKE_CUE = 'Pak een keu',
        HINT_RETURN_CUE = 'Zet de keu terug',
        HINT_HINT_TAKE_CUE = 'Om te poolen heb je een keu nodig.',
        HINT_PLAY = 'Spelen',

        BALL_IN_HAND_LEFT = 'Beweeg links',
        BALL_IN_HAND_RIGHT = 'Beweeg rechts',
        BALL_IN_HAND_UP = 'Beweeg boven',
        BALL_IN_HAND_DOWN = 'Beweeg beneden',
        BALL_POCKETED = 'Bal: %s is erin geschoten',
        BALL_IN_HAND_NOTIFY = 'De speler is de bal aan het verplaatsen.',
        BALL_LABELS = {
            [-1] = 'Cue',
            [1] = '~y~Solid 1~s~',
            [2] = '~b~Solid 2~s~',
            [3] = '~r~Solid 3~s~',
            [4] = '~p~Solid 4~s~',
            [5] = '~o~Solid 5~s~',
            [6] = '~g~Solid 6~s~',
            [7] = '~r~Solid 7~s~',
            [8] = 'Black solid 8',
            [9] = '~y~Striped 9~s~',
            [10] = '~b~Striped 10~s~',
            [11] = '~r~Striped 11~s~',
            [12] = '~p~Striped 12~s~',
            [13] = '~o~Striped 13~s~',
            [14] = '~g~Striped 14~s~',
            [15] = '~r~Striped 15~s~',
         }
    },
}