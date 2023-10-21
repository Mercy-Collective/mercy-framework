CurrentBusinessData = {};
MyBusinessRank = "Employee";

$(document).on('click', '.phone-employment-business', function(e){
    $('.phone-employment-businesses-wrapper').hide();
    $('.phone-employment-employees-wrapper').show();
    CurrentBusinessData = JSON.parse($(this).attr("businessdata"));

    LoadEmployeeList();
})

$(document).on('click', '.phone-employment-employees-back', function(e){
    $('.phone-employment-employees-wrapper').hide();
    $('.phone-employment-businesses-wrapper').show();
    CurrentBusinessData = {}
})

$(document).on('click', '.phone-employment-employee #employment-changeRole', function(e){
    var Employee = JSON.parse($(this).parent().parent().parent().attr("EmployeeData"));

    CreatePhoneInput([
        {
            Name: 'state_id',
            Label: 'State ID',
            Icon: 'fas fa-id-card',
            Type: 'input',
            Value: Employee.CitizenId,
            Disabled: true,
        },
        {
            Name: 'rank',
            Label: 'Role',
            Icon: 'fas fa-user-tag',
            Type: 'input-choice',
            Choices: GenerateRankChoices(false)
        },
    ],
    [
        {
            Name: 'cancel',
            Label: "Cancel",
            Color: "warning",
            Callback: () => { $('.phone-input-wrapper').hide(); }
        },
        {
            Name: 'submit',
            Label: "Submit",
            Color: "success",
            Callback: (Result) => {
                $('.phone-input-wrapper').hide();
                SetPhoneLoader(true);

                $.post("https://mercy-phone/Employment/SetEmployeeRank", JSON.stringify({
                    BusinessName: CurrentBusinessData.name,
                    Result: Result
                }), function(Result){
                    SetPhoneLoader(false);
                    if (Result.Success){
                        ShowPhoneCheckmark();
                        RefreshBusinessData();
                    } else {
                        ShowPhoneError(Result.Fail);
                    }
                })
            }
        }
    ])
})

$(document).on('click', '.phone-employment-employee #employment-payEmployee', function(e){
    var Employee = JSON.parse($(this).parent().parent().parent().attr("EmployeeData"));

    CreatePhoneInput([
        {
            Name: 'state_id',
            Label: 'State Id',
            Icon: 'fas fa-id-card',
            Type: 'input',
            Value: Employee.CitizenId,
            Disabled: true,
        },
        {
            Name: 'amount',
            Label: 'Amount',
            Icon: 'fas fa-dollar-sign',
            Type: 'input',
            InputType: "number",
        },
        {
            Name: 'comment',
            Label: 'Comment',
            Icon: false,
            Type: 'textarea',
            MaxChars: 255,
        },
    ],
    [
        {
            Name: 'cancel',
            Label: "Cancel",
            Color: "warning",
            Callback: () => { $('.phone-input-wrapper').hide(); }
        },
        {
            Name: 'submit',
            Label: "Submit",
            Color: "success",
            Callback: (Result) => {
                $('.phone-input-wrapper').hide();
                SetPhoneLoader(true);

                Result['comment'] = SanitizeHtml(Result['comment'])
                
                $.post('https://mercy-phone/Employment/PayExternal', JSON.stringify({
                    BusinessName: CurrentBusinessData.name,
                    Result: Result,
                }), function(Result){
                    SetPhoneLoader(false);
                    if (Result.Success) {
                        ShowPhoneCheckmark();
                    } else {
                        ShowPhoneError(Result.FailMessage);
                    }
                });
            }
        }
    ]);
})

$(document).on('click', '.phone-employment-employee #employment-fire', function(e){
    var Employee = JSON.parse($(this).parent().parent().parent().attr("EmployeeData"));

    DoPhoneText('Are you sure you want to fire this person?', [
        {
            Name: 'cancel',
            Label: "Cancel",
            Color: "warning",
            Callback: () => { $('.phone-text-wrapper').hide(); }
        },
        {
            Name: 'submit',
            Label: "Submit",
            Color: "success",
            Callback: (Result) => {
                $('.phone-text-wrapper').hide();

                $.post("https://mercy-phone/Employment/RemoveEmployee", JSON.stringify({
                    BusinessName: CurrentBusinessData.name,
                    CitizenId: Employee.CitizenId,
                }), function(Result){
                    if (Result.Success){
                        ShowPhoneCheckmark();
                        RefreshBusinessData();
                    } else {
                        ShowPhoneError(Result.Fail);
                    }
                })
            }
        }
    ], { Center: true });
})

$(document).on('click', '.phone-employment-employees-options', function(e){
    var Options = [];
    var Permissions = GetRankPermissions(MyBusinessRank);

    if (Permissions['hire']) {
        Options.push({
            Icon: 'fas fa-user-plus',
            Text: 'Hire',
            Callback: () => {
                CreatePhoneInput([
                    {
                        Name: 'state_id',
                        Label: 'State Id',
                        Icon: 'fas fa-id-card',
                        Type: 'input',
                    },
                    {
                        Name: 'rank',
                        Label: 'Role',
                        Icon: 'fas fa-user-tag',
                        Type: 'input-choice',
                        Choices: GenerateRankChoices(true)
                    },
                ],
                [
                    {
                        Name: 'cancel',
                        Label: "Cancel",
                        Color: "warning",
                        Callback: () => { $('.phone-input-wrapper').hide(); }
                    },
                    {
                        Name: 'submit',
                        Label: "Submit",
                        Color: "success",
                        Callback: (Result) => {
                            $('.phone-input-wrapper').hide();
                            $.post("https://mercy-phone/Employment/AddEmployee", JSON.stringify({
                                BusinessName: CurrentBusinessData.name,
                                Result: Result
                            }), function(Result){
                                if (Result.Success){
                                    ShowPhoneCheckmark();
                                    RefreshBusinessData();
                                } else {
                                    ShowPhoneError(Result.Fail);
                                }
                            })
                        }
                    }
                ])
            }
        })
    };

    if (Permissions['pay_external']) {
        Options.push({
            Icon: 'fas fa-hand-holding-usd',
            Text: 'Pay External',
            Callback: () => {
                CreatePhoneInput([
                    {
                        Name: 'state_id',
                        Label: 'State Id',
                        Icon: 'fas fa-id-card',
                        Type: 'input',
                    },
                    {
                        Name: 'amount',
                        Label: 'Amount',
                        Icon: 'fas fa-dollar-sign',
                        Type: 'input',
                        InputType: "number",
                    },
                    {
                        Name: 'comment',
                        Label: 'Comment',
                        Icon: false,
                        Type: 'textarea',
                        MaxChars: 255,
                    },
                ],
                [
                    {
                        Name: 'cancel',
                        Label: "Cancel",
                        Color: "warning",
                        Callback: () => { $('.phone-input-wrapper').hide(); }
                    },
                    {
                        Name: 'submit',
                        Label: "Submit",
                        Color: "success",
                        Callback: (Result) => {
                            $('.phone-input-wrapper').hide();
                            SetPhoneLoader(true);

                            Result['comment'] = SanitizeHtml(Result['comment'])
                         
                            $.post('https://mercy-phone/Employment/PayExternal', JSON.stringify({
                                BusinessName: CurrentBusinessData.name,
                                Result: Result,
                            }), function(Result){
                                SetPhoneLoader(false);
                                if (Result.Success) {
                                    ShowPhoneCheckmark();
                                } else {
                                    ShowPhoneError(Result.FailMessage);
                                }
                            });
                        }
                    }
                ])
            }
        })
    }

    if (Permissions['charge_external']) {
        Options.push({
            Icon: 'fas fa-credit-card',
            Text: 'Charge Customer',
            Callback: () => {
                CreatePhoneInput([
                    {
                        Name: 'state_id',
                        Label: 'State Id',
                        Icon: 'fas fa-id-card',
                        Type: 'input',
                    },
                    {
                        Name: 'amount',
                        Label: 'Amount',
                        Icon: 'fas fa-dollar-sign',
                        Type: 'input',
                        InputType: "number",
                    },
                    {
                        Name: 'comment',
                        Label: 'Comment',
                        Icon: false,
                        Type: 'textarea',
                        MaxChars: 255,
                    },
                ],
                [
                    {
                        Name: 'cancel',
                        Label: "Cancel",
                        Color: "warning",
                        Callback: () => { $('.phone-input-wrapper').hide(); }
                    },
                    {
                        Name: 'submit',
                        Label: "Submit",
                        Color: "success",
                        Callback: (Result) => {
                            $('.phone-input-wrapper').hide();

                            $.post("https://mercy-phone/Employment/ChargeCustomer", JSON.stringify({
                                BusinessName: CurrentBusinessData.name,
                                StateId: Result['state_id'],
                                Amount: Number(Result['amount']),
                                Comment: SanitizeHtml(Result['comment'])
                            }), function(Success){
                                if (Success) {
                                    Notification({
                                        Title: "Employment",
                                        Message: "Customer charge was succesfully paid.",
                                        Icon: "fas fa-handshake",
                                        IconBgColor: "#1d1d1d",
                                        IconColor: "white",
                                        Duration: 3000,
                                    });
                                } else {
                                    Notification({
                                        Title: "Employment",
                                        Message: "Customer charge was denied or customer does not have enough money!",
                                        Icon: "fas fa-handshake",
                                        IconBgColor: "#1d1d1d",
                                        IconColor: "white",
                                        Duration: 3000,
                                    });
                                }
                            })
                        }
                    }
                ])
            }
        })
    };

    if (Permissions['change_role']) {
        Options.push({
            Icon: 'fas fa-user-tag',
            Text: 'Create Role',
            Callback: () => {
                CreatePhoneInput([
                    {
                        Name: 'name',
                        Label: 'Name',
                        Icon: false,
                        Type: 'input',
                    },
                ],
                [
                    {
                        Name: 'cancel',
                        Label: "Cancel",
                        Color: "warning",
                        Callback: () => { $('.phone-input-wrapper').hide(); }
                    },
                    {
                        Name: 'submit',
                        Label: "Submit",
                        Color: "success",
                        Callback: (Result) => {
                            $('.phone-input-wrapper').hide();

                            Result['name'] = SanitizeHtml(Result['name'])
        
                            $.post("https://mercy-phone/Employment/CreateRank", JSON.stringify({
                                BusinessName: CurrentBusinessData.name,
                                Result: Result,
                            }), function(Success){
                                if (Success) {
                                    ShowPhoneCheckmark();
                                    RefreshBusinessData();
                                } else {
                                    ShowPhoneError("Failed to create rank..");
                                }
                            });
        
                        }
                    }
                ],
                [
                    {
                        Name: "hire",
                        Label: "Hire",
                        Checked: false,
                    },
                    {
                        Name: "fire",
                        Label: "Fire",
                        Checked: false,
                    },
                    {
                        Name: "change_role",
                        Label: "Change Role",
                        Checked: false,
                    },
                    {
                        Name: "pay_employee",
                        Label: "Pay Employee",
                        Checked: false,
                    },
                    {
                        Name: "pay_external",
                        Label: "Pay External",
                        Checked: false,
                    },
                    {
                        Name: "charge_external",
                        Label: "Charge External",
                        Checked: false,
                    },
                    {
                        Name: "property_keys",
                        Label: "Property Keys",
                        Checked: false,
                    },
                    {
                        Name: "stash_access",
                        Label: "Stash Access",
                        Checked: false,
                    },
                    {
                        Name: "craft_access",
                        Label: "Craft Access",
                        Checked: false,
                    },
                    {
                        Name: "account_access",
                        Label: "Account Access",
                        Checked: false,
                    }
                ])
            }
        });

        Options.push({
            Icon: 'fas fa-user-tag',
            Text: 'Edit Role',
            Callback: () => {
                CreatePhoneInput([
                    {
                        Name: 'name',
                        Label: 'Name',
                        Icon: false,
                        Type: 'input-choice',
                        Choices: GenerateRankChoices(false, (Rank) => {
                            $(`.phone-input-container #hire`).find('input').prop("checked", Rank.Permissions['hire'])
                            $(`.phone-input-container #fire`).find('input').prop("checked", Rank.Permissions['fire'])
                            $(`.phone-input-container #change_role`).find('input').prop("checked", Rank.Permissions['change_role'])
                            $(`.phone-input-container #pay_employee`).find('input').prop("checked", Rank.Permissions['pay_employee'])
                            $(`.phone-input-container #pay_external`).find('input').prop("checked", Rank.Permissions['pay_external'])
                            $(`.phone-input-container #charge_external`).find('input').prop("checked", Rank.Permissions['charge_external'])
                            $(`.phone-input-container #property_keys`).find('input').prop("checked", Rank.Permissions['property_keys'])
                            $(`.phone-input-container #stash_access`).find('input').prop("checked", Rank.Permissions['stash_access'])
                            $(`.phone-input-container #craft_access`).find('input').prop("checked", Rank.Permissions['craft_access'])
                            $(`.phone-input-container #account_access`).find('input').prop("checked", Rank.Permissions['account_access'])
                        })
                    },
                ],
                [
                    {
                        Name: 'cancel',
                        Label: "Cancel",
                        Color: "warning",
                        Callback: () => { $('.phone-input-wrapper').hide(); }
                    },
                    {
                        Name: 'submit',
                        Label: "Submit",
                        Color: "success",
                        Callback: (Result) => {
                            $('.phone-input-wrapper').hide();
        
                            $.post("https://mercy-phone/Employment/EditRank", JSON.stringify({
                                BusinessName: CurrentBusinessData.name,
                                Result: Result,
                            }), function(Success){
                                if (Success) {
                                    ShowPhoneCheckmark();
                                    RefreshBusinessData();
                                } else {
                                    ShowPhoneError("Failed to save rank..");
                                }
                            });
                        }
                    }
                ],
                [
                    {
                        Name: "hire",
                        Label: "Hire",
                        Checked: false,
                    },
                    {
                        Name: "fire",
                        Label: "Fire",
                        Checked: false,
                    },
                    {
                        Name: "change_role",
                        Label: "Change Role",
                        Checked: false,
                    },
                    {
                        Name: "pay_employee",
                        Label: "Pay Employee",
                        Checked: false,
                    },
                    {
                        Name: "pay_external",
                        Label: "Pay External",
                        Checked: false,
                    },
                    {
                        Name: "charge_external",
                        Label: "Charge External",
                        Checked: false,
                    },
                    {
                        Name: "property_keys",
                        Label: "Property Keys",
                        Checked: false,
                    },
                    {
                        Name: "stash_access",
                        Label: "Stash Access",
                        Checked: false,
                    },
                    {
                        Name: "craft_access",
                        Label: "Craft Access",
                        Checked: false,
                    },
                    {
                        Name: "account_access",
                        Label: "Account Access",
                        Checked: false,
                    },
                ])
            }
        });

        Options.push({
            Icon: 'fas fa-user-tag',
            Text: 'Delete Role',
            Callback: () => {
                CreatePhoneInput([
                    {
                        Name: 'name',
                        Label: 'Name',
                        Icon: false,
                        Type: 'input-choice',
                        Choices: GenerateRankChoices(false)
                    },
                ],
                [
                    {
                        Name: 'cancel',
                        Label: "Cancel",
                        Color: "warning",
                        Callback: () => { $('.phone-input-wrapper').hide(); }
                    },
                    {
                        Name: 'submit',
                        Label: "Delete",
                        Color: "success",
                        Callback: (Result) => {
                            $('.phone-input-wrapper').hide();
        
                            Result['name'] = SanitizeHtml(Result['name'])

                            $.post("https://mercy-phone/Employment/RemoveRank", JSON.stringify({
                                BusinessName: CurrentBusinessData.name,
                                Result: Result,
                            }), function(Success){
                                if (Success) {
                                    ShowPhoneCheckmark();
                                    RefreshBusinessData();
                                } else {
                                    ShowPhoneError("Failed to remove rank..");
                                }
                            });
                        }
                    }
                ])
            }
        });
    }

    BuildDropdown(Options);
})

Phone.addNuiListener('RenderEmployedBusinesses', (Data) => {
    $('.phone-employment-businesses').empty();
    if (Data.Businesses.length == 0) {
        DoPhoneEmpty(".phone-employment-businesses");
        return;
    };

    Data.Businesses.sort((A, B) => A.name.localeCompare(B.name));

    for (let i = 0; i < Data.Businesses.length; i++) {
        const Business = Data.Businesses[i];

        var Employees = JSON.parse(Business.employees);

        for (let EmployeeId = 0; EmployeeId < Employees.length; EmployeeId++) {
            const Employee = Employees[EmployeeId];

            if (Employee.CitizenId == Data.CitizenId) {
                MyBusinessRank = Employee.Rank;
                break
            }
        }

        $('.phone-employment-businesses').append(`<div businessdata='${JSON.stringify(Business)}' businessName='${Business.name}' class="phone-employment-business">
            <div class="phone-employment-businesses-icon"><i class="${Business.logo}"></i></div>
            <div class="phone-employment-businesses-name">${Business.name}</div>
            <div class="phone-employment-businesses-rang">${MyBusinessRank}</div>
        </div>`);
    };
});

var LoadEmployeeList = () => {
    var Employees = JSON.parse(CurrentBusinessData.employees);
    $('.phone-employment-employees').empty();

    // Should never happen, but just in case.
    if (Employees.length == 0) {
        DoPhoneEmpty(".phone-employment-employees");
        return;
    };

    Employees.sort((A, B) => A.Name.localeCompare(B.Name));

    var HoverElement = ``;
    var MyPermissions = GetRankPermissions(MyBusinessRank);

    if (MyPermissions.fire || MyPermissions.change_role || MyPermissions.pay_employee) {
        HoverElement = `<div class="phone-employment-employee-hover"><div class="phone-employment-employee-hover-icons">`

        if (MyPermissions.change_role) HoverElement += `<i data-tooltip="Change Role" id="employment-changeRole" class="fas fa-user-tag"></i>`;
        if (MyPermissions.pay_employee) HoverElement += `<i data-tooltip="Pay" id="employment-payEmployee" class="fas fa-hand-holding-usd"></i>`;
        if (MyPermissions.fire) HoverElement += `<i data-tooltip="Remove Employee" id="employment-fire" class="fas fa-user-times"></i>`;

        HoverElement += '</div></div>'
    }

    for (let i = 0; i < Employees.length; i++) {
        const Elem = Employees[i];

        $('.phone-employment-employees').append(`<div EmployeeData='${JSON.stringify(Elem)}' class="phone-employment-employee">
            ${HoverElement}
            <div class="phone-employment-employee-icon"><i class="fas ${Elem.Rank == 'Owner' ? 'fa-user-secret' : 'fa-user-tie'}"></i></div>
            <div class="phone-employment-employee-name">${Elem.Name}</div>
            <div class="phone-employment-employee-rang">${Elem.Rank}</div>
        </div>`);
    };
}

var RefreshBusinessData = () => {
    $.post("https://mercy-phone/Employment/GetSpecificBusiness", JSON.stringify({
        Name: CurrentBusinessData.name
    }), function(Retval){
        // Not an employee anymore, or business was deleted.
        if (Retval == false) {
            ShowPhoneError("You are no longer an employee of this business..");
            $('.phone-employment-employees-wrapper').hide();
            $('.phone-employment-businesses-wrapper').show();
            CurrentBusinessData = {}
            return;
        };

        CurrentBusinessData = Retval;
        $(`.phone-employment-business[businessName='${CurrentBusinessData.name}']`).attr("businessdata", JSON.stringify(CurrentBusinessData));
        LoadEmployeeList();
    });
}

var GenerateRankChoices = (ForceAll, OnRankClick) => {
    var Retval = [];
    var Ranks = JSON.parse(CurrentBusinessData['ranks'])
    Ranks = Object.values(Ranks);

    for (let i = 0; i < Ranks.length; i++) {
        const Rank = Ranks[i];
        if (Rank.Default == false || ForceAll) {
            Retval.push({
                Icon: false,
                Text: Rank.Name,
                OnClick: () => {
                    if (OnRankClick) OnRankClick(Ranks[i]);
                }
            })
        }
    }

    return Retval
}

var GetRankPermissions = (RankName) => {
    var Ranks = JSON.parse(CurrentBusinessData['ranks'])
    return Ranks[RankName].Permissions;
}