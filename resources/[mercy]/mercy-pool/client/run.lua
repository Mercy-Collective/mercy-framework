local hasCue = false

Citizen.CreateThread(function()
    exports['mercy-ui']:AddEyeEntry(GetHashKey('prop_pool_rack_01'), {
        Type = 'Model',
        Model = 'prop_pool_rack_01',
        SpriteDistance = 1.5,
        Distance = 0.5,
        Options = {
            {
                Name = "take_cue",
                Icon = 'fas fa-play',
                Label = 'Take/Return Cue', 
                EventType = "Client",
                EventName = "mercy-pool:cue",
                EventParams = {},
                Enabled = function(Entity)
                    return true
                end,
            },
        }
    })
    exports['mercy-ui']:AddEyeEntry(GetHashKey('prop_pooltable_02'), {
        Type = 'Model',
        Model = 'prop_pooltable_02',
        SpriteDistance = 10.0,
        Distance = 1.5,
        Options = {
            {
                Name = "start_normal",
                Icon = 'fas fa-play',
                Label = 'Start Game',
                EventType = "Client",
                EventName = "mercy-pool:setupTable",
                EventParams = "BALL_SETUP_STRAIGHT_POOL",
                Enabled = function(Entity)
                    return hasCue
                end,
            },
        }
    })
end)

t89222824=((t48958563==t71006805)==(t19800738==t65549621))

t61549719=function(t14044781)
    return t14044781 
end

t22361651=function(entity,t14319165)
    local t9907687=_G["GetEntityCoords"] (entity)t69086120(t9907687,t14319165,{t61549719("hit_1"),t61549719("hit_2")})
end 

t79046243=function(entity,t14319165)
    local t9907687=_G["GetEntityCoords"] (entity)t69086120(t9907687,t14319165,{t61549719("cue_hit")})
end

t2005441=function(entity,t14319165)
    local t9907687=_G["GetEntityCoords"] (entity)t69086120(t9907687,t14319165,{t61549719("cushion_hit")})
end

t14047830=function(t9907687)
    t69086120(t9907687,(((`vamos`|`coquette`)~(-8663558))/10),{t61549719("pocket_1"),t61549719("pocket_2")})
end

t69086120=function(t9907687,t14319165,sounds)
    if t89222824 then 
        if t14319165<((`tulip`~1456744817)/1) or t14319165>((`banshee2`~633712402)/1) then 
            print("INVALID STRENGTH! Must be between 0.0 and 1.0")
        else 
            if t49065267 and #(t49065267-t9907687)<((`rebla`~83136411)/10) then 
                t89222824=((t91472769==t55434014)==(t92936148 and t78479183))
                local t79973049=_G["GetGameplayCamCoord"] ()_G["SendNUIMessage"] ({["transactionType"]="playSound",["position"]=t9907687,["volume"]=t14319165,["sounds"]=sounds})
                Citizen["CreateThread"] (function()
                    _G["Wait"] ((`schwarzer`~(-746882698)))t89222824=((t19279409==t79765737)==(t75540231==t28849298))
                end )
            end 
        end 
    end 
end 

Citizen["CreateThread"] (function()
    while ((t78881613==t54278555)==(t35657058==t66144119)) do 
        if t49360992 then 
            _G["Wait"] ((`bodhi2`~(-1435919490)))
        else _G["Wait"] ((`radi`~(-1651068021)))
        end 
        if t7697375~=t10935101 then 
            local t18950149,t36919223,t80037072,t18950149=_G["GetCamMatrix"] ((`italigtb2`~(-482719877)))
            local t5304141=_G["GetGameplayCamRot"] ()
            local t77509695=_G["GetGameplayCamCoord"] ()
            local t31553500=t13761251(t5304141)
            local t63811859=vector3((((`washington`|`krieger`)~101029525)/1),(((`rapidgt2`|`taipan`)~(-2240033))/1),(((`peyote2`|`faction`)~(-1778659613))/10))_G["SendNUIMessage"] ({["transactionType"]="setOrientation",["fwd"]=t31553500,["up"]=vector3(((`sc1`~1352136073)/1),((`ninef`~1032823388)/1),((`primo`~(-1150599090))/1)),["coord"]=t77509695})
        end 
    end 
end )

t13761251=function(rotation)
    local t84765615={["x"]=(math["pi"] /(`rebel`~(-1207771662)))*rotation["x"] ,["y"]=(math["pi"] /(`cyclone`~1392481411))*rotation["y"] ,["z"]=(math["pi"] /(`italigtb2`~(-482719793)))*rotation["z"] }
    return vector3((-math["sin"] (t84765615["z"] ))*math["abs"] (math["cos"] (t84765615["x"] )),math["cos"] (t84765615["z"] )*math["abs"] (math["cos"] (t84765615["x"] )),math["sin"] (t84765615["x"] )) 
end

t75985342=function(ballA,ballB,t30026098)
    local t38846005=#(ballA["position"] -ballB["position"] )*((`dilettante`|`sanchez`)~(-1090928853))
    local t41720935=t81994342*(`dilettante`~(-1130810101))*((`kanjo`|`massacro`)~(-8659174))
    local t6880322=math["asin"] (math["sin"] (math["rad"] (t30026098))*t38846005/t41720935)
    local t96747030=(((`sc1`|`sandking`)~(-105382035))/1)-t30026098-math["deg"] (t6880322)
    return math["sin"] (math["rad"] (t96747030))*t81994342*((`monroe`|`cavalcade`)~(-138463303))/math["sin"] (math["rad"] (t30026098)) 
end 

t1197534=function(ignoreEntity,position,balls)
    for t18950149,collisionBall in pairs(balls) do 
        if ignoreEntity~=collisionBall["entity"]  then 
            local t24757934=#(position-collisionBall["position"] )-t81994342*(`rumpo3`~1475773101)
            if t24757934<(((`blista2`|`defiler`)~(-1040146395))/10000) then 
                return ((t38187484==t52199337)==(t9270507==t9950369)) 
            end 
        end 
    end 
    return ((t35297311==t98713446)==(t74043316 and t47345797)) 
end 

t16090463=function(ballA,ballB)
    local t89762445=#(ballA["position"] -ballB["position"] )-t81994342*((`adder`|`locust`)~(-134352237))
    if #ballA["velocity"] >(`daemon`~2006142190) and t89762445<(((`bati`|`hexer`)~101225258)/10000) and #(ballA["position"] -ballB["position"] )~=(((`xls`|`autarch`)~(-268439682))/1) then 
        local t73586010=ballA["velocity"] /#ballA["velocity"] 
        local t12505184=(ballA["position"] -ballB["position"] )/#(ballA["position"] -ballB["position"] )
        local t58769299=math["atan2"] (t73586010["y"] -t12505184["y"] ,t73586010["x"] -t12505184["x"] )
        local t79957806=math["deg"] (t58769299)
        local t39617327=((`vstr`~1456336509)/1)
        if t79957806==(((`outlaw`|`novak`)~(-1694552065))/1) then 
            t39617327=t81994342*((`clique`|`ztype`)~(-1346372429))-#(ballA["position"] -ballB["position"] )
        else 
            local t30026098=((`sandking2`~989381617)/1)-t79957806 t83969903=t75985342(ballA,ballB,t30026098)t97484817=t75985342(ballA,ballB,t79957806)
            if t83969903<t97484817 then 
                t39617327=t83969903 
            else t39617327=t97484817 
            end 
        end 
        if t39617327>(`dominator2`~(-915704871)) then 
            ballA["position"] =ballA["position"] -t73586010*t39617327 
        end 
    end 
end 

t88460647=function(ballA,ballB)
    t16090463(ballA,ballB)
    local t23989660=ballA["position"] ["x"] -ballB["position"] ["x"] 
    local t98698202=ballA["position"] ["y"] -ballB["position"] ["y"] 
    local t57946148=ballB["velocity"] ["x"] -ballA["velocity"] ["x"] 
    local t98301870=ballB["velocity"] ["y"] -ballA["velocity"] ["y"] 
    local t66985562=t23989660*t23989660+t98698202*t98698202 
    local t9874151=t23989660*t57946148+t98698202*t98301870 
    local t30062683=t9874151/t66985562 t22361651(ballA["entity"] ,math["min"] ((((`rhapsody`|`surge`)~(-1087439458))/1),math["max"] (((`ninef`~1032823385)/1000),t30062683/(((`paragon`|`deviant`)~(-310378547))/1))))
    local t88058218=t23989660*t30062683 
    local t13560037=t98698202*t30062683 ballA["velocity"] =(ballA["velocity"] +vector2(t88058218,t13560037))*t39785006 ballB["velocity"] =(ballB["velocity"] -vector2(t88058218,t13560037))*t39785006 
end

t81994342=((`nightshade`~(-1943285544))/100)t55525476=((`verlierer2`~1102544782)/1000)t13505160=((`double`~(-1670998929))/1000)t47821395=(((`washington`|`savestra`)~2113862616)/10)t39785006=((`sandking2`~989381392)/100)t70418405=((`ninef2`|`cogcabrio`)~(-1141375096))t34196728={[`prop_pooltable_3b`]=vector2(((`emperor2`~(-1883002219))/1000),(((`sentinel2`|`vagner`)~(-2006429203))/1000)),[`prop_pooltable_02`]=vector2((((`vacca`|`ruffian`)~(-557900309))/1),(((`cheetah2`|`osiris`)~2139062239)/1))}t99667691={}t10935101=(`fmj`~1426219629)t69750738=((`rapidgt`|`bodhi2`)~(-1359242316))t18626986=(`rapidgt`~(-1934452201))t37745422=((`issi3`|`schwarzer`)~(-134512653))t7697375=t10935101 t93314187=(t91524597 or t93402600)t67357504=(t10956442 or t39522817)t49360992=((t9721716==t84347943)==(t95396453 and t34471112))t49065267=(t17803836 or t65921563)

Citizen["CreateThread"] (function()
    while ((t79552328==t56751055)==(t43306262==t62217385)) do 
        _G["Wait"] (((`guardian`|`vamos`)~(-10839019)))
        local t89640496=((t21529354==t90332553)==(t9130267 and t30821810))
        local t68525158=_G["PlayerPedId"] ()
        local t20224508=_G["GetEntityCoords"] (t68525158)t49065267=t20224508 _G["Wait"] (((`asea`|`cavalcade`)~(-138448945)))
        for t18950149,t41778860 in pairs(t99667691) do 
            _G["Wait"] ((`glendale`~75131813))
            if #(t20224508-t41778860["tablePos"] )<(Config["ExperimentalTableDetect"]  or (((`yosemite`|`revolter`)~(-274930713))/1)) then 
                t89640496=((t20520233==t71616546)==(t53412722==t64872808))
            end 
        end 
        t49360992=t89640496 
    end 
end )

AddEventHandler("onResourceStop",function(resourceName)
    if (_G["GetCurrentResourceName"] ()~=resourceName) then 
        return  
    end 
    t79329772()
end )

Citizen["CreateThread"] (function()
    TriggerServerEvent("mercy-pool:requestTables")
end )

t79329772=function()
    for t18950149,table in pairs(t99667691) do 
        for t18950149,ball in pairs(table["balls"] ) do 
            if ball["entity"]  then 
                _G["DeleteObject"] (ball["entity"] )
            end 
        end 
    end 
    _G["DeleteObject"] (t86283871)_G["DeleteObject"] (t67357504)
end 

t72918344=function(t9907687,t81463867)
    local t88658813=math["sin"] (math["rad"] (t81463867))
    local t72741519=math["cos"] (math["rad"] (t81463867))
    local t14044781=((t9907687["x"] *t72741519)-(t9907687["y"] *t88658813))
    local t97521401=((t9907687["x"] *t88658813)+(t9907687["y"] *t72741519))
    local t12114950=t9907687["z"] 
    return vector3(t14044781,t97521401,t12114950) 
end 

Citizen["CreateThread"] (function()
    while ((t22730545==t34644888)==(t6578500==t26337164)) do 
        _G["Wait"] ((`tornado5`~(-1797613329)))
        if not t98115899 and t93314187 and t7697375==t10935101 then 
            if hasCue then 
                if not t99667691[t93314187] ["player"]  then 
                    local t61796664=#t99667691[t93314187] ["balls"] >((`tailgater`|`rebla`)~(-939655218))
                    if not t61549719(WarMenu)["IsMenuOpened"] ("pool") then 
                        if t99667691[t93314187]  and t61796664 then 
                            t38480160("TEB_POOL_PLAY_SETUP",(`clique`~(-1566607184)))
                        else t38480160("TEB_POOL_SETUP",((`dilettante`|`drafter`)~(-1124352753)))
                        end 
                    end 
                    local t16425820=_G["IsControlJustPressed"] (((`nero2`|`cog55`)~2000417790),t61549719(Config["Keys"] ["ENTER"] ["code"] )) or _G["IsDisabledControlJustPressed"] (((`voltic`|`cheburek`)~(-547356674)),t61549719(Config["Keys"] ["ENTER"] ["code"] ))
                    local t40687423=_G["IsControlPressed"] ((`faction2`~(-1790546981)),t61549719(Config["Keys"] ["SETUP_MODIFIER"] ["code"] )) or _G["IsDisabledControlPressed"] (((`stromberg`|`feltzer2`)~(-1109671947)),t61549719(Config["Keys"] ["SETUP_MODIFIER"] ["code"] ))
                    if t16425820 and t40687423 then 
                        TriggerEvent("mercy-pool:openMenu")
                    elseif t16425820 and not t40687423 and t61796664 then 
                        t31480331(t93314187)end 
                    else 
                        _G["Wait"] ((`drafter`~686471675))
                    end 
                else t38480160("TEB_POOL_HINT_TAKE_CUE",(`fugitive`~1909141499))
                end 
            else 
                _G["Wait"] ((`everon`~(-1756021284)))
            end 
        end 
    end )
    
    Citizen["CreateThread"] (function()
        local t55626083={_G["GetHashKey"] ("prop_pooltable_3b"),_G["GetHashKey"] ("prop_pooltable_02")}
        while ((t34879638==t32468112)==(t39275872==t62229580)) do 
            if t49360992 then 
                _G["Wait"] (((`felon2`|`novak`)~(-84048108)))
            else 
                _G["Wait"] (((`jugular`|`xls`)~(-138426177)))
            end 
            local t68525158=_G["PlayerPedId"] ()
            local t20224508=_G["GetEntityCoords"] (t68525158)
            for t18950149,table in pairs(t99667691) do 
                local t41629473=table["tablePos"] 
                local t58232727=#(t20224508-t41629473)
                if table["entity"]  then 
                    if not _G["DoesEntityExist"] (table["entity"] ) or t58232727>(Config["ExperimentalTableGC"]  or ((`cogcabrio`~330661304)/1)) then 
                        table["entity"] =(t86616180 or t12672863)table["cushionColliders"] =(t49287823 or t8807104)table["pocketColliders"] =(t32343115 or t74747567)
                    end 
                elseif t58232727<(Config["ExperimentalTableDetect"]  or ((`blade`~(-1205801664))/1)) then 
                    for t18950149,t3746252 in pairs(t55626083) do 
                        _G["Wait"] (((`swinger`|`torero`)~1576920475))
                        local t67025195=_G["GetClosestObjectOfType"] (t41629473["x"] ,t41629473["y"] ,t41629473["z"] ,((`furia`~960812449)/10),t3746252,((t816445==t34608303)==(t32230313 and t88463696)),(`buccaneer`~(-682211828)),(`ninef2`~(-1461482751)))
                        if t67025195 and t67025195>((`casco`|`furoregt`)~(-1086931458)) then 
                            table["entity"] =t67025195 table["cushionColliders"] =t18200167(table["entity"] ,t3746252)table["pocketColliders"] =t22160437(table["entity"] ,t3746252)end 
                        end 
                    end 
                end 
            end 
        end )
        Citizen["CreateThread"] (function()
            local t55626083={_G["GetHashKey"] ("prop_pooltable_3b"),_G["GetHashKey"] ("prop_pooltable_02")}
            while ((t82854077==t27895053)==(t4785861==t99908538)) do 
                _G["Wait"] (((`entityxf`|`sc1`)~(-218106303)))
                local t68525158=_G["PlayerPedId"] ()
                local t13465527=_G["GetEntityCoords"] (t68525158)
                for t18950149,t3746252 in pairs(t55626083) do 
                    _G["Wait"] (((`lectro`|`everon`)~(-1216922233)))
                    local t61290579=_G["GetClosestObjectOfType"] (t13465527["x"] ,t13465527["y"] ,t13465527["z"] ,(Config["ExperimentalTableDetect"]  or ((`warrener`~1373123382)/1)),t3746252,((t3048098==t79268798)==(t89539889 and t4877322)),((`asbo`|`stinger`)~1588572127),((`penumbra`|`riata`)~(-307956397)))if t61290579 and t61290579>(`tornado`~464687292) then 
                        local t73174435=_G["GetEntityCoords"] (t61290579)
                        local t6697399=t99795736(t73174435)
                        if not t99667691[t6697399]  then 
                            TriggerServerEvent("mercy-pool:registerTable",t73174435)
                        end 
                    end 
                end 
            end 
        end )
        RegisterNetEvent("mercy-pool:syncTableState")
        AddEventHandler("mercy-pool:syncTableState",function(t6697399,newTableData,isCueBallHit,hitStrength)
            if newTableData and t99667691[t6697399]  then 
                local t41778860=t99667691[t6697399] 
                if t41778860["entity"]  then 
                    newTableData["entity"] =t41778860["entity"] newTableData["cushionColliders"] =t41778860["cushionColliders"] newTableData["pocketColliders"] =t41778860["pocketColliders"] 
                end 
                for t18950149,ball in pairs(t41778860["balls"] ) do 
                    if ball["entity"]  and _G["DoesEntityExist"] (ball["entity"] ) then 
                        local t96993975=((t79902929==t64647204)==(t12581402 and t16194119))
                        for t18950149,newBall in pairs(newTableData["balls"] ) do 
                            if ball["ballNum"] ==newBall["ballNum"]  then 
                                newBall["entity"] =ball["entity"] t96993975=((t53138339==t79875491)==(t92835540==t5005368))
                            end 
                        end 
                        if not t96993975 then 
                            _G["DeleteObject"] (ball["entity"] )
                        end 
                    end 
                end 
            elseif t99667691[t6697399]  then 
                local t41778860=t99667691[t6697399] 
                for t18950149,ball in pairs(t41778860["balls"] ) do 
                    if ball["entity"]  and _G["DoesEntityExist"] (ball["entity"] ) then
                         _G["DeleteObject"] (ball["entity"] )
                        end 
                    end 
                end 
                local t68525158=_G["PlayerPedId"] ()
                local t20224508=_G["GetEntityCoords"] (t68525158)["xy"] t99667691[t6697399] =newTableData t2023733()
                if isCueBallHit and t99667691[isCueBallHit] ["entity"]  then 
                    local t97899441=_G["GetPlayerServerId"] (_G["PlayerId"] ())
                    if t99667691[isCueBallHit]  and t99667691[isCueBallHit] ["player"] ==t97899441 then 
                        t7697375=t37745422 
                    end 
                    t79046243(t99667691[isCueBallHit] ["balls"] [t99667691[isCueBallHit] ["cueBallIdx"] ] ["entity"] ,hitStrength)
                end 
            end )
            
            Citizen["CreateThread"] (function()
                local t51095706={}
                while ((t73265896==t31885809)==(t83527841==t41858126)) do 
                    _G["Wait"] ((`cogcabrio`~330660990))
                    if t7697375==t10935101 then 
                        local t68525158=_G["PlayerPedId"] ()
                        local t13465527=_G["GetEntityCoords"] (t68525158)
                        local t75552426=((t89878295==t37809445)==(t85189385 and t17776397))
                        for t6697399,table in pairs(t99667691) do 
                            if table["entity"]  then 
                                if not t51095706[t6697399]  then 
                                    t51095706[t6697399] =_G["GetEntityModel"] (table["entity"] )
                                end 
                                local t3746252=t51095706[t6697399] 
                                local t20224508=_G["GetEntityCoords"] (table["entity"] )
                                local t81463867=_G["GetEntityHeading"] (table["entity"] )
                                local t72046414,t84247335=_G["GetModelDimensions"] (t3746252)
                                local t78384674=t34196728[t3746252] _G["Wait"] (((`sandking`|`ruffian`)~(-71491592)))
                                local t6032781=_G["GetOffsetFromEntityInWorldCoords"] (table["entity"] ,t78384674["x"] ,t84247335["y"] +(((`rapidgt2`|`kuruma`)~(-272630095))/10)+t78384674["y"] ,((`monroe`~(-433375719))/1))_G["Wait"] ((`issi3`~931280609))
                                local t36474111=_G["GetOffsetFromEntityInWorldCoords"] (table["entity"] ,t78384674["x"] ,t72046414["y"] -(((`issi2`|`cheetah2`)~(-1110474909))/10)+t78384674["y"] ,(((`deviant`|`zion3`)~(-1866465136))/1))_G["Wait"] (((`zhaba`|`superd`)~1325399895))
                                local t26142047=_G["IsPointInAngledArea"] (t13465527,t6032781,t36474111,math["abs"] (t72046414["x"] )+math["abs"] (t84247335["x"] )+(((`tyrant`|`nemesis`)~(-71789594))/10),((t1840811==t36821664)==(t24370748==t71802517)),((t85539987==t66314846)==(t36324725==t4855981)))
                                if t26142047 then 
                                    t93314187=t6697399 t75552426=((t68433697==t6828494)==(t44004415==t5779739))
                                end 
                            end 
                        end 
                        if not t75552426 then 
                            t93314187=(t60302798 or t47486038)TriggerEvent("mercy-pool:closeMenu")
                        end 
                    end 
                end end )
                
                Citizen["CreateThread"] (function()
                    while ((t72461038==t70305603)==(t11185095==t76954830)) do 
                        if t49360992 then 
                            _G["Wait"] (((`kamacho`|`sultan`)~(-103094781)))t2023733()
                        else 
                            _G["Wait"] ((`baller4`~634119474))
                        end 
                    end end )
                    
                    t2023733=function()
                        for _a,table in pairs(t99667691) do 
                            _G["Wait"] (((`buffalo2`|`jugular`)~(-68387073)))
                            for t18950149,ball in pairs(table["balls"] ) do 
                                if not _G["DoesEntityExist"] (ball["entity"] ) then 
                                    ball["entity"] =(t90460598 or t39099047)
                                end 
                                if not ball["entity"]  and table["entity"]  then 
                                    if not ball["disabled"]  then 
                                        local t3746252=(t9285751 or t50976806)
                                        if ball["ballNum"] ==(`patriot`~808457412) then 
                                            t3746252=_G["GetHashKey"] ("prop_poolball_cue")
                                        else t3746252=_G["GetHashKey"] ("prop_poolball_"..ball["ballNum"] )
                                        end 
                                        local t92463598=_G["GetOffsetFromEntityInWorldCoords"] (table["entity"] ,((`hermes`~15219735)/1),(((`faggio`|`sultan`)~(-1141118977))/1),((`xls`~1203490679)/100))["z"] 
                                        local t50873150=_G["CreateObject"] (t3746252,vector3(ball["position"] ["x"] ,ball["position"] ["y"] ,t92463598),((t19343432==t33285165)==(t85808273 and t40849005)),((t99493914==t16800811)==(t41867272 and t15980709)),((t56683984==t62171655)==(t62275311 and t62936880)))_G["SetEntityAsMissionEntity"] (t50873150,((t55845590==t49056121)==(t33971124 and t86344845)),((t72442745==t32218118)==(t54458428 and t66994708)))_G["SetEntityRotation"] (t50873150,((`daemon`~(-2006142136))/1),((`gresley`~(-1543762099))/1),(((`gp1`|`faction2`)~(-573146113))/1),(`zentorno`~(-1403128553)),((`rebel2`|`locust`)~(-940050853)))ball["entity"] =t50873150 
                                    end 
                                else 
                                    if not table["entity"]  then 
                                        _G["DeleteObject"] (ball["entity"] )ball["entity"] =(t90094754 or t92073364)
                                    end 
                                end 
                            end 
                        end 
                    end 
                    
                    Citizen["CreateThread"] (function()
                        local t39425259=_G["GetPlayerServerId"] (_G["PlayerId"] ())
                        while ((t61128997==t12166778)==(t86064364==t30023049)) do 
                            local t54537695=((t10989978==t49806103)==(t79091973 and t30663278))
                            for t6697399,table in pairs(t99667691) do 
                                if t39425259==table["player"]  then 
                                    local t47409820=((t76342041==t32227264)==(t53943197 and t65988635))
                                    for t18950149,ball in pairs(table["balls"] ) do 
                                        if #ball["velocity"] >(((`burrito3`|`primo2`)~(-1636327462))/100000) and not ball["disabled"]  then 
                                            t47409820=((t12858834==t29053561)==(t43568450==t61013146))t54537695=((t23886004==t44534890)==(t40519744==t72079949))
                                        end 
                                    end 
                                    if not t47409820 and t7697375==t37745422 then 
                                        t7697375=t10935101 TriggerServerEvent("mercy-pool:syncFinalTableState",t6697399,table["balls"] )
                                    end 
                                    break 
                                end 
                            end 
                            if not t54537695 then 
                                _G["Wait"] (((`flashgt`|`adder`)~(-1208245647)))
                            else _G["Wait"] (((`asbo`|`issi2`)~(-68174977)))
                            end 
                        end 
                    end )
                    
                    RegisterNetEvent("mercy-pool:internalNotification")
                    AddEventHandler("mercy-pool:internalNotification",function(serverId,t6697399,t41717886)
                        if t99667691[t6697399] ["entity"]  then 
                            if #(_G["GetEntityCoords"] (t99667691[t6697399] ["entity"] )-_G["GetEntityCoords"] (_G["PlayerPedId"] ()))<t61549719(Config["NotificationDistance"]  or 20.0) then 
                                local t69634887=_G["GetPlayerFromServerId"] (serverId)
                                if t69634887 and t69634887>(`banshee`~(-1041692462)) then 
                                    if t61549719(Config["CustomNotifications"] ) then 
                                        TriggerEvent("mercy-pool:notification",serverId,t41717886)
                                    else 
                                        local t68525158=_G["GetPlayerPed"] (t69634887)
                                        if t68525158 and t68525158>(`stafford`~321186144) then 
                                            local t3706619=_G["RegisterPedheadshot"] (t68525158)
                                            while not _G["IsPedheadshotReady"] (t3706619) do 
                                                Citizen["Wait"] ((`prairie`~(-1450650718)))
                                            end 
                                            local t39580743=_G["GetPedheadshotTxdString"] (t3706619)_G["SetNotificationTextEntry"] ("STRING")_G["AddTextComponentSubstringPlayerName"] (t41717886)_G["SetNotificationMessage"] (t39580743,t39580743,((t88158825==t48842712)==(t65455111 and t93835516)),((`faction2`|`prairie`)~(-1110508548)),Config["Text"] ["POOL_GAME"]  or "Pool game","")_G["DrawNotification"] (((t1880444==t64171606)==(t71156192==t59988781)),((t38318579==t96509231)==(t9858908==t53409674)))
                                        end 
                                    end 
                                end 
                            end 
                        end 
                    end )

                    
t47489086=function(dict)
    while (not _G["HasAnimDictLoaded"] (dict)) do 
        _G["RequestAnimDict"] (dict)Citizen["Wait"] ((`pcj`~(-909201566)))
    end 
end 

t38480160=function(entry)
    _G["DisplayHelpTextThisFrame"] (entry,(`baller2`~142944341))
end

t86283871=(t48845761 or t420114)t35419259=(((`warrener`|`xls`)~(-1476132655))/1)t95106826=(t83338821 or t53988928)t90134387=(t36163143 or t98923806)t46528744=(t58537597 or t57924807)
local t10633279=t10633279 
local t96859832=t96859832 
local t18803811=t18803811 
local t11721667=t11721667 
local t4688302=t4688302 
local t19072097=t19072097 
local t20977539=t20977539 
local t10633279=t10633279 
local t55068170=t55068170 
local t57714447=t57714447 

-- Citizen["CreateThread"] (function()
--     local t11072293=""
--     if Config["BallSetupCost"]  then 
--         t11072293=" ~g~"..Config["BallSetupCost"] .."~s~"
--     end 
--     _G["AddTextEntry"] ("TEB_POOL_SETUP","~"..t61549719(Config["Keys"] ["SETUP_MODIFIER"] ["label"] ).."~ + ~"..t61549719(Config["Keys"] ["ENTER"] ["label"] ).."~"..t11072293.." "..Config["Text"] ["HINT_SETUP"] )_G["AddTextEntry"] ("TEB_POOL_TAKE_CUE","~"..t61549719(Config["Keys"] ["ENTER"] ["label"] ).."~ "..Config["Text"] ["HINT_TAKE_CUE"] )_G["AddTextEntry"] ("TEB_POOL_RETURN_CUE","~"..t61549719(Config["Keys"] ["ENTER"] ["label"] ).."~"..Config["Text"] ["HINT_RETURN_CUE"] )_G["AddTextEntry"] ("TEB_POOL_HINT_TAKE_CUE",Config["Text"] ["HINT_HINT_TAKE_CUE"] )_G["AddTextEntry"] ("TEB_POOL_PLAY_SETUP","~"..t61549719(Config["Keys"] ["ENTER"] ["label"] ).."~ "..Config["Text"] ["HINT_PLAY"] .."~n~~"..t61549719(Config["Keys"] ["SETUP_MODIFIER"] ["label"] ).."~ + ~"..t61549719(Config["Keys"] ["ENTER"] ["label"] ).."~"..t11072293.." "..Config["Text"] ["HINT_SETUP"] )
-- end )

Citizen["CreateThread"] (function()
    local t88320407=(t8828445 or t9154656)
    while ((t99570132==t53214556)==(t68384918==t90896563)) do 
        if t49360992 then 
            _G["Wait"] ((`brawler`~(-1479664699)))
        else 
            _G["Wait"] (((`tailgater`|`bf400`)~(-939656653)))
        end 
        if t7697375==t10935101 then 
            t95106826=(t80881564 or t2718838)
        elseif t7697375==t69750738 then 
            if t88320407~=t69750738 then 
                t95106826=(t19166607 or t4203558)t88320407=t69750738 
            end 
            if not t95106826 then 
                t95106826=t38644790("instructional_buttons")
            end 
                _G["DrawScaleformMovieFullscreen"] (t95106826,(`hexer`~301427947),((`italigtb2`|`specter`)~(-209817724)),(`faction2`~(-1790547164)),((`hexer`|`tailgater`)~(-738198239)),(`sentinel2`~873639469))
        elseif t7697375==t18626986 then 
            if t88320407~=t18626986 then 
                t95106826=(t56915686 or t91835565)t88320407=t18626986 
            end 
            if not t95106826 then 
                t95106826=t14608792("instructional_buttons")
            end 
            _G["DrawScaleformMovieFullscreen"] (t95106826,(`swinger`~500482048),((`rapidgt3`|`comet2`)~(-72418039)),(`windsor2`~(-1930048994)),(`youga`~65402439),(`speedo`~(-810318068)))
        end
    end
end)
    
t31480331=function(t6697399)
    if not t99667691[t6697399] ["player"]  then 
        TriggerServerEvent("mercy-pool:requestTurn",t6697399)
    end 
end 

RegisterNetEvent("mercy-pool:turnGranted")
AddEventHandler("mercy-pool:turnGranted",function(t6697399)
    t99667691[t6697399] ["player"] =_G["GetPlayerServerId"] (_G["PlayerId"] ())
    if not t99667691[t6697399] ["balls"] [t99667691[t6697399] ["cueBallIdx"] ] ["disabled"]  then 
        t7697375=t69750738 t65186825()
    else 
        local t78384674=t34196728[_G["GetEntityModel"] (t99667691[t6697399] ["entity"] )] t99667691[t6697399] ["balls"] [t99667691[t6697399] ["cueBallIdx"] ] ["disabled"] =(t7060195 or t52315188)t99667691[t6697399] ["balls"] [t99667691[t6697399] ["cueBallIdx"] ] ["position"] =_G["GetOffsetFromEntityInWorldCoords"] (t99667691[t6697399] ["entity"] ,(-0.043)+t78384674["x"] ,((`oracle2`~(-511601013))/1000)+t78384674["y"] ,((`surano`~384071832)/100))["xy"] 
        TriggerServerEvent("mercy-pool:setBallInHandData",t6697399,t99667691[t6697399] ["balls"] [t99667691[t6697399] ["cueBallIdx"] ] ["position"] )t2023733()t7697375=t18626986 t11374114((((`flashgt`|`coquette`)~(-1225006785))/1))
    end 
end )

t11374114=function(t81463867)
    local t43068463=t99667691[t93314187] ["entity"] 
    local t78921246=t99667691[t93314187] ["balls"] [t99667691[t93314187] ["cueBallIdx"] ] 
    local t53815151=_G["GetEntityCoords"] (t78921246["entity"] )
    local t4453552=_G["GetEntityHeading"] (t43068463)
    local t8697351=((`rapidgt2`~1737773230)/1)t46528744=_G["CreateCam"] ("DEFAULT_SCRIPTED_CAMERA",((`reaper`|`stafford`)~536340964))_G["SetCamCoord"] (t46528744,t53815151["x"] ,t53815151["y"] ,t53815151["z"] +t8697351)_G["SetCamRot"] (t46528744,((`premier`~1883869245)/1),((`lynx`~482197771)/1),t81463867)
    TriggerServerEvent("mercy-pool:ballInHandNotify",t93314187)
    if _G["IsCamActive"] (t90134387) then 
        _G["SetCamActiveWithInterp"] (t46528744,t90134387,(`verlierer2`~1102543948),(`sentinel`~1349725558),((`fcr`|`zorrusso`)~(-143131125)))_G["Wait"] ((`vortex`~(-609626092)))_G["DestroyCam"] (t90134387)
    else 
        _G["SetCamActive"] (t46528744,((t42080682==t52427990)==(t62711276==t17108731)))_G["RenderScriptCams"] (((t20367797==t95475720)==(t13285653==t85625350)),((t75369503==t84018682)==(t78131631 and t24639035)),((`hakuchou2`|`bati`)~(-101536289)),((t81851052==t21322042)==(t16078268==t2996270)),((t48443331==t84274774)==(t36794226 and t17877005)))
    end 
    local t33114437=((`vamos`~(-49115664))/1000)
    local t72046414=vector2((-0.84283)+t33114437,(-1.225585)+t33114437)
    local t84247335=vector2(0.697048-t33114437,1.482726-t33114437)
    local t78384674=t34196728[_G["GetEntityModel"] (t43068463)] 
    local t82497378=_G["GetOffsetFromEntityInWorldCoords"] (t43068463,t72046414["x"] +t78384674["x"] ,t72046414["y"] +t78384674["y"] ,(((`cyclone`|`bf400`)~1476376110)/100)+((`asea`~(-1809822328))/100))
    local t13023464=_G["GetOffsetFromEntityInWorldCoords"] (t43068463,t84247335["x"] +t78384674["x"] ,t72046414["y"] +t78384674["y"] ,(((`exemplar`|`neo`)~(-8281))/100)+(((`vacca`|`savestra`)~905895390)/100))
    local t94259286=_G["GetOffsetFromEntityInWorldCoords"] (t43068463,t84247335["x"] +t78384674["x"] ,t84247335["y"] +t78384674["y"] ,((`asea`~(-1809822256))/100)+(((`caracara2`|`issi3`)~(-1080655876))/100))
    local t55464501=_G["GetOffsetFromEntityInWorldCoords"] (t43068463,t72046414["x"] +t78384674["x"] ,t84247335["y"] +t78384674["y"] ,(((`comet3`|`faggio`)~(-1753482058))/100)+((`t20`~1663218587)/100))
    local t37050317={{t82497378,t13023464},{t13023464,t94259286},{t94259286,t55464501},{t55464501,t82497378}}
    
    Citizen["CreateThread"] (function()
        local t5926077=_G["GetGameTimer"] ()
        while t7697375==t18626986 do 
            _G["Wait"] ((`chino`~349605904))_G["DisableAllControlActions"] ((`infernus2`~(-1405937764)))_G["EnableControlAction"] ((`freecrawler`~(-54332285)),((`nemesis`|`prairie`)~(-72822001)),((t53113949==t80180361)==(t45251336==t26023147)))t53815151=_G["GetEntityCoords"] (t78921246["entity"] )_G["SetCamCoord"] (t46528744,t53815151["x"] ,t53815151["y"] ,t53815151["z"] +t8697351)
            local t82472988=(((`windsor`|`prairie`)~(-3409941))/1)
            if _G["IsControlPressed"] (((`dynasty`|`tyrant`)~(-67202601)),t61549719(Config["Keys"] ["AIM_SLOWER"] ["code"] )) or _G["IsDisabledControlPressed"] ((`hustler`~600450546),t61549719(Config["Keys"] ["AIM_SLOWER"] ["code"] )) then 
                t82472988=(((`khamelion`|`buccaneer`)~(-142647442))/10)
            end 
            if _G["IsControlPressed"] (((`schwarzer`|`manchez`)~(-142902402)),t61549719(Config["Keys"] ["BALL_IN_HAND_LEFT"] ["code"] )) or _G["IsDisabledControlPressed"] ((`sentinel3`~1104234922),t61549719(Config["Keys"] ["BALL_IN_HAND_LEFT"] ["code"] )) then 
                local t81790078=vector2(math["cos"] (math["rad"] (t81463867+((`seminole`~1221512807)/1))),math["sin"] (math["rad"] (t81463867+(((`habanero`|`manana`)~(-1242072773))/1))))*t82472988 
                local t10364993=t78921246["position"] +t81790078*_G["GetFrameTime"] ()
                if not t66705081(t37050317,t10364993) and not t1197534(t78921246["entity"] ,t10364993,t99667691[t93314187] ["balls"] ) then 
                    t78921246["position"] =t10364993 
                end 
            end 
            if _G["IsControlPressed"] ((`zhaba`~1284356689),t61549719(Config["Keys"] ["BALL_IN_HAND_RIGHT"] ["code"] )) or _G["IsDisabledControlPressed"] ((`furia`~960812448),t61549719(Config["Keys"] ["BALL_IN_HAND_RIGHT"] ["code"] )) then 
                local t81790078=vector2(math["cos"] (math["rad"] (t81463867+(((`torero`|`daemon`)~2143022410)/1))),math["sin"] (math["rad"] (t81463867+(((`deveste`|`reaper`)~1609794891)/1))))*t82472988 
                local t10364993=t78921246["position"] -t81790078*_G["GetFrameTime"] ()
                if not t66705081(t37050317,t10364993) and not t1197534(t78921246["entity"] ,t10364993,t99667691[t93314187] ["balls"] ) then 
                    t78921246["position"] =t10364993 
                end 
            end 
            if _G["IsControlPressed"] ((`cogcabrio`~330661258),t61549719(Config["Keys"] ["BALL_IN_HAND_UP"] ["code"] )) or _G["IsDisabledControlPressed"] ((`italigto`~(-331467772)),t61549719(Config["Keys"] ["BALL_IN_HAND_UP"] ["code"] )) then 
                local t81790078=vector2(math["cos"] (math["rad"] (t81463867+(((`hexer`|`vacca`)~369061219)/1)+((`deveste`~1591739776)/1))),math["sin"] (math["rad"] (t81463867+(((`seven70`|`sanchez`)~(-1074159877))/1)+(((`penetrator`|`tailgater`)~(-671219788))/1))))*t82472988 
                local t10364993=t78921246["position"] -t81790078*_G["GetFrameTime"] ()
                if not t66705081(t37050317,t10364993) and not t1197534(t78921246["entity"] ,t10364993,t99667691[t93314187] ["balls"] ) then 
                    t78921246["position"] =t10364993 
                end 
            end 
            if _G["IsControlPressed"] (((`vstr`|`cog55`)~1993338879),t61549719(Config["Keys"] ["BALL_IN_HAND_DOWN"] ["code"] )) or _G["IsDisabledControlPressed"] (((`paragon`|`baller2`)~(-304775329)),t61549719(Config["Keys"] ["BALL_IN_HAND_DOWN"] ["code"] )) then 
                local t81790078=vector2(math["cos"] (math["rad"] (t81463867+(((`schafter3`|`seven70`)~(-1216495781))/1)+(((`entity2`|`asea`)~(-1783042169))/1))),math["sin"] (math["rad"] (t81463867+((`vstr`~1456336585)/1)+((`primo`~(-1150599147))/1))))*t82472988 
                local t10364993=t78921246["position"] +t81790078*_G["GetFrameTime"] ()
                if not t66705081(t37050317,t10364993) and not t1197534(t78921246["entity"] ,t10364993,t99667691[t93314187] ["balls"] ) then 
                    t78921246["position"] =t10364993 
                end 
            end 
            local t14224655=_G["GetGameTimer"] ()
            if (t14224655-t5926077)>((`sandking2`|`asbo`)~2063395499) then 
                TriggerServerEvent("mercy-pool:setBallInHandData",t93314187,t78921246["position"] )t5926077=t14224655 
            end 
            if _G["IsControlPressed"] (((`sultan`|`neo`)~(-1073809418)),t61549719(Config["Keys"] ["BACK"] ["code"] )) or _G["IsDisabledControlPressed"] (((`buccaneer2`|`sabregt`)~(-610795556)),t61549719(Config["Keys"] ["BACK"] ["code"] )) or _G["IsControlJustPressed"] (((`krieger`|`defiler`)~(-117505065)),t61549719(Config["Keys"] ["BALL_IN_HAND"] ["code"] )) or _G["IsDisabledControlJustPressed"] ((`locust`~(-941272559)),t61549719(Config["Keys"] ["BALL_IN_HAND"] ["code"] )) then 
                t7697375=t69750738 t5020611()t65186825(t46528744)_G["DestroyCam"] (t46528744)t46528744=(t61781420 or t53403576)
            end 
        end 
    end )
end 
t42419088=((t32123608==t33806494)==(t70208044 and t21956173))t65186825=function(fromCam)
    local t18172729=_G["GetHashKey"] ("prop_pool_cue")t86283871=_G["CreateObject"] (t18172729,vector3((((`emerus`|`rancherxl`)~1861733365)/1),(((`gargoyle`|`rumpo`)~1836037997)/1),(((`chino`|`coquette`)~385863735)/1)),t42419088,((t77259701==t49333554)==(t60369869 and t70985464)),((t81750445==t49580499)==(t11636303 and t81963854)))_G["SetEntityCollision"] (t86283871,((t93350772==t65574011)==(t57302871 and t24773178)),((t42056292==t39092950)==(t27907247 and t91591668)))
    local t43068463=t99667691[t93314187] ["entity"] 
    local t14319165=t35419259 
    local t54293798=((t50303042==t70174508)==(t1298141 and t34696716))
    local t19001977=_G["GetGameTimer"] ()t11672888()
    local t10639376=t99667691[t93314187] ["balls"] [t99667691[t93314187] ["cueBallIdx"] ] 
    local t9441235=_G["GetEntityCoords"] (t10639376["entity"] )
    local t50107925=t41647766(t9441235)t90134387=_G["CreateCam"] ("DEFAULT_SCRIPTED_CAMERA",((`surge`|`surano`)~(-1611760172)))
    local t92149581=vector3(math["cos"] (math["rad"] (t50107925)),math["sin"] (math["rad"] (t50107925)),((`ingot`~(-1289722224))/100))
    local t96664715=t9441235+t92149581*(((`avarus`|`cog55`)~(-1209282569))/10)_G["SetCamCoord"] (t90134387,t96664715["x"] ,t96664715["y"] ,t96664715["z"] +(((`huntley`|`riata`)~(-1113131306))/10))_G["PointCamAtCoord"] (t90134387,t9441235["x"] ,t9441235["y"] ,t9441235["z"] )
    if fromCam then 
        _G["SetCamActiveWithInterp"] (t90134387,fromCam,((`savestra`|`sc1`)~1977611829),((`faggio`|`sultanrs`)~(-26614517)),(`fcr`~627535707))_G["Wait"] (((`rumpo3`|`felon2`)~(-31737)))
    else 
        _G["SetCamActive"] (t90134387,((t92006292==t84573547)==(t49995123==t63430770)))_G["RenderScriptCams"] (((t27827981==t69951953)==(t39644766==t86408868)),((t95701324==t17252020)==(t58921734 and t2709692)),(`asea`~(-1809822327)),((t53086511==t42257507)==(t47547012==t81030950)),((t79085876==t98631130)==(t20282434 and t456698)))
    end 
    local t70640960=(t18267239 or t61104608)
    local t96722640=(t79628546 or t23666497)
    local t93042852=(t19416601 or t19575134)
    local t74683544=(t95457427 or t72421405)
    Citizen["CreateThread"] (function()
        while t7697375==t69750738 do 
            _G["Wait"] ((`carbonrs`~11251904))_G["DisableAllControlActions"] ((`dominator2`~(-915704871)))_G["EnableControlAction"] (((`zentorno`|`banshee`)~(-302121513)),(`gt500`~(-2079788093)),((t74753665==t75460964)==(t78671252==t17678839)))
            local t84655862=(math["sin"] (t14319165)+((`superd`~1123216663)/1))/((`sc1`|`sentinel3`)~1373109673)
            local t40541085=vector3(math["cos"] (math["rad"] (t50107925)),math["sin"] (math["rad"] (t50107925)),((`sultanrs`~(-295689026))/100))
            local t14648425=t9441235+t40541085*(((`cognoscenti`|`bodhi2`)~(-1358980098))/10)*((((`cheetah2`|`ztype`)~763354956)/1)+((`youga`~65402555)/10)*t84655862)
            local t96664715=t9441235+t40541085*((`jackal`~(-624529126))/10)
            local t20660473=_G["GetEntityCoords"] (t86283871)
            if #(t20660473-t14648425)>((`blista`~(-344943010))/10000) then 
                _G["SetEntityCoordsNoOffset"] (t86283871,t14648425["x"] ,t14648425["y"] ,t14648425["z"] ,((t11282653==t80506573)==(t28242605 and t51053024)),((t37217996==t7953466)==(t78930392 and t54348675)),((t98405526==t97576278)==(t28718203 and t30751690)))_G["SetEntityRotation"] (t86283871,(((`huntley`|`bfinjection`)~1596913597)/1),t50107925-((`comet3`~(-2022483721))/1),(((`manchez`|`baller`)~(-268798344))/1),(`retinue2`~2031587080),((t45848883==t65903271)==(t72281164==t14822201)))_G["SetCamCoord"] (t90134387,t96664715["x"] ,t96664715["y"] ,t96664715["z"] +(((`torero`|`ninef2`)~(-101978252))/10))_G["PointCamAtCoord"] (t90134387,t9441235["x"] ,t9441235["y"] ,t9441235["z"] )
            end 
            if _G["IsControlJustPressed"] ((`carbonizzare`~2072687711),t61549719(Config["Keys"] ["BALL_IN_HAND"] ["code"] )) or _G["IsDisabledControlJustPressed"] ((`kanjo`~409049982),t61549719(Config["Keys"] ["BALL_IN_HAND"] ["code"] )) then 
                t7697375=t18626986 t11374114(t50107925+((`rapidgt3`~2049897918)/1))
                break 
            end 
            local t14224655=_G["GetGameTimer"] ()
            if not Config["DoNotRotateAroundTableWhenAiming"]  and (t14224655-t19001977)>(((`alpha`|`tempesta`)~1039979035)/1) then 
                t19001977=t14224655 
                local t8584548=(t9441235["xy"] -t14648425["xy"] )
                local t58769299=math["atan2"] (t8584548["y"] ,t8584548["x"] )
                local t79957806=math["deg"] (t58769299)-((`asea`~(-1809822403))/1)
                local t4651718=t17276409(t43068463,t10639376["entity"] ,t79957806)
                local t53964538=_G["PlayerPedId"] ()
                local t13465527=_G["GetEntityCoords"] (t53964538)
                if (#(t13465527-t4651718)>((`cyclone`~1392481333)/10)) then 
                    _G["SetEntityCoordsNoOffset"] (t53964538,t4651718["x"] ,t4651718["y"] ,t4651718["z"] ,((t67988586==t19630010)==(t21288507 and t26428625)),((t92213604==t65824005)==(t36714959 and t84155874)),((t6801055==t58150411)==(t54019415 and t44123315)))_G["SetEntityHeading"] (t53964538,t79957806+(((`riata`|`zion2`)~(-1125716479))/1))t11672888()
                end 
            end 
            if not t54293798 then 
                local t92335552=((`primo2`~(-2040426789))/1)
                if _G["IsControlPressed"] ((`bf400`~86520421),t61549719(Config["Keys"] ["AIM_SLOWER"] ["code"] )) or _G["IsDisabledControlPressed"] (((`swinger`|`penetrator`)~(-1611336705)),t61549719(Config["Keys"] ["AIM_SLOWER"] ["code"] )) then 
                    t92335552=(((`tampa`|`gb200`)~2046552725)/100)
                end 
                if _G["IsControlPressed"] (((`outlaw`|`casco`)~947830783),t61549719(Config["Keys"] ["CUE_LEFT"] ["code"] )) or _G["IsDisabledControlPressed"] (((`sentinel`|`zion3`)~2138291943),t61549719(Config["Keys"] ["CUE_LEFT"] ["code"] )) then 
                    t50107925=t50107925-t92335552 
                elseif _G["IsControlPressed"] (((`ztype`|`tailgater`)~(-268436017)),t61549719(Config["Keys"] ["CUE_RIGHT"] ["code"] )) or _G["IsDisabledControlPressed"] (((`voltic`|`baller4`)~(-1077151746)),t61549719(Config["Keys"] ["CUE_RIGHT"] ["code"] )) then 
                    t50107925=t50107925+t92335552 
                elseif _G["IsControlJustPressed"] (((`reaper`|`novak`)~(-1611168785)),t61549719(Config["Keys"] ["CUE_HIT"] ["code"] )) or _G["IsDisabledControlJustPressed"] ((`fcr`~627535535),t61549719(Config["Keys"] ["CUE_HIT"] ["code"] )) then 
                    t54293798=((t7172998==t69110510)==(t27257873==t78939538))
                elseif _G["IsControlJustPressed"] ((`t20`~1663218586),t61549719(Config["Keys"] ["BACK"] ["code"] )) or _G["IsDisabledControlJustPressed"] ((`michelli`~1046206681),t61549719(Config["Keys"] ["BACK"] ["code"] )) then 
                    t7697375=t10935101 
                    TriggerServerEvent("mercy-pool:releaseControl",t93314187)t5020611()
                end 
            elseif t54293798 then 
                if _G["IsControlJustPressed"] (((`windsor`|`huntley`)~1598552009),t61549719(Config["Keys"] ["CUE_HIT"] ["code"] )) or _G["IsDisabledControlJustPressed"] (((`bison`|`sandking2`)~(-16914609)),t61549719(Config["Keys"] ["CUE_HIT"] ["code"] )) then 
                    t54293798=((t20602548==t30501696)==(t71134851 and t64232580))
                    local t70137924=math["min"] (((`bodhi2`~(-1435919433))/1),math["max"] (((`schafter4`~1489967196)/1),math["tan"] (t84655862)/(((`baller3`|`penetrator`)~(-722976))/10)))t70640960=t70137924 t96722640=(t9441235["xy"] -t14648425["xy"] )*(`toros`~(-1168952157))*t70137924 t93042852=t40541085*((`entityxf`~(-1291952911))/10)t74683544=t84655862 t14319165=t35419259 
                    break 
                elseif _G["IsControlJustPressed"] (((`dominator3`|`sentinel3`)~(-973247557)),t61549719(Config["Keys"] ["BACK"] ["code"] )) or _G["IsDisabledControlJustPressed"] (((`sanchez`|`gp1`)~1878695790),t61549719(Config["Keys"] ["BACK"] ["code"] )) then 
                    t54293798=((t10706448==t31224240)==(t29623669 and t86107046))t14319165=t35419259 t5020611()
                end t14319165=t14319165+((`komoda`~(-834353990))/100)
            end 
        end 
        if not t46528744 then 
            _G["SetGameplayCoordHint"] (_G["GetEntityCoords"] (t43068463)+vector3(((`swinger`~500482303)/1),(((`stanier`|`windsor2`)~(-1342312467))/1),(((`sabregt`|`hotknife`)~(-1682309231))/10)),((`drafter`|`sentinel`)~2029763727),(`flashgt`~(-1259134695)),((`speedo`|`elegy`)~(-809785492)),((`savestra`|`zion3`)~2145377023))_G["Wait"] (((`bati`|`zombiea`)~(-67645757)))_G["RenderScriptCams"] (((t15992904==t14337457)==(t47659814 and t37214947)),((t25492672==t62757006)==(t76137777 and t15343530)),((`jackal`|`gauntlet`)~(-554175017)),((t44220874==t15526452)==(t86567401==t91582522)),((t51931051==t3679180)==(t24440869 and t63067974)))_G["DestroyCam"] (t90134387,((t8105902==t48147607)==(t78906002 and t55086462)))
        end 
        if t70640960 then 
            _G["Wait"] (((`tornado`|`hellion`)~(-67463513)))
            while t74683544>((`vagrant`|`rancherxl`)~1847585721) do 
                _G["Wait"] ((`bf400`~86520421))t74683544=t74683544-(((`fq2`|`rumpo`)~(-42748043))/1)*_G["GetFrameTime"] ()
                local t50336578=t9441235+t93042852*((((`fugitive`|`sabregt2`)~2110763002)/1)+(((`locust`|`raiden`)~(-402793602))/10)*t74683544)_G["SetEntityCoordsNoOffset"] (t86283871,t50336578["x"] ,t50336578["y"] ,t50336578["z"] ,((t6194363==t9099780)==(t98000048 and t90015487)),((t27163363==t25730471)==(t87292993 and t20312921)),((t48571377==t90387429)==(t10297921 and t87896636)))
            end 
            TriggerServerEvent("mercy-pool:syncCueBallVelocity",t93314187,t10639376["position"] ,t96722640,t70640960)_G["Wait"] ((`felon`~(-391594916)))
        end 
        _G["DeleteObject"] (t86283871)t86283871=(t73207971 or t22889077)_G["Wait"] ((`revolter`~(-410206159)))t15800836()
    end )
end 

t41647766=function(t9441235)
    local t68525158=_G["PlayerPedId"] ()
    local t13465527=_G["GetEntityCoords"] (t68525158)
    local t31553500=t13465527-t9441235 
    local t58769299=math["atan2"] (t31553500["y"] ,t31553500["x"] )
    local t79957806=math["deg"] (t58769299)
    return t79957806 
end 

t5020611=function()
    local t54949270=((t25928637==t5505355)==(t17322140==t30654132))
    
    Citizen["CreateThreadNow"] (function()
        while _G["IsControlPressed"] ((`gb200`~1909189272),(`peyote`~1830407284)) do 
            _G["Wait"] (((`buffalo`|`rebel2`)~(-271075633)))
        end _G["Wait"] ((`elegy`~196748181))t54949270=((t93051998==t1362164)==(t30641937 and t8532720))
    end )
    Citizen["CreateThreadNow"] (function()
        while t54949270 do 
            _G["SetPauseMenuActive"] (((t44431234==t59766226)==(t12005197 and t77784078)))_G["Wait"] (((`schafter4`|`revolter`)~(-3154979)))
        end 
    end )
end 

RegisterNetEvent("lsrp_pool:forceStopControl")
AddEventHandler("lsrp_pool:forceStopControl",function()
    if t7697375==t69750738 or t7697375==t18626986 then 
        t7697375=t10935101 TriggerServerEvent("mercy-pool:releaseControl",t93314187)
    end 
end )

t79899880=function(t14044781)
    return t14044781*t14044781 
end 

t45669009=function(v,w)
    return t79899880(v["x"] -w["x"] )+t79899880(v["y"] -w["y"] ) 
end 

t80299261=function(p,v,w)
    local t69134899=t45669009(v,w)
    if (t69134899==(`baller4`~634118882)) then 
        return t45669009(p,v) 
    end 
    local t8965637=((p["x"] -v["x"] )*(w["x"] -v["x"] )+(p["y"] -v["y"] )*(w["y"] -v["y"] ))/t69134899 
    local t8965637=math["max"] (((`tampa`|`kanjo`)~972676094),math["min"] ((`italigtb2`~(-482719878)),t8965637))
    return t45669009(p,vector2(v["x"] +t8965637*(w["x"] -v["x"] ),v["y"] +t8965637*(w["y"] -v["y"] ))) 
end 

t66705081=function(colliders,position)
    for t18950149,collider in pairs(colliders) do 
        local t45669009=t80299261(position,collider[(`taipan`~(-1134706561))] ,collider[(`habanero`~884422925)] )
        local t24483551=t81994342*t81994342 
        local t20559866=t45669009-t24483551 
        if t20559866<(((`wolfsbane`|`vamos`)~(-13455361))/1) then 
            return ((t50232922==t65744738)==(t40391699==t87783834)) 
        end 
    end 
    return ((t76820687==t29968173)==(t17520306 and t42236166)) 
end 

t86500329=function(colliderStart,colliderEnd,ball,handlePhysics)
    local t89616107=ball["position"] 
    local t45669009=t80299261(t89616107,colliderStart,colliderEnd)
    local t24483551=t81994342*t81994342 
    local t20559866=t45669009-t24483551 
    if t20559866<((`felon2`~(-89291282))/1) then 
        local t35440600=ball["velocity"] /t70418405 ball["position"] =ball["position"] -t35440600/#t35440600*(t81994342-math["sqrt"] (t45669009)+((`buffalo`~(-304802105))/1000))
        local t91899588=colliderStart["x"] -colliderEnd["x"] 
        local t7102877=colliderEnd["y"] -colliderStart["y"] 
        local t95009268=math["sqrt"] (t7102877*t7102877+t91899588*t91899588)t7102877=t7102877/t95009268 t91899588=t91899588/t95009268 
        local t54583425=ball["velocity"] ["x"] 
        local t84643667=ball["velocity"] ["y"] 
        local t9874151=(t54583425*t7102877)+(t84643667*t91899588)
        local t80558401=t9874151*t7102877 
        local t47556158=t9874151*t91899588 
        local t92844686=t54583425-(t80558401*(`seminole`~1221512913))
        local t37309457=t84643667-(t47556158*(`cheetah2`~223240015))
        if handlePhysics then 
            ball["velocity"] =vector2(t92844686,t37309457)*t47821395 t2005441(ball["entity"] ,math["min"] ((((`vstr`|`sandking`)~(-1183748))/1),math["max"] ((((`hustler`|`monroe`)~(-404015109))/1),#ball["velocity"] /(((`baller2`|`penumbra`)~(-377127587))/1))))
        end 
    end 
end 

t18200167=function(entity,t3746252)
    local t12752130=(((`baller2`|`deviant`)~1287651076)/100)
    local t72046414=vector2((-0.84283),(-1.225585))
    local t84247335=vector2(0.697048,1.482726)
    local t78384674=t34196728[t3746252] 
    local t28340164={[_G["GetHashKey"] ("prop_pooltable_02")]={{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +(((`massacro`|`torero`)~(-262279))/100),t72046414["y"] +((`massacro`~(-142942629))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -((`stromberg`~886810218)/100),t72046414["y"] +(((`novak`|`lynx`)~(-1627536602))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -((`double`~(-1670998141))/100),t72046414["y"] +(((`rocoto`|`dilettante`)~(-2247280))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -(((`reaper`|`granger`)~(-1610906168))/10000),t72046414["y"] -((`gauntlet4`~1934384917)/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +(((`gresley`|`monroe`)~(-402702998))/10000),t72046414["y"] -((`jester`~(-1297672218))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +((`tailgater`~(-1008861755))/100),t72046414["y"] +((`washington`~1777363774)/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -(((`sabregt2`|`pony`)~(-35737690))/1000),t72046414["y"] +0.112,t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -(((`rebel`|`sugoi`)~(-1159995565))/1000),(((`cognoscenti`|`dukes`)~(-1342242949))/1000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +((`hermes`~15219732)/100),t72046414["y"] +((`manchez`~(-1523429299))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -((`turismor`~408192236)/1000),t72046414["y"] +0.112,t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -((`wolfsbane`~(-618617986))/1000),((`taipan`~(-1134706573))/1000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +(((`monroe`|`sabregt2`)~(-277891580))/1000),(((`zhaba`|`asterope`)~(-828375858))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -(((`drafter`|`carbonrs`)~686536898)/1000),t72046414["y"] +0.112+(((`sabregt`|`zion`)~(-1080325944))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -((`sultan`~970598233)/1000),((`serrano`~1337041433)/1000)+(((`hermes`|`buffalo2`)~736889248)/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +((`blista`~(-344943040))/1000),t72046414["y"] +((`fusilade`~499169890)/1000)+1.379,t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -(((`pariah`|`seven70`)~(-1212575770))/1000),t72046414["y"] +0.112+(((`voodoo`|`dukes`)~2143275616)/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -((`everon`~(-1756021723))/1000),((`emperor`~(-685276530))/1000)+((`italigto`~(-331480805))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +(((`furia`|`hotknife`)~998111155)/100),(((`swinger`|`jackal`)~(-539561542))/1000)+(((`emerus`|`regina`)~(-1579454))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +((`vortex`~(-609625203))/1000),t84247335["y"] -((`coquette3`~784565751)/1000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -((`impaler`~(-2096689391))/10000),t84247335["y"] -((`issi7`~1854776574)/1000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +((`ruiner`~(-227742260))/10000),t84247335["y"] +((`banshee`~(-1041692259))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +((`tampa`~972671209)/1000),t84247335["y"] -(((`landstalker`|`pariah`)~2076045303)/1000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -(((`regina`|`gresley`)~(-74946))/10000),t84247335["y"] -(((`diablous`|`gresley`)~(-201568444))/1000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] -0.058,t84247335["y"] +(((`locust`|`mesa`)~(-135932367))/1000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +0.011,t72046414["y"] +(((`stinger`|`bf400`)~1563147176)/10000)+((`gauntlet3`~722237650)/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +0.011,((`rocoto`~2136773116)/1000)+((`baller2`~142941514)/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] -(((`chino`|`yosemite`)~2144793177)/1000),t72046414["y"] +0.0682+((`sultanrs`~(-295693917))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +0.011,t72046414["y"] +(((`drafter`|`paragon`)~(-302318840))/10000)+((`rapidgt2`~1737778608)/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +0.011,(((`buffalo2`|`entity2`)~(-1409499405))/1000)+((`sadler`~(-599557298))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] -(((`voodoo`|`dukes`)~2143289183)/1000),(((`dominator3`|`retinue2`)~(-46141474))/1000)+((`lectro`~640822136)/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +0.011,t72046414["y"] +((`vamos`~(-49116758))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +0.011,(((`hermes`|`pfister811`)~(-1829798254))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] -(((`furoregt`|`nero`)~(-1078529085))/1000),t72046414["y"] +0.056,t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +0.011,t72046414["y"] +(((`schwarzer`|`serrano`)~(-537133279))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +0.011,((`pony`~(-119658195))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] -(((`torero`|`ruffian`)~(-608307752))/1000),0.056,t12752130)}},[_G["GetHashKey"] ("prop_pooltable_3b")]={{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +(((`avarus`|`italigtb2`)~(-470036620))/100),t72046414["y"] +t78384674["y"] +((`avarus`~(-2115793130))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -((`entity2`~(-2120700201))/100),t72046414["y"] +t78384674["y"] +((`manchez`~(-1523428847))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -((`sanchez`~788045389)/100),t72046414["y"] +t78384674["y"] +((`vacca`~338562474)/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -(((`monroe`|`superd`)~(-419693270))/10000),t72046414["y"] +t78384674["y"] -(((`feltzer3`|`stalion`)~(-222433701))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +((`sultan`~970597729)/10000),t72046414["y"] +t78384674["y"] -(((`dilettante`|`issi7`)~(-23219014))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +(((`hexer`|`emperor2`)~(-1611141417))/100),t72046414["y"] +t78384674["y"] +(((`manana`|`serrano`)~(-806099979))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -((`baller`~(-808831387))/1000),t72046414["y"] +t78384674["y"] +0.112,t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -(((`sanchez`|`caracara2`)~(-1342242957))/1000),((`penumbra`~(-377465507))/1000)+t78384674["y"] ,t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] +(((`baller`|`ninef`)~(-3164545))/100),t72046414["y"] +t78384674["y"] +((`rhapsody`~841808826)/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -(((`sandking`|`banshee`)~(-102166561))/1000),t72046414["y"] +t78384674["y"] +0.112,t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -((`ztype`~758895628)/1000),(((`mesa`|`stinger`)~2124918678)/1000)+t78384674["y"] ,t12752130), _G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] +(((`pcj`|`stalion`)~(-68227327))/1000),(((`gp1`|`sultan2`)~2107013961)/10000)+t78384674["y"] ,t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -(((`huntley`|`surfer`)~1035394714)/1000),t72046414["y"] +t78384674["y"] +0.112+(((`baller3`|`futo`)~2146880048)/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -(((`hellion`|`phoenix`)~(-344316430))/1000),(((`verlierer2`|`monroe`)~(-406880334))/1000)+t78384674["y"] +(((`clique`|`baller4`)~(-1478504467))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] +((`zentorno`~(-1403128566))/1000),t72046414["y"] +t78384674["y"] +(((`cheetah`|`turismo2`)~(-167911552))/1000)+1.379,t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -(((`stromberg`|`asbo`)~1996468082)/1000),t72046414["y"] +t78384674["y"] +0.112+(((`issi3`|`serrano`)~2142471146)/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -(((`bf400`|`moonbeam2`)~1965702130)/1000),((`pony`~(-119658075))/1000)+t78384674["y"] +((`deviant`~1279248982)/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] +((`nightblade`~(-1606187164))/100),((`tezeract`~1031562325)/1000)+t78384674["y"] +(((`fagaloa`|`clique`)~(-486553431))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +(((`coquette3`|`furoregt`)~(-1076390513))/1000),t84247335["y"] +t78384674["y"] -(((`penetrator`|`gauntlet`)~(-1749551130))/1000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -(((`nightshade`|`primo`)~(-1083452244))/10000),t84247335["y"] +t78384674["y"] -(((`rancherxl`|`burrito3`)~(-99099654))/1000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +(((`monroe`|`coquette3`)~(-286542390))/10000),t84247335["y"] +t78384674["y"] +(((`superd`|`rebla`)~1190588057)/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +(((`prairie`|`penumbra`)~(-376907901))/1000),t84247335["y"] +t78384674["y"] -(((`vortex`|`banshee2`)~(-1179658))/1000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -((`elegy2`~(-566388399))/10000),t84247335["y"] +t78384674["y"] -(((`emperor2`|`sanchez`)~(-1342456105))/1000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] -0.058,t84247335["y"] +t78384674["y"] +((`entity2`~(-2120700162))/1000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +0.011,t72046414["y"] +t78384674["y"] +(((`savestra`|`peyote2`)~(-1241589334))/10000)+((`thrax`~1044195910)/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +0.011,(((`issi3`|`premier`)~(-1078558730))/1000)+t78384674["y"] +((`peyote2`~(-1804404677))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] -((`cognoscenti`~(-2030171328))/1000),t72046414["y"] +t78384674["y"] +0.0682+((`rumpo3`~1475786672)/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +0.011,t72046414["y"] +t78384674["y"] +(((`rapidgt3`|`panto`)~(-26283597))/10000)+(((`elegy2`|`gt500`)~(-566375899))/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +0.011,((`vagner`~1939284545)/1000)+t78384674["y"] +(((`faggio`|`flashgt`)~(-1225010972))/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] -(((`schafter2`|`picador`)~(-34866221))/1000),((`enduro`~1753414198)/1000)+t78384674["y"] +((`fagaloa`~1617467545)/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +0.011,t72046414["y"] +t78384674["y"] +((`peyote`~1830406379)/10000),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +0.011,((`voltic`~(-1622444229))/10000)+t78384674["y"] ,t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] -(((`dukes`|`t20`)~1797715966)/1000),t72046414["y"] +t78384674["y"] +0.056,t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +0.011,t72046414["y"] +t78384674["y"] +((`seminole`~1221511812)/10000),t12752130)},{_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] +0.011,(((`sentinel`|`retinue2`)~2037886735)/10000)+t78384674["y"] ,t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] -((`toros`~(-1168952180))/1000),0.056+t78384674["y"] ,t12752130)}}}
    return t28340164[t3746252]  
end

t94430014=((t36565573==t20340359)==(t2057269==t79771835))t75000610=(`t20`~1663229084)t92512377=vector3(((`gauntlet3`~722226635)/100),(((`sandking`|`elegy`)~(-1145360396))/100),((`tezeract`~1031562256)/1))t23724423=vector3(((`defiler`~(-822018476))/1),((`tampa`~972671128)/1),((`pfister811`~(-1829802492))/1))t45239141=vector3((((`gauntlet`|`baller4`)~1241778326)/1000),(-0.035),((`carbonizzare`~(-2072687681))/1000))t87204580=vector3(((`superd`~(-1123216647))/1),((`raiden`~(-1529242839))/1),(((`adder`|`wolfsbane`)~(-8805389))/1))t36836907=(t62260067 or t63750885)

Citizen["CreateThread"] (function()
    while ((t73256750==t70656204)==(t46894589==t24318920)) do 
        _G["Wait"] ((`burrito3`~(-1743318041)))
        if t36836907 and t67357504 then 
            local t68525158=_G["PlayerPedId"] ()
            local t20224508=_G["GetEntityCoords"] (t68525158)
            if #(t20224508-t36836907)>(((`faggio`|`picador`)~(-605421585))/1) then 
                t82427258()
            end 
        end 
    end 
end )

RegisterNetEvent("mercy-pool:takeCue")
AddEventHandler("mercy-pool:takeCue",function()
    if not hasCue then 
        t24916467()
    end 
end )

RegisterNetEvent("mercy-pool:removeCue")
AddEventHandler("mercy-pool:removeCue",function()
    t82427258()
end )

t24916467=function()
    local t68525158=_G["PlayerPedId"] ()
    local t13465527=_G["GetEntityCoords"] (t68525158)t36836907=t13465527 
    hasCue=true
    t67357504=_G["CreateObject"] (_G["GetHashKey"] ("prop_pool_cue"),t13465527["x"] ,t13465527["y"] ,t13465527["z"] ,t94430014,((t39556353==t89216726)==(t40983148==t86704592)),((t86247286==t8361993)==(t36620449 and t49370138)))_G["SetEntityCollision"] (t67357504,((t25791445==t79784030)==(t36089974 and t57751031)),((t34358309==t90530718)==(t81235214 and t29065756)))TriggerServerEvent("mercy-pool:internalPlayerHasTakenCue",_G["ObjToNet"] (t67357504),t13465527)t15800836()end 
    
    
    t82427258=function()
        
    hasCue=false
    _G["DeleteObject"] (t67357504)t67357504=(t55083413 or t84201605)TriggerServerEvent("mercy-pool:internalDeleteCue")end t15800836=function()local t68525158=_G["PlayerPedId"] ()_G["AttachEntityToEntity"] (t67357504,t68525158,_G["GetPedBoneIndex"] (t68525158,t75000610),t92512377["x"] ,t92512377["y"] ,t92512377["z"] ,t23724423["x"] ,t23724423["y"] ,t23724423["z"] ,((t35425357==t52690179)==(t78378576==t48617108)),((t5895590==t50815225)==(t55113900==t7041903)),((t59869882==t17063000)==(t24154290 and t39403918)),((t17306896==t62534451)==(t90097802==t66686788)),(`caracara2`~(-1349095619)),((t60293652==t55650473)==(t53004196==t25172558)))_G["ClearPedTasksImmediately"] (t68525158)_G["ResetEntityAlpha"] (t68525158)_G["ResetEntityAlpha"] (t67357504)end t11672888=function()local t68525158=_G["PlayerPedId"] ()local t26279238="anim@veh@sit_variations@dirt@front@idle_a"local t56912637="sit_low"t47489086(t26279238)_G["TaskPlayAnim"] (t68525158,t26279238,t56912637,((`blista2`~1039032018)/1),(((`peyote`|`novak`)~(-143626))/1),((`nightshade`|`xls`)~809771009),(`blista`~(-344943025))+(`stafford`~321186145),(`zion`~(-1122289213)),((`yosemite2`|`osiris`)~1995832823),((`faggio3`|`viseris`)~(-72828004)),(`pcj`~(-909201658)))_G["AttachEntityToEntity"] (t67357504,t68525158,_G["GetPedBoneIndex"] (t68525158,t75000610),t45239141["x"] ,t45239141["y"] ,t45239141["z"] ,t87204580["x"] ,t87204580["y"] ,t87204580["z"] ,((t22962246==t16605694)==(t35748519==t44794030)),((t67741641==t49181118)==(t1767642==t60281457)),((t66202044==t62811883)==(t1929223 and t32047390)),((t47803103==t87222872)==(t42315432==t5706570)),(`cheetah`~(-1311154783)),((t33797348==t33925393)==(t13060049==t88274676)))_G["SetEntityAlpha"] (t68525158,(((`sentinel2`|`emerus`)~2130177917)/1),((t21203143==t6538867)==(t68491622 and t69482452)))_G["SetEntityAlpha"] (t67357504,(((`peyote`|`sandking`)~(-46542852))/1),((t32519940==t14291726)==(t688400 and t96966537)))
end

t47757373=function(text)
    _G["BeginTextCommandScaleformString"] ("STRING")_G["AddTextComponentScaleform"] (text)_G["EndTextCommandScaleformString"] ()
end 

t57577255=function(ControlButton)
    _G["ScaleformMovieMethodAddParamPlayerNameString"] (ControlButton)
end 

t38644790=function(t41190460)
    local t41190460=_G["RequestScaleformMovie"] (t41190460)
    while not _G["HasScaleformMovieLoaded"] (t41190460) do 
        Citizen["Wait"] ((`monroe`~(-433375717)))
    end 
    _G["PushScaleformMovieFunction"] (t41190460,"CLEAR_ALL")_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_CLEAR_SPACE")_G["PushScaleformMovieFunctionParameterInt"] ((`imorgon`~(-1132721464)))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_DATA_SLOT")_G["PushScaleformMovieFunctionParameterInt"] ((`rapidgt3`~2049897953))t57577255(_G["GetControlInstructionalButton"] ((`kanjo`~409049980),t61549719(Config["Keys"] ["BACK"] ["code"] ),((t48803079==t46989099)==(t93908685==t51290823))))t47757373(t61549719(Config["Text"] ["BACK"] ))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_DATA_SLOT")_G["PushScaleformMovieFunctionParameterInt"] ((`bison`~(-16948149)))t57577255(_G["GetControlInstructionalButton"] (((`vagner`|`rhapsody`)~1941961677),t61549719(Config["Keys"] ["BALL_IN_HAND"] ["code"] ),((t66131924==t66171557)==(t66549597==t11011318))))t47757373(t61549719(Config["Text"] ["BALL_IN_HAND"] ))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_DATA_SLOT")_G["PushScaleformMovieFunctionParameterInt"] ((`cheburek`~(-988501277)))t57577255(_G["GetControlInstructionalButton"] (((`issi7`|`patriot`)~(-271585283)),t61549719(Config["Keys"] ["CUE_HIT"] ["code"] ),((t50059146==t39095999)==(t33574792==t74204898))))t47757373(t61549719(Config["Text"] ["HIT"] ))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_DATA_SLOT")_G["PushScaleformMovieFunctionParameterInt"] (((`buffalo`|`ingot`)~(-690476)))t57577255(_G["GetControlInstructionalButton"] (((`italigtb`|`jester3`)~(-134680727)),t61549719(Config["Keys"] ["CUE_LEFT"] ["code"] ),((t3779788==t39336846)==(t74210995==t52394454))))t47757373(t61549719(Config["Text"] ["AIM_LEFT"] ))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_DATA_SLOT")_G["PushScaleformMovieFunctionParameterInt"] ((`sabregt`~(-1685021547)))t57577255(_G["GetControlInstructionalButton"] ((`primo2`~(-2040426792)),t61549719(Config["Keys"] ["CUE_RIGHT"] ["code"] ),((t95317187==t5791934)==(t91826419==t26382894))))t47757373(t61549719(Config["Text"] ["AIM_RIGHT"] ))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_DATA_SLOT")_G["PushScaleformMovieFunctionParameterInt"] ((`jugular`~(-208911803)))t57577255(_G["GetControlInstructionalButton"] (((`seminole`|`outlaw`)~1491005425),t61549719(Config["Keys"] ["AIM_SLOWER"] ["code"] ),((t60275360==t48397601)==(t58107730==t25727423))))t47757373(t61549719(Config["Text"] ["AIM_SLOWER"] ))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"DRAW_INSTRUCTIONAL_BUTTONS")_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_BACKGROUND_COLOUR")_G["PushScaleformMovieFunctionParameterInt"] ((`comet2`~(-1045541610)))_G["PushScaleformMovieFunctionParameterInt"] ((`coquette3`~784565758))_G["PushScaleformMovieFunctionParameterInt"] ((`xa21`~917809321))_G["PushScaleformMovieFunctionParameterInt"] (((`guardian`|`gargoyle`)~(-1367425220)))_G["PopScaleformMovieFunctionVoid"] ()return t41190460 end t14608792=function(t41190460)local t41190460=_G["RequestScaleformMovie"] (t41190460)while not _G["HasScaleformMovieLoaded"] (t41190460) do Citizen["Wait"] ((`pfister811`~(-1829802492)))end _G["PushScaleformMovieFunction"] (t41190460,"CLEAR_ALL")_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_CLEAR_SPACE")_G["PushScaleformMovieFunctionParameterInt"] ((`xls`~1203490790))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_DATA_SLOT")_G["PushScaleformMovieFunctionParameterInt"] (((`specter`|`monroe`)~(-160481441)))t57577255(_G["GetControlInstructionalButton"] (((`carbonizzare`|`fugitive`)~2076950525),t61549719(Config["Keys"] ["BALL_IN_HAND_LEFT"] ["code"] ),((t26026196==t85954611)==(t63144192==t90847784))))t47757373(t61549719(Config["Text"] ["BALL_IN_HAND_LEFT"] ))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_DATA_SLOT")_G["PushScaleformMovieFunctionParameterInt"] ((`buffalo`~(-304802107)))t57577255(_G["GetControlInstructionalButton"] ((`tyrant`~(-376434240)),t61549719(Config["Keys"] ["BALL_IN_HAND_RIGHT"] ["code"] ),((t88125289==t30483404)==(t24596353==t59052828))))t47757373(t61549719(Config["Text"] ["BALL_IN_HAND_RIGHT"] ))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_DATA_SLOT")_G["PushScaleformMovieFunctionParameterInt"] (((`impaler`|`caracara2`)~(-1349030020)))t57577255(_G["GetControlInstructionalButton"] (((`vamos`|`voodoo`)~(-6565889)),t61549719(Config["Keys"] ["BALL_IN_HAND_UP"] ["code"] ),((t15691082==t84143679)==(t58156509==t64092340))))t47757373(t61549719(Config["Text"] ["BALL_IN_HAND_UP"] ))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_DATA_SLOT")_G["PushScaleformMovieFunctionParameterInt"] (((`paragon`|`exemplar`)~(-950434)))t57577255(_G["GetControlInstructionalButton"] ((`sabregt2`~223258113),t61549719(Config["Keys"] ["BALL_IN_HAND_DOWN"] ["code"] ),((t12965539==t65473403)==(t63799664==t91555084))))t47757373(t61549719(Config["Text"] ["BALL_IN_HAND_DOWN"] ))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_DATA_SLOT")_G["PushScaleformMovieFunctionParameterInt"] ((`blista`~(-344943009)))t57577255(_G["GetControlInstructionalButton"] ((`lectro`~640818789),t61549719(Config["Keys"] ["BALL_IN_HAND"] ["code"] ),((t17681887==t29507818)==(t79210873==t61851541))))t47757373(t61549719(Config["Text"] ["BALL_IN_HAND_BACK"] ))_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"DRAW_INSTRUCTIONAL_BUTTONS")_G["PopScaleformMovieFunctionVoid"] ()_G["PushScaleformMovieFunction"] (t41190460,"SET_BACKGROUND_COLOUR")_G["PushScaleformMovieFunctionParameterInt"] ((`monroe`~(-433375717)))_G["PushScaleformMovieFunctionParameterInt"] ((`mesa`~914654722))_G["PushScaleformMovieFunctionParameterInt"] (((`emerus`|`ruffian`)~(-822127619)))_G["PushScaleformMovieFunctionParameterInt"] (((`rapidgt3`|`vagner`)~2076178364))_G["PopScaleformMovieFunctionVoid"] ()
    return t41190460 
end

t61549719=function(t14044781)
    return t14044781 
end 

if not t61549719(Config["CustomMenu"] ) then 
    Citizen["CreateThread"] (function()
        t61549719(WarMenu)["CreateMenu"] 
        ("pool",t61549719(Config["Text"] ["POOL"] ),t61549719(Config["Text"] ["POOL_SUBMENU"] ) or "Select ball configuration")t61549719(WarMenu)["SetSubTitle"] ("pool",t61549719(Config["Text"] ["POOL_SUBMENU"] ) or "Select ball configuration")
        if t61549719(Config["MenuColor"] ) then 
            t61549719(WarMenu)["SetTitleBackgroundColor"] ("pool",t61549719(Config["MenuColor"] )[(`serrano`~1337041429)] ,t61549719(Config["MenuColor"] )[(`elegy`~196747875)] ,t61549719(Config["MenuColor"] )[((`voltic`|`zombiea`)~(-538970180))] )
        end 
        while ((t58909539==t68256872)==(t40065487==t38406991)) do 
            if t49360992 then 
                _G["Wait"] (((`cogcabrio`|`faggio2`)~334888363))
            else 
                _G["Wait"] (((`revolter`|`faggio`)~(-139599829)))
            end 
            if t61549719(WarMenu)["IsMenuOpened"] ("pool") then 
                if t93314187 then 
                    if t61549719(WarMenu)["Button"] (t61549719(Config["Text"] ["TYPE_8_BALL"] )) then 
                        TriggerEvent("mercy-pool:setupTable","BALL_SETUP_8_BALL")
                        t61549719(WarMenu)["CloseMenu"] ()
                    elseif t61549719(WarMenu)["Button"] (t61549719(Config["Text"] ["TYPE_STRAIGHT"] )) then 
                        TriggerEvent("mercy-pool:setupTable","BALL_SETUP_STRAIGHT_POOL")t61549719(WarMenu)["CloseMenu"] ()
                    end 
                    t61549719(WarMenu)["Display"] ()
                else t61549719(WarMenu)["CloseMenu"] ()
                end 
            else
                 _G["Wait"] ((`dukes`~723973278))
                end 
            end 
        end )
    end 
    
    AddEventHandler("mercy-pool:openMenu",function()
        t61549719(WarMenu)["OpenMenu"] ("pool")
    end )

    AddEventHandler("mercy-pool:closeMenu",function()
    end )

RegisterNetEvent("mercy-pool:cue", function()
    local Action = hasCue and "remove" or "take"
    print('[DEBUG]: Action: ', Action, 'hasCue: ', hasCue)
    TriggerEvent('mercy-pool:'..(Action)..'Cue')
end)

AddEventHandler("mercy-pool:setupTable",function(ballNumbers)
    local t46931173={["BALL_SETUP_8_BALL"]=BALL_SETUP_8_BALL,["BALL_SETUP_STRAIGHT_POOL"]=BALL_SETUP_STRAIGHT_POOL}

    if ballNumbers=="BALL_SETUP_8_BALL" or ballNumbers=="BALL_SETUP_STRAIGHT_POOL" then 
        if t99667691[t93314187] == nil then
            return exports['mercy-ui']:Notify('not-found', 'You are not near a table..', 'error')
        end
        local t43068463=t99667691[t93314187] ["entity"] 
        local t41778860=t44172094(t43068463, t46931173[ballNumbers])
        TriggerServerEvent("mercy-pool:setTableState",{["tablePosition"]=_G["GetEntityCoords"] (t43068463),["data"]=t41778860})
    else
        print("ERROR: Unknown ball configuration name. Supported names: BALL_SETUP_8_BALL, BALL_SETUP_STRAIGHT_POOL")
    end 
end )

Citizen["CreateThread"] (function()
    while ((t14306970==t4352944)==(t38745397==t32943710)) do 
        if t49360992 then 
            local t55315115=((`oracle2`|`monroe`)~(-408177131))
            local t74650009=((t74631716==t76287164)==(t41559353 and t33035171))
            local t50348773=_G["GetFrameTime"] ()
            local t70076950=math["max"] (((`cyclone`|`gargoyle`)~2130687798),tonumber(math["floor"] (t55315115*t50348773+((`vagner`~1939284553)/10))))
            for tableName,table in pairs(t99667691) do 
                if table["entity"]  then 
                    for i=(`kanjo`~409049983),t70076950 do 
                        local t76521914=t92067266(table,tableName)t74650009=t74650009 or t76521914 
                    end 
                end 
            end 
            if t74650009 then 
                _G["Wait"] (((`avarus`|`xls`)~(-939798657)))
            else 
                _G["Wait"] (((`kamacho`|`schafter2`)~(-34868789)))
            end 
        else 
            _G["Wait"] (((`tampa`|`entityxf`)~(-1140860635)))
        end 
    end 
end )

t92067266=function(table,tableName)
    local t94698300=((t53656619==t86774713)==(t11502160 and t87189337))
    local t47409820=((t94667813==t66098388)==(t25767056 and t9145510))
    for idx,ball in pairs(table["balls"] ) do 
        if not ball["disabled"]  then 
            if #ball["velocity"] >((`zombiea`~(-1009268946))/1000) then 
                t94698300=((t71037292==t2782861)==(t44101974==t93759298))t97582376(table,tableName,ball)
            else 
                ball["velocity"] =vector2((((`issi3`|`primo2`)~(-1209811205))/1),(((`pcj`|`zhaba`)~(-842023081))/1))
            end 
            if #ball["velocity"] >(((`hexer`|`schafter2`)~(-1241547497))/1) then 
                t47409820=((t24474404==t39845980)==(t11133267==t48546987))
                for t18950149,colliders in pairs(table["cushionColliders"] ) do 
                    t86500329(colliders[(`tyrant`~(-376434237))] ,colliders[((`faction`|`sentinel`)~(-772018723))] ,ball,((t37495428==t85475964)==(t90744128==t95143411)))
                end 
                for t18950149,collisionBall in pairs(table["balls"] ) do 
                    if ball["entity"] ~=collisionBall["entity"]  and not collisionBall["disabled"]  then 
                        local t24757934=#(ball["position"] -collisionBall["position"] )-t81994342*((`patriot`|`zion2`)~(-1052871))
                        if t24757934<(((`furia`|`vamos`)~44638722)/10000) then 
                            t88460647(ball,collisionBall)
                        end 
                    end 
                end 
            end 
        end 
    end 
    return t47409820 
end 

t97582376=function(table,tableName,ball)
    local t74939636=t70418405 ball["position"] =ball["position"] +ball["velocity"] *(((`stingergt`|`regina`)~(-1647621))/(`rapidgt2`~1737773271))/t74939636 
    local t13931979=ball["velocity"] /#ball["velocity"] t71113510(table["pocketColliders"] ,ball,tableName)ball["velocity"] =vector2(math["max"] (ball["velocity"] ["x"] -t13931979["x"] *(((`buccaneer`|`stalion`)~(-134822113))-t13505160)/t74939636),math["max"] (ball["velocity"] ["y"] -t13931979["y"] *((`surfer`~699456150)-t13505160)/t74939636))
end

t71113510=function(pocketColliders,ball,tableName)
    for t18950149,pocket in pairs(pocketColliders) do 
        local t89762445=#(ball["position"] -pocket["xy"] )
        if t89762445<(t81994342+t55525476) then 
            ball["velocity"] =vector2(((`penumbra`~(-377465520))/1),(((`gauntlet4`|`comet2`)~(-202481834))/1))ball["position"] =pocket["xy"] ball["disabled"] =((t28666375==t19648303)==(t95811077==t67269091))t14047830(pocket)
            local t35867419=_G["GetEntityCoords"] (ball["entity"] )_G["SetEntityCoordsNoOffset"] (ball["entity"] ,pocket["x"] ,pocket["y"] ,pocket["z"] ,((t59726593==t90613034)==(t37708837 and t33385772)),((t17370919==t58290652)==(t89344772 and t86482037)),((t17084341==t30318774)==(t14090512 and t28212118)))
            Citizen["CreateThread"] (function()
                local t87774688=((`dominator2`~(-915704871))/1)
                TriggerServerEvent("mercy-pool:pocketed",tableName,ball["ballNum"] )
                while t87774688<((`blista2`~1039032025)/10) and ball["disabled"]  do 
                    _G["Wait"] ((`deveste`~1591739866))t87774688=t87774688+((`monroe`~(-433375716))/10)*_G["GetFrameTime"] ()_G["SetEntityCoordsNoOffset"] (ball["entity"] ,pocket["x"] ,pocket["y"] ,pocket["z"] -t87774688,((t31916296==t5459625)==(t11999099 and t18059927)),((t51757275==t57604693)==(t80366333 and t56571182)),((t47690301==t5645596)==(t17602621 and t36202777)))
                end 
                _G["SetEntityCoordsNoOffset"] (ball["entity"] ,t35867419["x"] ,t35867419["y"] ,t35867419["z"] ,((t31763861==t95823272)==(t85997293 and t13233825)),((t52955416==t1374359)==(t4548062 and t20065975)),((t95420843==t61415576)==(t61711300 and t91414843)))_G["DeleteObject"] (ball["entity"] )ball["entity"] =(t84921099 or t82631521)
            end )
        end 
    end 
end 

t22160437=function(entity,t3746252)
    local t12752130=((`cheetah`~(-1311154695))/100)
    local t72046414=vector2((-0.84283),(-1.225585))
    local t84247335=vector2(0.697048,1.482726)
    local t78384674=t34196728[t3746252] 
    return {_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] -(((`prairie`|`thrax`)~(-1078075400))/100),t72046414["y"] +t78384674["y"] -((`banshee`~(-1041692463))/100),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] +(((`vagrant`|`riata`)~(-1396707624))/100),t72046414["y"] +t78384674["y"] -(((`deviant`|`regina`)~(-12583094))/100),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t84247335["x"] +t78384674["x"] +((`nemesis`~(-634879115))/100),t84247335["y"] +t78384674["y"] +((`penetrator`~(-1758137367))/100),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t72046414["x"] +t78384674["x"] -((`caracara2`~(-1349095617))/100),t84247335["y"] +t78384674["y"] +((`hotknife`~37348243)/100),t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t78384674["x"] +(-0.92),((`zorrusso`~(-682108672))/1000)+t78384674["y"] ,t12752130),_G["GetOffsetFromEntityInWorldCoords"] (entity,t78384674["x"] +(((`hellion`|`jugular`)~(-68270542))/100),((`tezeract`~1031562269)/100)+t78384674["y"] ,t12752130)} 
end

local t96987878=(t81082778 or t24910369)
local t46339724=(t62967367 or t54275506)
local t98564059=((t72156167==t67455062)==(t11550939 and t8944296))
local t24620742=(t20386090 or t48723812)hasCue=((t4727935==t75835955)==(t8416870 and t33010781))t98115899=((t61753982==t10328408)==(t82009585 and t99271359))

Citizen["CreateThread"] (function()
    t96987878=_G["GetHashKey"] ("prop_pool_rack_01")t46339724=_G["GetHashKey"] ("prop_pool_rack_02")
    if Config["AllowTakePoolCueFromStand"] ==(t46290945 or t69656228) then 
        Config["AllowTakePoolCueFromStand"] =((t74549401==t80896807)==(t10041830==t94484890))
    end 
    while Config["AllowTakePoolCueFromStand"]  do 
        _G["Wait"] (((`schafter3`|`bestiagts`)~(-268634533)))
        local t68525158=_G["PlayerPedId"] ()
        local t20224508=_G["GetEntityCoords"] (t68525158)_G["Wait"] ((`pfister811`~(-1829802492)))
        local t61208264=_G["GetClosestObjectOfType"] (t20224508["x"] ,t20224508["y"] ,t20224508["z"] ,((`neon`~(-1848994064))/1),t96987878,((t27227386==t15904492)==(t3484063 and t89140509)),((t9267459==t99393307)==(t81149850 and t18447113)),((t90521572==t78942587)==(t79991342 and t85561328)))_G["Wait"] ((`adder`~(-1216765595)))
        local t9624157=_G["GetClosestObjectOfType"] (t20224508["x"] ,t20224508["y"] ,t20224508["z"] ,((`cheetah2`~223240019)/1),t46339724,((t69964147==t81567523)==(t98015292 and t7828469)),((t12203363==t15761203)==(t52937124 and t53616986)),((t96542767==t36696667)==(t47251287 and t59476599)))
        if t61208264==((`hermes`|`elegy2`)~(-553796297)) and t9624157>((`picador`|`burrito3`)~(-638059533)) then 
            t24620742=t9624157 
        elseif t61208264>((`dominator2`|`cognoscenti`)~(-805340167)) and t9624157==((`dynasty`|`sabregt`)~(-1677812523)) then 
            t24620742=t61208264 
        elseif t61208264>(`fagaloa`~1617472902) and t9624157>(`hotknife`~37348240) then 
            local t21870809=_G["GetEntityCoords"] (t61208264)local t74842077=_G["GetEntityCoords"] (t9624157)
            if (#(t21870809-t20224508)>#(t74842077-t20224508)) then 
                t24620742=t9624157 
            else 
                t24620742=t61208264
            end 
        else 
            t24620742=(t31565695 or t17346530)
        end 
        _G["Wait"] ((`sultan2`~872704284))
    end 
end )

Citizen["CreateThread"] (function()
    while ((t19392211==t89585620)==(t36282043==t14069171)) do 
        _G["Wait"] ((`cog55`~906642318))
        if t24620742 then 
            local t68525158=_G["PlayerPedId"] ()
            local t13465527=_G["GetEntityCoords"] (t68525158)
            local t10837542=_G["GetEntityCoords"] (t24620742)
            local t89762445=#(t13465527-t10837542)
            local t74759762=(((`emerus`|`regina`)~(-1584301))/10)
            if t89762445<t74759762 then 
                t98115899=((t7721765==t55827297)==(t44361114==t69040390))
                if hasCue then 
                    t38480160("TEB_POOL_RETURN_CUE",((`blista`|`manana`)~(-344729633)))
                else 
                    t38480160("TEB_POOL_TAKE_CUE",(`cog55`~906642318))
                end 
                local t16425820=_G["IsControlJustPressed"] ((`z190`~838982985),t61549719(Config["Keys"] ["ENTER"] ["code"] )) or _G["IsDisabledControlJustPressed"] (((`sandking`|`nero`)~(-1113227309)),t61549719(Config["Keys"] ["ENTER"] ["code"] ))
                if t16425820 then 
                    if hasCue then 
                        t82427258()
                    else 
                        t24916467()
                    end 
                end 
            else 
                _G["Wait"] ((`rebel`~(-1207771982)))t98115899=((t6554110==t62336285)==(t31641912 and t39373431))
            end 
        else
            _G["Wait"] (((`felon2`|`yosemite`)~(-4328329)))
        end 
    end 
end )

t47123242=Config["PropsToRemove"]  or {vector3(1992.803,(((`faggio2`|`washington`)~1809745007)/1000),46.22865)}
local t55626083={`prop_pool_ball_01`,`prop_poolball_1`,`prop_poolball_2`,`prop_poolball_3`,`prop_poolball_4`,`prop_poolball_5`,`prop_poolball_6`,`prop_poolball_7`,`prop_poolball_8`,`prop_poolball_9`,`prop_poolball_10`,`prop_poolball_11`,`prop_poolball_12`,`prop_poolball_13`,`prop_poolball_14`,`prop_poolball_15`,`prop_poolball_cue`,`prop_pool_cue`,`prop_pool_tri`}

Citizen["CreateThread"] (function()
    for t18950149,pos in pairs(t47123242) do 
        for t18950149,t3746252 in pairs(t55626083) do 
            _G["Wait"] ((`rocoto`~2136773105))_G["CreateModelHideExcludingScriptObjects"] (pos["x"] ,pos["y"] ,pos["z"] ,((`cheetah2`~223240014)/1),t3746252,((t13264312==t90704495)==(t3130413==t98091510)))
        end 
    end 
end )


BALL_SETUP_STRAIGHT_POOL={
    {(`oracle`~1348744439)},
    {(`tailgater`~(-1008861756)),(`emperor`~(-685276544))},
    {((`ellie`|`wolfsbane`)~(-9243663)),(`felon2`~(-89291290)),(`huntley`~486987404)},
    {(`tempesta`~272929382),((`cheetah`|`sultan`)~(-1176797200)),(`surge`~(-1894894181)),((`everon`|`cogcabrio`)~(-1745519192))},
    {((`surge`|`rapidgt2`)~(-274827855)),(`drafter`~686471172),(`rhapsody`~841808266),(`bestiagts`~1274868359),(`buffalo2`~736902329)}
}

BALL_SETUP_8_BALL= {
    {((`jugular`|`cyclone`)~(-201337226))},
    {((`tampa`|`bati`)~(-101069601)),(`voltic`~(-1622444099))},
    {((`elegy`|`zhaba`)~1337965173),((`regina`|`jester3`)~(-13444253)),(`burrito3`~(-1743316010))},
    {((`entity2`|`gb200`)~(-237244710)),(`buccaneer2`~(-1013450929))},
    {(`ztype`~758895625)}
}

t44172094=function(entity,ballNumbers)
    local t72046414=vector2((-0.84283),(-1.225585))
    local t84247335=vector2(0.697048,1.482726)
    local t12752130=(((`prairie`|`panto`)~(-271779845))/100)
    local t78384674=t34196728[_G["GetEntityModel"] (entity)] 
    local t43757470=_G["GetOffsetFromEntityInWorldCoords"] (entity,((`sentinel2`~(-873639462))/100)+t78384674["x"] ,((`daemon`~(-2006142381))/1000)+t78384674["y"] ,t12752130)
    local t9172949=_G["GetEntityHeading"] (entity)-(((`fagaloa`|`revolter`)~(-403902552))/1)
    local t77146899=(t24919515 or t20547671)
    local t60696081={}table["insert"] (t60696081,{["entity"]=(t97600668 or t28129803),["velocity"]=vector2((((`bjxl`|`schafter2`)~(-1212425381))/1),((`xa21`~917809321)/1)),["position"]=_G["GetOffsetFromEntityInWorldCoords"] (entity,(-0.043)+t78384674["x"] ,((`osiris`~1987143663)/1000)+t78384674["y"] ,t12752130)["xy"] ,["ballNum"]=(`bestiagts`~(-1274868364))})t77146899=#t60696081 
    for ballRowNum,ballRow in pairs(ballNumbers) do 
        for ballNumIdx,ballNum in pairs(ballRow) do 
            local t56470574=ballRowNum-((`pariah`|`baller2`)~1002287094)
            local t52080438=(((`guardian`|`specter2`)~(-1033904318))/1000)
            local t481088=(ballNumIdx)*(t81994342*((`tornado`|`bison`)~(-2819))+t52080438)-((t81994342*((`exemplar`|`nero2`)~(-5112964))+t52080438)*#ballNumbers[ballRowNum] /(`schafter2`~(-1255452399)))
            local t48077487=_G["GetOffsetFromEntityInWorldCoords"] (entity,((`cavalcade`~(-2006918067))/10000)-t481088+t78384674["x"] ,(((`casco`|`yosemite`)~(-2142699480))/100)+t78384674["y"] -t56470574*(0.0693+t52080438),t12752130)table["insert"] (t60696081,{["entity"]=(t39620376 or t81143753),["velocity"]=vector2((((`zion2`|`neo`)~(-1074856006))/1),((`reaper`~234062309)/1)),["position"]=t48077487["xy"] ,["ballNum"]=ballNum})
        end 
    end 
    return {["cueBallIdx"]=t77146899,["balls"]=t60696081} 
end 

t82460794=function()
    balls[t51894467] ["disabled"] =(t24145144 or t54821224)
    local t12752130=(((`faggio2`|`italigtb2`)~(-478488670))/100)+t81994342 
    local t29294409=_G["GetOffsetFromEntityInWorldCoords"] (TableEntity,((`novak`~(-1829436850))/1),(((`bf400`|`imorgon`)~(-1115932059))/1),t12752130)
    local t4453552=_G["GetEntityHeading"] (TableEntity)_G["SetEntityCoordsNoOffset"] (balls[t51894467] ["entity"] ,balls[t51894467] ["position"] ["x"] ,balls[t51894467] ["position"] ["y"] ,t29294409["z"] ,((t46733007==t80973025)==(t12078366 and t75878637)),((t87713714==t68793444)==(t45132437 and t99777444)),((t8407723==t44086730)==(t65183776 and t30291336)))
    for t14044781=((`vamos`~(-49115651))/1),(((`torero`|`flashgt`)~(-33823363))/10),(((`pariah`|`tampa`)~1006227451)/10) do 
        for invert=((`cogcabrio`|`autarch`)~688641),(`xls`~1203490607),(`deviant`~1279262539) do 
            local t56894345=_G["GetOffsetFromEntityInWorldCoords"] (TableEntity,((`vagner`~(-1939284557))/10)+t78384674["x"] +t14044781*invert,((`infernus2`~(-1405938523))/1000)+t78384674["y"] ,t12752130)["xy"] 
            if not t1197534(balls[t51894467] ["entity"] ,t56894345) then 
                balls[t51894467] ["position"] =t56894345 t7697375=t18626986 t11374114(t4453552+(((`chino2`|`oracle2`)~(-271065273))/1))
                return  
            end 
            _G["Wait"] ((`turismo2`~(-982130927)))
        end 
    end 
end 

t99795736=function(pos)
    local t28513940=math["floor"] (pos["x"] *(`sanchez`~788045388))/(`fugitive`~1909141489)
    local t61186923=math["floor"] (pos["y"] *((`sc1`|`lynx`)~1556084097))/((`faction2`|`blista`)~(-8978475))
    return t28513940.."/"..t61186923 
end

t17276409=function(t43068463,cueBallEntity,t81463867)
    local t3746252=_G["GetEntityModel"] (t43068463)
    local t72046414,t84247335=_G["GetModelDimensions"] (t3746252)
    local t78384674=t34196728[t3746252] 
    local t6337652=_G["GetOffsetFromEntityInWorldCoords"] (t43068463,((`torero`~1504306555)/10)+t78384674["x"] ,t84247335["y"] +t78384674["y"] +(((`comet3`|`torero`)~(-537133570))/10),((`serrano`~1337041429)/1))
    local t58540646=_G["GetOffsetFromEntityInWorldCoords"] (t43068463,(((`specter2`|`mesa`)~(-1989138254))/10)+t78384674["x"] ,t84247335["y"] +t78384674["y"] +((`visione`~(-998177789))/10),((`gauntlet3`~722226636)/1))
    local t20678765=_G["GetOffsetFromEntityInWorldCoords"] (t43068463,((`schafter2`~1255452390)/10)+t78384674["x"] ,t72046414["y"] +t78384674["y"] -(((`schafter2`|`tampa`)~(-1107568232))/10),(((`cogcabrio`|`rapidgt`)~(-1615331425))/1))
    local t96417770=_G["GetOffsetFromEntityInWorldCoords"] (t43068463,(((`dynasty`|`rebla`)~385785822)/10)+t78384674["x"] ,t72046414["y"] +t78384674["y"] -((`yosemite2`~1693751652)/10),(((`baller`|`patriot`)~(-808452230))/1))
    local t9441235=_G["GetEntityCoords"] (cueBallEntity)local t76558499=vector3(math["cos"] (math["rad"] (t81463867-((`rebel`~(-1207771828))/1))),math["sin"] (math["rad"] (t81463867-((`cheetah`~(-1311154774))/1))),(((`serrano`|`zorrusso`)~(-537396355))/1))
    local t81802273,t74284164=t86963732((t9441235+t76558499)["xy"] ,t9441235["xy"] ,{{t6337652["xy"] ,t96417770["xy"] },{t96417770["xy"] ,t20678765["xy"] },{t20678765["xy"] ,t58540646["xy"] },{t6337652["xy"] ,t58540646["xy"] }})
    return vector3(t81802273["x"] ,t81802273["y"] ,t96417770["z"] ) 
end 

t86963732=function(aimLineStart,aimLineEnd,intersectionLines)
    local t84174166=99999999.0 
    local t19931832=(t15489868 or t44739154)
    for t18950149,line in pairs(intersectionLines) do 
        local t81369357,t89521597=t41931295(aimLineStart,aimLineEnd,line[((`dominator2`|`issi7`)~(-269486082))] ["xy"] ,line[((`rebel2`|`ninef2`)~(-1359757495))] ["xy"] )
        local t89762445=#(vector2(t81369357,t89521597)-aimLineStart)
        if t89762445<t84174166 then 
            t84174166=t89762445 t19931832=vector2(t81369357,t89521597)
        end 
    end 
    return t19931832,t84174166 
end 

t41931295=function(s1,e1,s2,e2)
    local t39812445=(s1["x"] -e1["x"] )*(s2["y"] -e2["y"] )-(s1["y"] -e1["y"] )*(s2["x"] -e2["x"] )
    local t74756713=s1["x"] *e1["y"] -s1["y"] *e1["x"] 
    local t53473696=s2["x"] *e2["y"] -s2["y"] *e2["x"] 
    local t14044781=(t74756713*(s2["x"] -e2["x"] )-(s1["x"] -e1["x"] )*t53473696)/t39812445 
    local t97521401=(t74756713*(s2["y"] -e2["y"] )-(s1["y"] -e1["y"] )*t53473696)/t39812445 
    return t14044781,t97521401 
end

Citizen["CreateThread"] (function()
    while ((t92362991==t77558474)==(t68674545==t75089022)) do 
        local t8093707=((`cheburek`|`zombiea`)~(-942149656))
        local t74650009=((t7633352==t32065682)==(t11743008 and t7587622))
        for t18950149,table in pairs(t99667691) do 
            if table["entity"]  then 
                for t18950149,ball in pairs(table["balls"] ) do 
                    if not ball["disabled"]  and ball["entity"]  and ball["entity"] >(`alpha`~767087018) then 
                        local t89616107=_G["GetEntityCoords"] (ball["entity"] )
                        if ball["position"] ["x"] ~=t89616107["x"]  or ball["position"] ["y"] ~=t89616107["y"]  then 
                            if t8093707<=(`enduro`~1753414259) then 
                                _G["Wait"] (((`sentinel2`|`huntley`)~1024917165))t8093707=(`bati`~(-114291514))
                            end t8093707=t8093707-((`esskey`|`huntley`)~2102327180)t74650009=((t83869296==t8307116)==(t89606961==t87680178))_G["SetEntityCoordsNoOffset"] (ball["entity"] ,ball["position"] ["x"] ,ball["position"] ["y"] ,t89616107["z"] ,((t99975610==t94030633)==(t17422747 and t85869247)),((t50458526==t40013659)==(t91192288 and t19547695)),((t14124047==t66073999)==(t31019976 and t39291116)))
                        end 
                    end 
                end 
            end 
        end 
        if t49360992 then 
            _G["Wait"] (((`carbonrs`|`deveste`)~1592505818))
        else 
            _G["Wait"] (((`gargoyle`|`savestra`)~1040119329))
        end 
    end 
end )