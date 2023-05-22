-- Adding some blips to the map.

function AddBlips()
    Citizen.CreateThread(function()
        -- Government
        BlipModule.CreateBlip('mrpd', vector3(438.43, -982.05, 30.69), 'Mission Row PD', 60, 29, false, 0.45)
        BlipModule.CreateBlip('vcpd', vector3(-1089.7, -814.88, 19.3), 'Vespucci PD', 60, 29, false, 0.45)
        BlipModule.CreateBlip('sypd', vector3(1852.61, 3686.63, 34.22), 'Sandy PD', 60, 29, false, 0.45)
        BlipModule.CreateBlip('plpd', vector3(-446.25, 6013.37, 31.71), 'Paleto PD', 60, 29, false, 0.45)
        BlipModule.CreateBlip('hospital', vector3(-817.84, -1228.93, 7.34), 'Viceroy Hospital', 61, 69, false, 0.45)
        BlipModule.CreateBlip('cityhall', vector3(-545.41, -203.57, 38.22), 'Cityhall', 590, 0, false, 0.45)
        BlipModule.CreateBlip('depot', vector3(-189.10, -1163.89, 23.67), 'Depot', 317, 44, false, 0.45)
        
        -- Jobs
        BlipModule.CreateBlip('burgershot', vector3(-1192.99, -890.7, 13.98), 'Burgershot', 106, 1, false, 0.45)
        BlipModule.CreateBlip('uwucafe', vector3(-580.03, -1061.67, 22.35), 'UwU Café', 621, 8, false, 0.45)
        BlipModule.CreateBlip('gallery', vector3(-424.75, 24.72, 46.24), 'Vultur Le Culture', 617, 32, false, 0.45)
        BlipModule.CreateBlip('digital', vector3(1136.06, -470.42, 66.48), 'Digital Den', 619, 7, false, 0.45)
        BlipModule.CreateBlip('winery', vector3(-1889.86, 2036.54, 140.83), 'The Winery', 478, 6, false, 0.43)
        BlipModule.CreateBlip('hayesautos', vector3(-1416.86, -447.97, 35.91), 'Hayes Autos Repairs', 478, 12, false, 0.43)
        BlipModule.CreateBlip('vehiclerentals', vector3(110.49, -1089.64, 29.3), 'Vehicle Rentals', 326, 2, false, 0.43)
        BlipModule.CreateBlip('pdm', vector3(-56.2, -1095.39, 26.42), 'Premium Deluxe Motorsport', 225, 26, false, 0.45)
        BlipModule.CreateBlip('unicorn', vector3(127.82, -1296.91, 29.56), 'Vanilla Unicorn', 121, 27, false, 0.45)
        BlipModule.CreateBlip('tunershop', vector3(136.26, -3030.82, 178.98), '6STR. Tuner Shop', 478, 44, false, 0.45)

        BlipModule.CreateBlip('bank-bay', vector3(-1307.44, -816.6, 17.3), 'Bay City Bank', 108, 52, false, 0.45)
        BlipModule.CreateBlip('bank-01', vector3(149.79, -1040.14, 29.37), 'Bank', 108, 52, false, 0.45)
        BlipModule.CreateBlip('bank-02', vector3(314.67, -277.37, 54.17), 'Bank', 108, 52, false, 0.45)
        BlipModule.CreateBlip('bank-03', vector3(-350.36, -48.11, 49.05), 'Bank', 108, 52, false, 0.45)
        BlipModule.CreateBlip('bank-04', vector3(-1213.71, -328.95, 37.79), 'Bank', 108, 52, false, 0.45)
        BlipModule.CreateBlip('bank-05', vector3(-2964.71, 482.85, 15.71), 'Bank', 108, 52, false, 0.45)
        BlipModule.CreateBlip('bank-06', vector3(1175.23, 2705.7, 38.09), 'Bank', 108, 52, false, 0.45)
        BlipModule.CreateBlip('bank-07', vector3(-110.02, 6463.66, 31.63), 'Bank', 108, 52, false, 0.45)
        BlipModule.CreateBlip('bank-08', vector3(-1311.57, -827.66, 17.15), 'Bank', 108, 52, false, 0.45)
        BlipModule.CreateBlip('bank-09', vector3(236.21, 217.46, 106.29), 'Bank', 108, 52, false, 0.45)
        BlipModule.CreateBlip('jewel', vector3(-629.6, -236.23, 38.05), 'Vangelico Jewellery', 617, 26, false, 0.45)
        BlipModule.CreateBlip('bobcat-security', vector3(882.38, -2256.24, 30.54), 'Bobcat Security', 498, 69, false, 0.45)

        BlipModule.CreateBlip('hunting-store', vector3(-679.48, 5839.23, 17.33), 'Sporting & Survival', 59, 26, false, 0.43)
        BlipModule.CreateBlip('mining-cave', vector3(-596.37, 2089.22, 131.41), 'Los Santos Mining Cave', 78, 31, false, 0.45)

        BlipModule.CreateBlip('bicycle-shop', vector3(-1108.56, -1693.44, 4.37), 'Bicycle Shop', 226, 7, false, 0.45)
        BlipModule.CreateBlip('pier', vector3(-1646.2, -1112.89, 13.02), 'Del Perro Pier', 266, 1, false, 0.45)

        BlipModule.CreateBlip('jail', vector3(1695.32, 2602.01, 45.0), 'Bolingbroke Penitentiary', 188, 0, false, 0.70)
        
        BlipModule.CreateBlip('casino', vector3(925.94, 45.9, 81.1), 'Diamond Casino', 304, 36, false, 0.45)
    end)
end