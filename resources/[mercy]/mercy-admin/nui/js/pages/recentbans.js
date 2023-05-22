
MC.AdminMenu.BanList = {}
MC.AdminMenu.BanList.SelectedType = "all";
MC.AdminMenu.BanList.CreatedBanTypes = false;

// [ RECENT BANS ] \\

MC.AdminMenu.LoadBanList = function() {
    MC.AdminMenu.DebugMessage('^3Loading Bans.')
    if (MC.AdminMenu.Bans.length > 0) {
        $('.menu-page-recentbans-topbar').fadeIn(150);
        $('.menu-page-recentbans-types').empty();
        $('.admin-menu-bans').empty();
        $('.no-bans').hide();
        MC.AdminMenu.BuildTypes();
        MC.AdminMenu.LoadFilteredBanList(MC.AdminMenu.BanList.SelectedType);
    } else {
        $('.menu-page-recentbans-topbar').hide();
        $('.menu-page-recentbans-types').empty();
        $('.admin-menu-bans').empty();
        $('.no-bans').fadeIn(450);
        MC.AdminMenu.DebugMessage('No bans found.');
    }   
}

MC.AdminMenu.BuildTypes = function() {
    $('.menu-page-recentbans-types').empty();

    // Add select box
    let AllOption = `<select id="normal-select-1" placeholder-text="All"> <option value="0" data-Name="all" class="select-dropdown__list-item">All</option> </select>`;
    $('.menu-page-recentbans-types').append(AllOption);

    // Add Other
    for (let i = 0; i < MC.AdminMenu.BanTypes.length; i++) {
        let Category = MC.AdminMenu.BanTypes[i];
        let OptionElement = `<option value="${i + 1}" data-Name="${Category['Name']}" class="select-dropdown__list-item">${Category['Label']}</option>`;
        $('#normal-select-1').append(OptionElement);
    }
    createSelect()
}

MC.AdminMenu.LoadFilteredBanList = function(Type) {
    $('.admin-menu-bans').empty();
    MC.AdminMenu.BanList.SelectedType = Type;
    MC.AdminMenu.BanList.CreatedBanTypes = true;
    $.post(`https://${GetParentResourceName()}/GetDateDifference`, JSON.stringify({ 
        CType: Type,
        BanList: MC.AdminMenu.Bans,
    }), function(Data) {
        if (Data.Bans) {
            for (let i = 0; i < Data.Bans.length; i++) {
                let BannedPlayer = Data.Bans[i];
                MC.AdminMenu.BuildFilteredBanList(BannedPlayer, i);
            }
        }
    });
}

MC.AdminMenu.BuildFilteredBanList = function(BannedPlayer, PlayerId) {
    let ExpireHour = Number(BannedPlayer.Expires.hour) < 10 ? "0"+BannedPlayer.Expires.hour : BannedPlayer.Expires.hour
    let ExpireMinutes = Number(BannedPlayer.Expires.min) < 10 ? "0"+BannedPlayer.Expires.min : BannedPlayer.Expires.min
    let ExpireDate = `${BannedPlayer.Expires.day}/${BannedPlayer.Expires.month}/${BannedPlayer.Expires.year} | ${ExpireHour}:${ExpireMinutes}`
    let BanDateHour = Number(BannedPlayer.BannedOn.hour) < 10 ? "0"+BannedPlayer.BannedOn.hour : BannedPlayer.BannedOn.hour
    let BanDateMinutes = Number(BannedPlayer.BannedOn.min) < 10 ? "0"+BannedPlayer.BannedOn.min : BannedPlayer.BannedOn.min
    let BanDate = `${BannedPlayer.BannedOn.day}/${BannedPlayer.BannedOn.month}/${BannedPlayer.BannedOn.year} | ${BanDateHour}:${BanDateMinutes}`

    let BannedPElem = `<div class="admin-menu-ban waves-effect waves-light" id="player-ban-${PlayerId}">
                <div class="admin-menu-ban-name">${BannedPlayer.Name}</div>
                <div class="admin-menu-ban-arrow"><i class="fa-solid fa-chevron-down"></i></div>
                <div class="admin-menu-ban-options">
                    <div class="admin-menu-ban-option">
                        <div class="admin-menu-ban-option-title"><p>Identifiers</p></div>
                        <div class="admin-menu-ban-option-desc" id='recentbans-discord'>
                            <div class="admin-menu-ban-option-copy waves-effect waves-light"><i class="fa-solid fa-copy"></i></div>
                            <p>${BannedPlayer.Discord}</p>
                        </div>
                        <div class="admin-menu-ban-option-desc" id='recentbans-license'>
                            <div class="admin-menu-ban-option-copy waves-effect waves-light"><i class="fa-solid fa-copy"></i></div>
                            <p>${BannedPlayer.steam}</p>
                        </div>
                    </div>
                    <div class="admin-menu-ban-option">
                        <div class="admin-menu-ban-option-title"><p>Banned On</p></div>
                        <div class="admin-menu-ban-option-desc"><p>${BanDate}</p></div>
                    </div>
                    <div class="admin-menu-ban-option">
                        <div class="admin-menu-ban-option-title"><p>Ban Expires</p></div>
                        <div class="admin-menu-ban-option-desc"><p>${ExpireDate}</p></div>
                    </div>
                    <div class="admin-menu-ban-option">
                        <div class="admin-menu-ban-option-title"><p>Reason</p></div>
                        <div class="admin-menu-ban-option-desc"><p>${BannedPlayer.Reason}</p></div>
                    </div>
                    <div class="admin-menu-ban-option">
                        <div class="admin-menu-ban-option-title"><p>Banned By</p></div>
                        <div class="admin-menu-ban-option-desc"><p>${BannedPlayer.BannedBy}</p></div>
                    </div>
                    <div class="admin-menu-unban ui-styles-button error waves-effect waves-light">Unban</div>
                </div>
            </div>`;

    $('.admin-menu-bans').prepend(BannedPElem);
    $(`#player-ban-${PlayerId}`).data('BanData', BannedPlayer);

}

// Clicks

$(document).on('click', '.admin-menu-ban-option #recentbans-discord', function(e) {
    e.preventDefault();
    let Discord = $(this).find('p').text();
    MC.AdminMenu.Copy(Discord);
    MC.AdminMenu.ShowCheckmark();
});

$(document).on('click', '.admin-menu-ban-option #recentbans-license', function(e) {
    e.preventDefault();
    let License = $(this).find('p').text();
    MC.AdminMenu.Copy(License);
    MC.AdminMenu.ShowCheckmark();
});

$(document).on('click', '.menu-page-recentbans-types', function(e) {
    e.preventDefault();
    let Type = $('#normal-select-1').find(':selected').attr('data-Name');
    MC.AdminMenu.LoadFilteredBanList(Type)
});

$(document).on('click', '.admin-menu-unban', function(e) {
    let Data = $(this).parent().parent().data('BanData');
    $.post(`https://${GetParentResourceName()}/UnbanPlayer`, JSON.stringify({ 
        PData: Data, 
    }));
    MC.AdminMenu.ShowCheckmark();
    setTimeout(() => {
        MC.AdminMenu.LoadBanList();
    }, 600);
});

$(document).on('click', '.admin-menu-ban', function(e) {
    e.preventDefault();
    let OptionsDom = $(this).find('.admin-menu-ban-options');

    if (OptionsDom.hasClass('extended')) {
        if (!$(e.target).hasClass('admin-menu-ban-name')) return;
        OptionsDom.hide();
        OptionsDom.removeClass('extended');
        $(this).find('.admin-menu-ban-arrow').removeClass('open');
        $(this).find('.admin-menu-ban-arrow').addClass('closed');
    } else {
        OptionsDom.show();
        OptionsDom.addClass('extended');
        $(this).find('.admin-menu-ban-arrow').removeClass('closed');
        $(this).find('.admin-menu-ban-arrow').addClass('open');
    }
});

// Search

$(document).on('input', '#banslist-discordid', function(e){
    let SearchText = $(this).val().toLowerCase();

    $('.admin-menu-ban').each(function(Elem, Obj){
        if ($(this).find('#recentbans-discord').find('p').html().toLowerCase().includes(SearchText)) {
            $(this).fadeIn(150);
        } else {
            $(this).fadeOut(150);
        };
    });
});

$(document).on('input', '#banslist-license', function(e){
    let SearchText = $(this).val().toLowerCase();

    $('.admin-menu-ban').each(function(Elem, Obj){
        if ($(this).find('#recentbans-license').find('p').html().toLowerCase().includes(SearchText)) {
            $(this).fadeIn(150);
        } else {
            $(this).fadeOut(150);
        };
    });
});

// Select box

function createSelect() {
    var select = document.getElementsByTagName('select'),
      liElement,
      ulElement,
      optionValue,
      iElement,
      optionText,
      selectDropdown,
      elementParentSpan;

      for (var select_i = 0, len = select.length; select_i < len; select_i++) {
      select[select_i].style.display = 'none';
      wrapElement(document.getElementById(select[select_i].id), document.createElement('div'), select_i, select[select_i].getAttribute('placeholder-text'));

      for (var i = 0; i < select[select_i].options.length; i++) {
        liElement = document.createElement("li");
        optionValue = select[select_i].options[i].value;
        optionText = document.createTextNode(select[select_i].options[i].text);
        liElement.className = 'select-dropdown__list-item';
        liElement.setAttribute('data-value', optionValue);
        liElement.appendChild(optionText);
        ulElement.appendChild(liElement);

        liElement.addEventListener('click', function () {
          displyUl(this);
        }, false);
      }
    }
    function wrapElement(el, wrapper, i, placeholder) {
      el.parentNode.insertBefore(wrapper, el);
      wrapper.appendChild(el);

      document.addEventListener('click', function (e) {
        let clickInside = wrapper.contains(e.target);
        if (!clickInside) {
          let menu = wrapper.getElementsByClassName('select-dropdown__list');
          menu[0].classList.remove('active');
        }
      });

      var buttonElement = document.createElement("button"),
        spanElement = document.createElement("span"),
        spanText = document.createTextNode(placeholder);
        iElement = document.createElement("i");
        ulElement = document.createElement("ul");

      wrapper.className = 'select-dropdown select-dropdown--' + i;
      buttonElement.className = 'select-dropdown__button select-dropdown__button--' + i;
      buttonElement.setAttribute('data-value', '');
      buttonElement.setAttribute('type', 'button');
      spanElement.className = 'select-dropdown select-dropdown--' + i;
      iElement.className = 'zmdi zmdi-chevron-down';
      ulElement.className = 'select-dropdown__list select-dropdown__list--' + i;
      ulElement.id = 'select-dropdown__list-' + i;

      wrapper.appendChild(buttonElement);
      spanElement.appendChild(spanText);
      buttonElement.appendChild(spanElement);
      buttonElement.appendChild(iElement);
      wrapper.appendChild(ulElement);
    }

    function displyUl(element) {

      if (element.tagName == 'BUTTON') {
        selectDropdown = element.parentNode.getElementsByTagName('ul');
        //var labelWrapper = document.getElementsByClassName('js-label-wrapper');
        for (var i = 0, len = selectDropdown.length; i < len; i++) {
          selectDropdown[i].classList.toggle("active");
          //var parentNode = $(selectDropdown[i]).closest('.js-label-wrapper');
          //parentNode[0].classList.toggle("active");
        }
      } else if (element.tagName == 'LI') {
        var selectId = element.parentNode.parentNode.getElementsByTagName('select')[0];
        selectElement(selectId.id, element.getAttribute('data-value'));
        elementParentSpan = element.parentNode.parentNode.getElementsByTagName('span');
        element.parentNode.classList.toggle("active");
        elementParentSpan[0].textContent = element.textContent;
        elementParentSpan[0].parentNode.setAttribute('data-value', element.getAttribute('data-value'));
      }

    }
    function selectElement(id, valueToSelect) {
      var element = document.getElementById(id);
      element.value = valueToSelect;
      element.setAttribute('selected', 'selected');
    }
    var buttonSelect = document.getElementsByClassName('select-dropdown__button');
    for (var i = 0, len = buttonSelect.length; i < len; i++) {
      buttonSelect[i].addEventListener('click', function (e) {
				e.preventDefault();
				displyUl(this);
			}, false);
		}
}