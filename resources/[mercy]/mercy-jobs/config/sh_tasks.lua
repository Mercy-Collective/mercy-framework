Config.Tasks = {
    ['sanitation'] = {
        Label = 'Los Santos Sanitation',
        Tasks = {
            {
                TaskId = 1,
                Text = 'Go to the foreman',
                Finished = false,
            },
            {
                TaskId = 2,
                Text = 'Get in the sanitation vehicle',
                Finished = false,
            },
            {
                TaskId = 3,
                Text = 'Go to the assigned zone (%s)',
                Finished = false,
            },
            {
                TaskId = 4,
                Text = 'Collect trash',
                ExtraDone = 0,
                ExtraRequired = 15,
                Finished = false,
            },
            {
                TaskId = 5,
                Text = 'Go to the next zone (%s)',
                Finished = false,
            },
            {
                TaskId = 6,
                Text = 'Collect trash',
                ExtraDone = 0,
                ExtraRequired = 15,
                Finished = false,
            },
            {
                TaskId = 7,
                Text = 'Return the vehicle',
                Finished = false,
            },
        }
    },
    ['fishing'] = {
        Label = 'Fishing',
        Tasks = {
            {
                TaskId = 1,
                Text = 'Go to the meetup point',
                Finished = false,
            },
            {
                TaskId = 2,
                Text = 'Go to the fishing spot',
                Finished = false,
            },
            {
                TaskId = 3,
                Text = 'Collect fish',
                ExtraDone = 0,
                ExtraRequired = 30,
                Finished = false,
            },
            {
                TaskId = 4,
                Text = 'Go tell them the spot is good',
                Finished = false,
            },
        }
    },
    ['oxy'] = {
        Label = 'Dark Market Transports',
        Tasks = {
            {
                TaskId = 1,
                Text = 'Find and steal a Bison to use as transport.',
                Finished = false,
            },
            {
                TaskId = 2,
                Text = 'Go to the supplier and ask for the goods.',
                ExtraDone = 0,
                ExtraRequired = 10,
                Finished = false,
            },
            {
                TaskId = 3,
                Text = 'Drive to the handoff location with the transport vehicle.',
                Finished = false,
            },
            {
                TaskId = 4,
                Text = 'Wait for customers and handoff the goods.',
                ExtraDone = 0,
                ExtraRequired = 5,
                Finished = false,
            },
            {
                TaskId = 5,
                Text = 'Drive to the next handoff location.',
                Finished = false,
            },
            {
                TaskId = 6,
                Text = 'Wait for customers and handoff the goods.',
                ExtraDone = 0,
                ExtraRequired = 5,
                Finished = false,
            },
        }
    },
    ['houses'] = {
        Label = 'House Cleaning',
        Tasks = {
            {
                TaskId = 1,
                Text = 'Go to the house location.',
                Finished = false,
            },
            {
                TaskId = 2,
                Text = 'Open the door.',
                Finished = false,
            },
            {
                TaskId = 3,
                Text = 'Clean the house (If you are done cleaning leave the area)',
                Finished = false,
            },
        }
    },
    ['delivery'] = {
        Label = '24/7 Deliveries',
        Tasks = {
            {
                TaskId = 1,
                Text = 'Go to the foreman',
                Finished = false,
            },
            {
                TaskId = 2,
                Text = 'Get in the delivery vehicle',
                Finished = false,
            },
            {
                TaskId = 3,
                Text = 'Go to the assigned store',
                Finished = false,
            },
            {
                TaskId = 4,
                Text = 'Drop off goods',
                ExtraDone = 0,
                ExtraRequired = 3,
                Finished = false,
            },
            {
                TaskId = 5,
                Text = 'Return the vehicle',
                Finished = false,
            },
        }
    },
    ['depot'] = {
        Label = 'Depot Worker',
        Tasks = {
            {
                TaskId = 1,
                Text = 'Get into the flatbed',
                Finished = false,
            },
            {
                TaskId = 2,
                Text = 'Go to the vehicle',
                Finished = false,
            },
            {
                TaskId = 3,
                Text = 'Load up the vehicle',
                Finished = false,
            },
            {
                TaskId = 4,
                Text = 'Go to the depot',
                Finished = false,
            },
            {
                TaskId = 5,
                Text = 'Return the flatbed',
                Finished = false,
            },
        }
    }
}