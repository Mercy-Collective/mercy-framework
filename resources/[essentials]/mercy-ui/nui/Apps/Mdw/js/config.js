var Config = {
    RandomMessages: [
        { Text: 'The IT Guy is actually the best thing to ever happen to this department.', Author: 'Chief of Police' },
        { Text: '...a back button, you know. Like on Google Chrome, when you press it to go backwards.', Author: 'Chief of Police' },
    ],
    ProfileTags: {
        0: {Text: 'Gang Related', Color: '#c93e3e'},
        1: {Text: 'Gang 1', Color: '#53c93e'},
        2: {Text: 'Gang 2', Color: '#326fa8'},
        3: {Text: 'Gang 3', Color: '#b93ec9'},
        4: {Text: 'DOJ (Department of Justice)', Color: '#6d32a8'},
        5: {Text: 'BCSO (Blaine County Sheriff\'s Office)', Color: '#a88332'},
        6: {Text: 'LSPD (Los Santos Police Department)', Color: '#326fa8'},
        7: {Text: 'Government', Color: '#3242a8'},
        8: {Text: 'Terrorist', Color: '#c22929'},
        9: {Text: 'Deceased', Color: '#781919'},
        10: {Text: 'DNA On File', Color: '#77e362'},
        11: {Text: 'Weapon License Removed', Color: '#c93e3e'}
    },
    StaffTags: {
        0: {Text: 'Air-1 Certification', Color: '#53c93e'}, 
        1: {Text: 'Interceptor Certification', Color: '#3ec9c9'},
        2: {Text: 'FTO Certification', Color: '#326fa8'},
        3: {Text: 'FTI Certification', Color: '#326fa8'},
        4: {Text: 'Motorcycle Certification', Color: '#c93e3e'},
        5: {Text: 'TI Certification', Color: '#f5c242'},
    },
    Reports: {
        Categories: [ "Investigative Reports", "Incident Report" ],
        Tags: {
            0: {Text: 'Gang Related', Color: '#c93e3e'},
            1: {Text: 'Gang 1', Color: '#53c93e'},
            2: {Text: 'Gang 2', Color: '#326fa8'},
            3: {Text: 'Gang 3', Color: '#b93ec9'},
            4: {Text: 'Terrorism', Color: '#c22929'},
            4: {Text: 'Firearm Sales', Color: '#c22929'},
            5: {Text: 'Illegal Substance Sales', Color: '#c22929'},
            6: {Text: 'Fraud', Color: 'white'},
            7: {Text: 'Theft', Color: 'white'},
        },
        DefaultText: '<p><strong>[department] Report</strong><br><br>[timestamp]<br><br><strong>Reporting Officer</strong><br><br>[reporting_officer]<br><br><strong>Assisting Officer/s:</strong><br><br><strong>Suspect/s:</strong><br><br><strong>Victim/s:</strong><br><br><strong>Witnesses:</strong><br><br><strong>Location:</strong><br><br><strong>Debrief:</strong><br><br><strong>Use of force:</strong>                    </p>'
    },
    Evidence: {
        Types: {
            "Other": {
                Color: "#ffffff",
            },
            "Blood": {
                Color: "#ed5a5a",
            },
            "Casing": {
                Color: "#f8fc72",
            },
            "Weapon": {
                Color: "#8680ff",
            },
            "Photo": {
                Color: "#6bcf4a",
            },
        }
    },
    Fines: {
        0: {
            Title: "Offenses Against Persons",
            Fines: {
                0: {Price: 825, Months: 11, Points: 0, Name: 'Assault & Battery', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 825, Months: 11, Points: 0, Name: 'As accomplice'}}},
                1: {Price: 1050, Months: 14, Points: 0, Name: 'Criminal Threats', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 1050, Months: 14, Points: 0, Name: 'As accomplice'}}},
                2: {Price: 525, Months: 7, Points: 0, Name: 'Brandishing of a Firearm', Type: 'mdw-charges-block-charge-normal', Extra: null},
                3: {Price: 825, Months: 11, Points: 0, Name: 'Unlawful Imprisonment', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 825, Months: 11, Points: 0, Name: 'As accomplice'}}},
                4: {Price: 1050, Months: 14, Points: 0, Name: 'Kidnapping', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1050, Months: 14, Points: 0, Name: 'As accomplice'}}},
                5: {Price: 1875, Months: 25, Points: 0, Name: 'Kidnapping a Gov Employee', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1875, Months: 25, Points: 0, Name: 'As accomplice'}}},
                6: {Price: 1575, Months: 21, Points: 0, Name: 'Assault with a Deadly Weapon', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1575, Months: 21, Points: 0, Name: 'As accomplice'}}},
                7: {Price: 11250, Months: 150, Points: 0, Name: 'Manslaugther', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 11250, Months: 150, Points: 0, Name: 'As accomplice'}}},
                8: {Price: 1875, Months: 25, Points: 0, Name: 'Attempted 2nd Degree Murder', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1875, Months: 25, Points: 0, Name: 'As accomplice'}}},
                9: {Price: 22500, Months: 300, Points: 0, Name: '2nd Degree Murder', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 22500, Months: 300, Points: 0, Name: 'As accomplice'}}},
                10: {Price: 2625, Months: 35, Points: 0, Name: 'Attempted 1st Degree Murder', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 2625, Months: 35, Points: 0, Name: 'As accomplice'}}},
                11: {Price: 3375, Months: 45, Points: 0, Name: 'Attepted Murder of a Gov Employee', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 3375, Months: 45, Points: 0, Name: 'As accomplice'}}},
                12: {Price: 500, Months: 75, Points: 0, Name: 'Gang Related Shooting', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 500, Months: 75, Points: 0, Name: 'As accomplice'}}},
                13: {Price: 825, Months: 11, Points: 0, Name: 'Reckless Endagerment', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 825, Months: 11, Points: 0, Name: 'As accomplice'}}},
                14: {Price: 0, Months: 0, Points: 0, Name: '1st Degree Murder', Type: 'mdw-charges-block-charge-extreme', Extra: {0: {Price: 0, Months: 0, Points: 0, Name: 'As accomplice'}}},
                15: {Price: 0, Months: 0, Points: 0, Name: 'Murder of a Gov Employee', Type: 'mdw-charges-block-charge-extreme', Extra: {0: {Price: 0, Months: 0, Points: 0, Name: 'As accomplice'}}},
                16: {Price: 0, Months: 0, Points: 0, Name: 'Serial Assaults and Killings', Type: 'mdw-charges-block-charge-extreme', Extra: {0: {Price: 0, Months: 0, Points: 0, Name: 'As accomplice'}}},
            }
        },
        1: {
            Title: "Offenses Involving Theft",
            Fines: {
                0: {Price: 250, Months: 0, Points: 0, Name: 'Petty Theft', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 250, Months: 0, Points: 0, Name: 'As accomplice'}}},
                1: {Price: 375, Months: 5, Points: 0, Name: 'Grand Theft', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 375, Months: 5, Points: 0, Name: 'As accomplice'}}},
                2: {Price: 525, Months: 7, Points: 0, Name: 'Joyriding', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                3: {Price: 525, Months: 7, Points: 0, Name: 'Tampering with a Vehicle', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                4: {Price: 525, Months: 7, Points: 0, Name: 'Possession of Stolen property in the 3rd Degree', Type: 'mdw-charges-block-charge-normal', Extra: null},
                5: {Price: 900, Months: 12, Points: 0, Name: 'Possession of Stolen property in the 2nd Degree', Type: 'mdw-charges-block-charge-normal', Extra: null},
                6: {Price: 900, Months: 12, Points: 0, Name: 'Possession of a Stolen Identification', Type: 'mdw-charges-block-charge-normal', Extra: null},
                7: {Price: 900, Months: 12, Points: 0, Name: 'Possession of Dirty Money in the 2nd Degree', Type: 'mdw-charges-block-charge-normal', Extra: null},
                8: {Price: 900, Months: 12, Points: 0, Name: 'Leave Without Paying', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 900, Months: 12, Points: 0, Name: 'As accomplice'}}},
                9: {Price: 1650, Months: 22, Points: 0, Name: 'Sale of Stolen Goods or Stolen Property', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 1650, Months: 22, Points: 0, Name: 'As accomplice'}}},
                10: {Price: 1050, Months: 14, Points: 0, Name: 'Grand Theft Auto', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1050, Months: 14, Points: 0, Name: 'As accomplice'}}},
                11: {Price: 1050, Months: 14, Points: 0, Name: 'Possession of Stolen property in the 1st Degree', Type: 'mdw-charges-block-charge-major', Extra: null},
                12: {Price: 1875, Months: 25, Points: 0, Name: 'Robbery', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1875, Months: 25, Points: 0, Name: 'As accomplice'}}},
                13: {Price: 2250, Months: 30, Points: 0, Name: '1st Degree Robbery', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 2250, Months: 30, Points: 0, Name: 'As accomplice'}}},
                14: {Price: 1050, Months: 14, Points: 0, Name: '1st Degree Robbery', Type: 'mdw-charges-block-charge-major', Extra: null},
                15: {Price: 2750, Months: 33, Points: 0, Name: 'Grand Larceny', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 270, Months: 33, Points: 0, Name: 'As accomplice'}}},
                16: {Price: 1575, Months: 21, Points: 0, Name: 'Possession of Dirty Money in the 1st Degree', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1575, Months: 21, Points: 0, Name: 'As accomplice'}}},
                17: {Price: 1425, Months: 19, Points: 0, Name: 'Theft of an Aircraft', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1425, Months: 19, Points: 0, Name: 'As accomplice'}}},
                18: {Price: 1725, Months: 23, Points: 0, Name: 'Theft of an Commercial Aircraft', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1725, Months: 23, Points: 0, Name: 'As accomplice'}}},
                19: {Price: 6200, Months: 60, Points: 0, Name: 'Robbery of a Financial Institution', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1725, Months: 23, Points: 0, Name: 'As accomplice'}}},
            }
        },
        2: {
            Title: "Offenses Involving Fraud",
            Fines: {
                0: {Price: 0, Months: 0, Points: 0, Name: 'Possession of Band of Notes or Small Band of Notes', Type: 'mdw-charges-block-charge-normal', Extra: null},
                1: {Price: 0, Months: 0, Points: 0, Name: 'Misdemeanor Tax Evasion - JUDICIAL DISCRETION', Type: 'mdw-charges-block-charge-normal', Extra: null},
                2: {Price: 1050, Months: 14, Points: 0, Name: 'Extortion', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1050, Months: 14, Points: 0, Name: 'As accomplice'}}},
                3: {Price: 1050, Months: 14, Points: 0, Name: 'Fraud', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1050, Months: 14, Points: 0, Name: 'As accomplice'}}},
                4: {Price: 1050, Months: 14, Points: 0, Name: 'Impersonating', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1050, Months: 14, Points: 0, Name: 'As accomplice'}}},
                5: {Price: 1575, Months: 21, Points: 0, Name: 'Impersonating a Peace Officer', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1575, Months: 21, Points: 0, Name: 'As accomplice'}}},
                6: {Price: 1575, Months: 21, Points: 0, Name: 'Impersonating a Judge', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1575, Months: 21, Points: 0, Name: 'As accomplice'}}},
                7: {Price: 1575, Months: 21, Points: 0, Name: 'Identity Theft', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1575, Months: 21, Points: 0, Name: 'As accomplice'}}},
                8: {Price: 1575, Months: 21, Points: 0, Name: 'Vehicle Registration Fraud', Type: 'mdw-charges-block-charge-major', Extra: null},
                9: {Price: 1575, Months: 21, Points: 0, Name: 'Impersonating EMS', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1575, Months: 21, Points: 0, Name: 'As accomplice'}}},
                10: {Price: 2250, Months: 30, Points: 0, Name: 'Money Laundering', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 2250, Months: 30, Points: 0, Name: 'As accomplice'}}},
                11: {Price: 0, Months: 0, Points: 0, Name: 'Felony Tax Evasion - Asset Freeze Pending Trial', Type: 'mdw-charges-block-charge-major', Extra: null},
                12: {Price: 0, Months: 0, Points: 0, Name: 'Witness Tampering', Type: 'mdw-charges-block-charge-extreme', Extra: {0: {Price: 0, Months: 0, Points: 0, Name: 'As accomplice'}}},
            }
        },
        3: {
            Title: "Offenses Involving Damage to Property",
            Fines: {
                0: {Price: 375, Months: 5, Points: 0, Name: 'Trespassing', Type: 'mdw-charges-block-charge-normal', Extra:  {0: {Price: 375, Months: 5, Points: 0, Name: 'As accomplice'}}},
                1: {Price: 900, Months: 12, Points: 0, Name: 'Burglary', Type: 'mdw-charges-block-charge-major', Extra:  {0: {Price: 900, Months: 12, Points: 0, Name: 'As accomplice'}}},
                2: {Price: 900, Months: 21, Points: 0, Name: 'Felony Trespassing', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 900, Months: 23, Points: 0, Name: 'As accomplice'}}},
                3: {Price: 1575, Months: 21, Points: 0, Name: 'Arson', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1575, Months: 21, Points: 0, Name: 'As accomplice'}}},
            }
        },
        4: {
            Title: "Offenses Against Public Administration",
            Fines: {
                0: {Price: 0, Months: 0, Points: 0, Name: 'Failure to Appear', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 375, Months: 5, Points: 0, Name: 'As accomplice'}}},
                1: {Price: 525, Months: 7, Points: 0, Name: 'Conspiracy', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 375, Months: 5, Points: 0, Name: 'As accomplice'}}},
                2: {Price: 525, Months: 7, Points: 0, Name: 'Misuse of the 911 System', Type: 'mdw-charges-block-charge-normal', Extra: null},
                3: {Price: 900, Months: 12, Points: 0, Name: 'Bribery', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 900, Months: 12, Points: 0, Name: 'As accomplice'}}},
                4: {Price: 1050, Months: 14, Points: 0, Name: 'Escaping Custody', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1050, Months: 14, Points: 0, Name: 'As accomplice'}}},
                5: {Price: 2100, Months: 28, Points: 0, Name: 'Attempted Prison Break', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 2100, Months: 28, Points: 0, Name: 'As accomplice'}}},
                5: {Price: 3000, Months: 40, Points: 0, Name: 'Prison Break', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 3000, Months: 40, Points: 0, Name: 'As accomplice'}}},
                5: {Price: 2100, Months: 28, Points: 0, Name: 'Violating a Court Order', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 2100, Months: 28, Points: 0, Name: 'As accomplice'}}},
            }
        },
        5: {
            Title: "Offenses Against Public Order",
            Fines: {
                0: {Price: 525, Months: 7, Points: 0, Name: 'Disobeying a Peace Officer', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                1: {Price: 375, Months: 5, Points: 0, Name: 'Disturbing the Peace', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 375, Months: 5, Points: 0, Name: 'As accomplice'}}},
                2: {Price: 525, Months: 7, Points: 0, Name: 'False Reporting', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                3: {Price: 525, Months: 7, Points: 0, Name: 'Harassment', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                4: {Price: 250, Months: 0, Points: 0, Name: 'Vandalism', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 250, Months: 0, Points: 0, Name: 'As accomplice'}}},
                5: {Price: 1000, Months: 5, Points: 0, Name: 'Vandalism of Gov Property', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 1000, Months: 5, Points: 0, Name: 'As accomplice'}}},
                6: {Price: 525, Months: 7, Points: 0, Name: 'Tampering of Evidence', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                7: {Price: 250, Months: 7, Points: 0, Name: 'Stalking', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 250, Months: 7, Points: 0, Name: 'As accomplice'}}},
                8: {Price: 1350, Months: 18, Points: 0, Name: 'Riot', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1350, Months: 18, Points: 0, Name: 'As accomplice'}}},
                9: {Price: 2100, Months: 28, Points: 0, Name: 'Disruption of a Public Utility', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1350, Months: 28, Points: 0, Name: 'As accomplice'}}},
                10: {Price: 1800, Months: 24, Points: 0, Name: 'Felony Obstruction of Justice', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1800, Months: 24, Points: 0, Name: 'As accomplice'}}},
            }
        },
        6: {
            Title: "Offenses Against Public Health and Morals",
            Fines: {
                0: {Price: 525, Months: 7, Points: 0, Name: 'Misdemeanor Possession of Crack', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                1: {Price: 525, Months: 7, Points: 0, Name: 'Misdemeanor Possession of Cocaine', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                2: {Price: 375, Months: 7, Points: 0, Name: 'Misdemeanor Possession of Marijuana', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 375, Months: 7, Points: 0, Name: 'As accomplice'}}},
                3: {Price: 525, Months: 7, Points: 0, Name: 'Misdemeanor Possession of LSD tabs', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                4: {Price: 250, Months: 0, Points: 0, Name: 'Littering', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 250, Months: 0, Points: 0, Name: 'As accomplice'}}},
                5: {Price: 1785, Months: 25, Points: 0, Name: 'Sales of Drugs', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1785, Months: 25, Points: 0, Name: 'As accomplice'}}},
                6: {Price: 1875, Months: 25, Points: 0, Name: 'Felony Possession of Crack', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1785, Months: 25, Points: 0, Name: 'As accomplice'}}},
                7: {Price: 1875, Months: 25, Points: 0, Name: 'Felony Possession of Cocaine', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1785, Months: 25, Points: 0, Name: 'As accomplice'}}},
                8: {Price: 1875, Months: 25, Points: 0, Name: 'Felony Possession of Marijuana', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1785, Months: 25, Points: 0, Name: 'As accomplice'}}},
                9: {Price: 1875, Months: 25, Points: 0, Name: 'Felony Possession of LSD tabs', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1785, Months: 25, Points: 0, Name: 'As accomplice'}}},
                10: {Price: 12250, Months: 150, Points: 0, Name: 'Felony Possession with intent to Distribute', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 12250, Months: 150, Points: 0, Name: 'As accomplice'}}},
                11: {Price: 5000, Months: 70, Points: 0, Name: 'Prostitution', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 5000, Months: 70, Points: 0, Name: 'As accomplice'}}},
                12: {Price: 2250, Months: 30, Points: 0, Name: 'Felony Possession of Human Remains', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 2250, Months: 30, Points: 0, Name: 'As accomplice'}}},
            }
        },
        7: {
            Title: "Offenses Against Public Safety",
            Fines: {
                0: {Price: 525, Months: 7, Points: 0, Name: 'Criminal Possession of a Firearm [Class 1]', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                1: {Price: 525, Months: 7, Points: 0, Name: 'Criminal Possession use of a Firearm', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                2: {Price: 375, Months: 5, Points: 0, Name: 'Resisting Arrest', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 375, Months: 5, Points: 0, Name: 'As accomplice'}}},
                3: {Price: 150, Months: 0, Points: 0, Name: 'Jaywalking', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 150, Months: 0, Points: 0, Name: 'As accomplice'}}},
                4: {Price: 1575, Months: 21, Points: 0, Name: 'Criminal Possession of a Taser', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 1575, Months: 21, Points: 0, Name: 'As accomplice'}}},
                5: {Price: 525, Months: 7, Points: 0, Name: 'Criminal Possession of a Gov Issued Baton', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 0, Name: 'As accomplice'}}},
                9: {Price: 2100, Months: 28, Points: 0, Name: 'Criminal Possession of a Firearm [Class 2]', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 2100, Months: 28, Points: 0, Name: 'As accomplice'}}},
                10: {Price: 12500, Months: 110, Points: 0, Name: 'Criminal Possession of Gov Issued Equipment', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 12500, Months: 110, Points: 0, Name: 'As accomplice'}}},
                11: {Price: 22500, Months: 210, Points: 0, Name: 'Criminal Possession of a Gov Issued Firearm', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 22500, Months: 210, Points: 0, Name: 'As accomplice'}}},
                12: {Price: 2625, Months: 35, Points: 0, Name: 'Criminal Possession of a Firearm [Class 3]', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 2625, Months: 35, Points: 0, Name: 'As accomplice'}}},
                13: {Price: 5000, Months: 45, Points: 0, Name: 'Possession of Explosives', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 5000, Months: 45, Points: 0, Name: 'As accomplice'}}},
                14: {Price: 900, Months: 12, Points: 0, Name: 'Criminal Sales of a Firearm [Class 1]', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 900, Months: 12, Points: 0, Name: 'As accomplice'}}},
                15: {Price: 0, Months: 0, Points: 0, Name: 'Terrorism', Type: 'mdw-charges-block-charge-extreme', Desc: 'Being a terrorist', Extra: {0: {Price: 0, Months: 0, Points: 0, Name: 'As accomplice'}}},
                16: {Price: 0, Months: 0, Points: 0, Name: 'Weapons Trafficking', Type: 'mdw-charges-block-charge-extreme', Extra: {0: {Price: 0, Months: 0, Points: 0, Name: 'As accomplice'}}},
            }
        },
        8: {
            Title: "Offenses Involving Operation of a Vehicle/General Citations",
            Fines: {
                0: {Price: 150, Months: 5, Points: 1, Name: 'Driving While Intoxicated', Type: 'mdw-charges-block-charge-normal', Desc: 'Using a vehicle while drunk', Extra: null},
                1: {Price: 525, Months: 7, Points: 2, Name: 'Hit and Run', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 2, Name: 'As accomplice'}}},
                2: {Price: 525, Months: 7, Points: 2, Name: 'Evading', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 525, Months: 7, Points: 2, Name: 'As accomplice'}}},
                3: {Price: 150, Months: 0, Points: 1, Name: 'Failure to Yield to Emergency Vehicle', Type: 'mdw-charges-block-charge-normal', Extra: {0: {Price: 150, Months: 0, Points: 1, Name: 'As accomplice'}}},
                4: {Price: 150, Months: 0, Points: 1, Name: 'Failure to Obey Traffic Control Devices', Type: 'mdw-charges-block-charge-normal', Extra: null},
                5: {Price: 250, Months: 0, Points: 2, Name: 'Negligent Driving', Type: 'mdw-charges-block-charge-normal', Extra: null},
                6: {Price: 250, Months: 0, Points: 1, Name: '3rd Degree Speeding', Type: 'mdw-charges-block-charge-normal', Extra: null},
                7: {Price: 500, Months: 0, Points: 2, Name: '2nd Degree Speeding', Type: 'mdw-charges-block-charge-normal', Extra: null},
                8: {Price: 750, Months: 0, Points: 3, Name: '1st Degree Speeding', Type: 'mdw-charges-block-charge-normal', Extra: null},
                9: {Price: 250, Months: 0, Points: 1, Name: 'Illegal Passing', Type: 'mdw-charges-block-charge-normal', Extra: null},
                10: {Price: 250, Months: 0, Points: 1, Name: 'Driving on the Wrong Side of The Road', Type: 'mdw-charges-block-charge-normal', Extra: null},
                11: {Price: 250, Months: 0, Points: 1, Name: 'Illegal Turn', Type: 'mdw-charges-block-charge-normal', Extra: null},
                12: {Price: 250, Months: 0, Points: 1, Name: 'Failure to Stop', Type: 'mdw-charges-block-charge-normal', Extra: null},
                13: {Price: 400, Months: 0, Points: 0, Name: 'Unauthorized Parking', Type: 'mdw-charges-block-charge-normal', Extra: null},
                14: {Price: 250, Months: 0, Points: 0, Name: 'Riding on a Sidewalk', Type: 'mdw-charges-block-charge-normal', Extra: null},
                15: {Price: 250, Months: 0, Points: 2, Name: 'Operating a Motor Vehicle Without Proper Identification', Type: 'mdw-charges-block-charge-normal', Extra: null},
                16: {Price: 750, Months: 10, Points: 2, Name: 'Unauthorized Operation of an Off-Road Vehicle', Type: 'mdw-charges-block-charge-normal', Extra: null},
                17: {Price: 250, Months: 0, Points: 0, Name: 'Improper Window Tint', Type: 'mdw-charges-block-charge-normal', Extra: null},
                18: {Price: 100, Months: 0, Points: 0, Name: 'Failure to Signal', Type: 'mdw-charges-block-charge-normal', Extra: null},
                19: {Price: 1050, Months: 14, Points: 3, Name: 'Felony Hit and Run', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1050, Months: 14, Points: 3, Name: 'As accomplice'}}},
                20: {Price: 1350, Months: 18, Points: 3, Name: 'Reckless Evading', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1350, Months: 18, Points: 3, Name: 'As accomplice'}}},
                21: {Price: 900, Months: 12, Points: 3, Name: 'Reckless Driving', Type: 'mdw-charges-block-charge-major', Extra: null},
                22: {Price: 1050, Months: 14, Points: 3, Name: 'Operating a Motor Vehicle on a Suspended or Revoked License', Type: 'mdw-charges-block-charge-major', Extra: null},
                23: {Price: 1575, Months: 21, Points: 4, Name: 'Street Racing', Type: 'mdw-charges-block-charge-major', Extra: {0: {Price: 1575, Months: 21, Points: 4, Name: 'As accomplice'}}},
            }
        },
        9: {
            Title: "Offenses Involving Natural Resources",
            Fines: {
                0: {Price: 375, Months: 5, Points: 0, Name: 'Hunting/Fishing without a License', Type: 'mdw-charges-block-charge-normal', Extra: null},
                1: {Price: 500, Months: 0, Points: 0, Name: 'Hunting in an Unregulated Area', Type: 'mdw-charges-block-charge-normal', Extra: null},
                2: {Price: 525, Months: 7, Points: 0, Name: 'Animal Cruelty', Type: 'mdw-charges-block-charge-normal', Extra: null},
                3: {Price: 1350, Months: 18, Points: 0, Name: 'Poaching', Type: 'mdw-charges-block-charge-major', Extra: null},
            }
        },
    }
}