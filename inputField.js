InputField = function() {
  
  this.create = function(x, y, w, h) {
    var textInput = document.createElement("input");
    textInput.setAttribute("type", "text");
    textInput.setAttribute("id", "textInput");
    textInput.setAttribute("onkeydown", "if (event.keyCode == 13) document.getElementById('confirmInput').click()");
    var confirmInput = document.createElement("input");
    confirmInput.setAttribute("type", "button");
    confirmInput.setAttribute("id", "confirmInput");
    confirmInput.setAttribute("value", "OK");
    confirmInput.setAttribute("onclick", "function() {);
    confirmInput.setAttribute();
    confirmInput.setAttribute();
    var parent = document.getElementById("content");
    parent.appendChild(textInput);
  }
}
