Phone.addNuiListener('RenderCalculatorApp', (Data) => {
    let zero = document.getElementById('zeroButton')
    let one = document.getElementById('oneButton');
    let two = document.getElementById('twoButton');
    let three = document.getElementById('threeButton');
    let four = document.getElementById('fourButton');
    let five = document.getElementById('fiveButton');
    let six = document.getElementById('sixButton');
    let seven = document.getElementById('sevenButton');
    let eight = document.getElementById('eightButton');
    let nine = document.getElementById('nineButton');
    let comma = document.getElementById('commaButton');
    
    let percentage = document.getElementById('perc');
    let division = document.getElementById('division');
    let multiplication = document.getElementById('multiplicationButton');
    let subtract = document.getElementById('subtract');
    let plus = document.getElementById('plus');
    let equal = document.getElementById('equal');
    
    let changeSign = document.getElementById('change_sign');
    let clearAllKey = document.getElementById('AC');
    let textField = document.getElementById('text_area')
    let result = textField.innerHTML;
    
    equal.addEventListener('click', function (data) { 
        textField.innerHTML = eval(textField.innerHTML);
    });
    changeSign.addEventListener('click', function () { //finish the changeSign function
      let noPlus = - (textField.innerHTML);
      textField.innerHTML = noPlus;
    });
    clearAllKey.addEventListener('click', function () {
      textField.innerHTML = '0';
    });
    percentage.onclick = function() {
      textField.innerHTML /= 100;
    }
    comma.onclick = function() {
      textField.innerHTML += '.';
    }
    division.onclick = function() {
      textField.innerHTML += '/';
    }
    multiplication.onclick = function() {
      textField.innerHTML += '*';
    }
    subtract.onclick = function() {
      textField.innerHTML += '-';
    }
    plus.onclick = function() {
      textField.innerHTML += '+';
    }
    
    zero.onclick = function () {
      if (textField.innerHTML == '0') {
        textField.innerHTML = '0';
      } else {
        textField.innerHTML += '0';
      }
    }
    one.onclick = function () {
      if (textField.innerHTML == '0') {
        textField.innerHTML = '1';
      } else {
        textField.innerHTML += '1';
      }
    }
    two.onclick = function () {
      if (textField.innerHTML == '0') {
        textField.innerHTML = '2';
      } else {
        textField.innerHTML += '2';
      }
    }
    three.onclick = function () {
      if (textField.innerHTML == '0') {
        textField.innerHTML = '3';
      } else {
        textField.innerHTML += '3';
      }
    }
    four.onclick = function () {
      if (textField.innerHTML == '0') {
        textField.innerHTML = '4';
      } else {
        textField.innerHTML += '4';
      }
    }
    five.onclick = function () {
      if (textField.innerHTML == '0') {
        textField.innerHTML = '5';
      } else {
        textField.innerHTML += '5';
      }
    }
    six.onclick = function () {
      if (textField.innerHTML == '0') {
        textField.innerHTML = '6';
      } else {
        textField.innerHTML += '6';
      }
    }
    seven.onclick = function () {
      if (textField.innerHTML == '0') {
        textField.innerHTML = '7';
      } else {
        textField.innerHTML += '7';
      }
    }
    eight.onclick = function () {
      if (textField.innerHTML == '0') {
        textField.innerHTML = '8';
      } else {
        textField.innerHTML += '8';
      }
    }
    nine.onclick = function () {
      if (textField.innerHTML == '0') {
        textField.innerHTML = '9';
      } else {
        textField.innerHTML += '9';
      }
    }
});