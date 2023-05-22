var Financials = RegisterApp('Financials');
var CurrentContextData = null;
var CurrentContextType = null;
var BankingOpen = false
var IsAtBank = false

OpenBankContainer = function(Data) {
    BankingOpen = true
    $('.main-bank-container').show();
    $('.main-bank-container').css('height', '20vh');
    $('.bank-banking-container').hide();
    $('.bank-accounts-container').hide();
    $('.bank-transactions-container').hide();
    $('.bank-loader').show();

    IsAtBank = Data['IsBank']
    SetCashBalance();
    SetupBankAccounts(Data['BankData'])

    setTimeout(function() {
        $('.bank-loader').hide();
        $('.main-bank-container').animate({
            height: '84vh'
        }, 500, function() {
            $('.my-cash-balance').show();
            $('.bank-accounts-container').show();
            $('.bank-transactions-container').show();
        });
        $('.financials-wrapper').css('pointer-events', 'auto');
    }, 2000);
}

CloseBankContainer = function() {
    $.post('https://mercy-financials/Financials/Close', JSON.stringify({IsAtBank: IsAtBank}));
    $('.main-bank-container').fadeOut(450, function() {
        $('.financials-wrapper').css('pointer-events', 'none');
        $('.my-cash-balance').hide();
        CloseBankContext();
        BankingOpen = false
        IsAtBank = false
    })
}

OpenBankContext = function(AccountId, AccountType, Type) {
    var ButtonText = Type
    CurrentContextType = Type
    $('.bank-banking-block-title').html(`${AccountType} Account / ${AccountId}`);
    $('.bank-banking-card-accept').html(ButtonText);

    if (ButtonText == 'Transfer') {
        $('.transfer-block').show();
        $('.bank-banking-block').css('height', '35vh');
    } else {
        $('.transfer-block').hide();
        $('.bank-banking-block').css('height', '30vh');
    }

    $('.bank-banking-container').show();
}

CloseBankContext = function() {
    $('.bank-input').val('');
    $('.bank-comment').val('');
    $('.banking-loader').hide();
    $('.bank-banking-data').show();
    $('.bank-banking-container').hide();
    CurrentContextData = null;
    CurrentContextType = null;
}

SetCashBalance = function() {
    $.post('https://mercy-financials/Financials/GetCash', JSON.stringify({}), function(Amount) {
        var TotalCash = AddCommas(Amount)
        $('.my-cash-balance').html(`Cash: $${TotalCash}.00`);
    });
}

SetupBankAccounts = function(Data, Refresh) {
    $('.bank-accounts').empty();
    $.each(Data, function(Key, Value) {
        var AccountType = Value.Type
        var RoundedBalance = AddCommas(Value.Balance)

        var Disabled = false;
        if (!Value.Active) { Disabled = true; }

        var AccountCardButtons = `<div class="bank-account-card-withdraw ${Disabled && 'bank-account-card-withdraw-disabled'}">Withdraw</div><div class="bank-account-card-deposit ${Disabled && 'bank-account-card-deposit-disabled'}">Deposit</div><div class="bank-account-card-transfer ${Disabled && 'bank-account-card-transfer-disabled'}">Transfer</div>`
        if (!IsAtBank) {
            AccountCardButtons = `<div class="bank-account-card-withdraw ${Disabled && 'bank-account-card-withdraw-disabled'}">Withdraw</div><div class="bank-account-card-transfer ${Disabled && 'bank-account-card-transfer-disabled'}">Transfer</div>`
        }

        var AccountCard = `<div class="bank-account-card ${Disabled && 'bank-account-card-disabled'}" id="bank-card-${Value.AccountId}">
        <div class="bank-account-card-title">${AccountType} Account / ${Value.AccountId}</div>
        <div class="bank-account-card-name">${Value.AccountName}</div>
        <div class="bank-account-card-owner">${Value.AccountOwner}</div>
            <div class="bank-account-card-balance-data">
                <div class="bank-account-card-balance">$${RoundedBalance}.00</div>
                <div class="bank-account-card-subtext">Available Balance</div>
            </div>
            <div class="bank-account-card-buttons">
                ${AccountCardButtons}
            </div>
        </div>`

        $('.bank-accounts').append(AccountCard);
        $(`#bank-card-${Value.AccountId}`).data('BankData', Value);  
    });
    SetupTransactions(Data[0].Transactions)
}

SetupTransactions = async function(Transactions) {
    $('.bank-transactions').empty();
    $.each(Transactions, function(Key, Value) {
        if (Key <= 50) {
            var Amount = AddCommas(Value.Amount)
            var TimeDiffrence = CalculateTimeDifference(Value.Time)
            
            var TransactionType = `<div class="bank-transaction-card-amount bank-transaction-minus">-$${Amount}.00 <div class="bank-transaction-card-who">${Value.Who}</div></div>`
            if (Value.Type == 'Deposit' || Value.Type == 'Transfer Received') {
                TransactionType = `<div class="bank-transaction-card-amount bank-transaction-plus">+$${Amount}.00 <div class="bank-transaction-card-who">${Value.Who}</div></div>`
            }
    
            var Reason = ``
            if (Value.Reason != '') {
                Reason = `<div class="bank-transaction-card-line-dot"></div>
                <div class="bank-transaction-card-reason">${Value.Reason}</div>`
            }
    
            var TransactionCard = `<div class="bank-transaction-card">
                <div class="bank-transaction-card-title">${Value.Title} <div class="bank-transaction-card-id">${Value.Id}</div> </div>
                <div class="bank-transaction-card-line"></div>
                ${TransactionType}
                <div class="bank-transaction-card-info">${TimeDiffrence}</div>
                ${Reason}
            </div>`
    
            $('.bank-transactions').prepend(TransactionCard);
        }
    });
}

RefreshBankingData = function() {
    $.post('https://mercy-financials/Financials/GetAccounts', JSON.stringify({}), function(AccountData) {
        SetupBankAccounts(AccountData)
    });
    SetCashBalance();
}

$(document).on('click', '.bank-account-card-withdraw', function(e) {
    e.preventDefault();
    var Data = $(this).parent().parent().data("BankData")

    if (Data.Active) {
        OpenBankContext(Data.AccountId, Data.Type, 'Withdraw')
        CurrentContextData = Data
    }
});

$(document).on('click', '.bank-account-card-deposit', function(e) {
    e.preventDefault();
    var Data = $(this).parent().parent().data("BankData")

    if (Data.Active) {
        OpenBankContext(Data.AccountId, Data.Type, 'Deposit')
        CurrentContextData = Data
    }
});

$(document).on('click', '.bank-account-card-transfer', function(e) {
    e.preventDefault();
    var Data = $(this).parent().parent().data("BankData")
    
    if (Data.Active) {
        OpenBankContext(Data.AccountId, Data.Type, 'Transfer')
        CurrentContextData = Data
    }
});

$(document).on('click', '.bank-banking-card-cancel', function(e) {
    e.preventDefault();
    CloseBankContext()
});

$(document).on('click', '.bank-account-card', function(e) {
    e.preventDefault();
    var Data = $(this).data("BankData")
    SetupTransactions(Data.Transactions)
});

$(document).on('click', '.bank-banking-card-accept', function(e) {
    e.preventDefault();
    var Amount = $('.bank-input').val();
    var Reason = $('.bank-comment').val();

    if (Amount > 0) {
        $('.bank-banking-data').hide(0, function() {
            $('.banking-loader').show();
    
            setTimeout(function() {
                if (CurrentContextType == 'Withdraw') {
                    $.post('https://mercy-financials/Financials/Withdraw', JSON.stringify({Amount: Math.floor(Amount), Reason: Reason, AccountId: CurrentContextData.AccountId}), function(IsDone) {
                        if (IsDone) {
                            CloseBankContext();
                            setTimeout(function() {
                                RefreshBankingData();
                            }, 50);
                        } else {
                            $.post('https://mercy-financials/Financials/ErrorSound');
                            CloseBankContext();
                        }
                    });
                } else if (CurrentContextType == 'Deposit') {
                    $.post('https://mercy-financials/Financials/Deposit', JSON.stringify({Amount: Math.floor(Amount), Reason: Reason, AccountId: CurrentContextData.AccountId}), function(IsDone) {
                        if (IsDone) {
                            CloseBankContext();
                            setTimeout(function() {
                                RefreshBankingData();
                            }, 50);
                        } else {
                            $.post('https://mercy-financials/Financials/ErrorSound');
                            CloseBankContext();
                        }
                    });
                } else if (CurrentContextType == 'Transfer') {
                    var TransferNumber = $('.transfer-number').val();
                    $.post('https://mercy-financials/Financials/Transfer', JSON.stringify({Amount: Math.floor(Amount), Reason: Reason, ToAccountId: TransferNumber.toString(), AccountId: CurrentContextData.AccountId}), function(IsDone) {
                        if (IsDone) {
                            CloseBankContext();
                            setTimeout(function() {
                                RefreshBankingData();
                            }, 50);
                        } else {
                            $.post('https://mercy-financials/Financials/ErrorSound');
                            CloseBankContext();
                        }
                    });
                }
            }, 1500);
        });
    } else {
        $.post('https://mercy-financials/Financials/ErrorSound');
    }
});

Financials.addNuiListener('OpenBank', (Data) => {
    OpenBankContainer(Data)
});

$(document).on({
    keydown: function(e) {
        if (e.keyCode == 27 && BankingOpen) {
            CloseBankContainer();
        }
    },
});