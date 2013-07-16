// pointer to the instance of the input field, so it can be accessed from HTML
var inputFieldInstance;

function InputField() {
  
  // is the input field visible?
  var hidden = true;
  // has the player clicked the submit button
  var scoreSubmitted = false;
  
  // make this instance of the input field the global instance
  inputFieldInstance = this;
  
  // make the input Field visible
  this.show = function() {
    document.getElementById("scoreDialog").style.display = "block";
    // set focus to the input field
    document.getElementById("playerNameInput").focus();
    // update state variables
    hidden = false;
    scoreSubmitted = false;
  }
  
  // hide the input field
  this.hide = function() {
    document.getElementById("scoreDialog").style.display = "none";
    // update state
    hidden = true;
  }
  
  // return the name the player has entered 
  this.getPlayer = function() {
    return document.getElementById("playerNameInput").value;
  }
  
  // getters and setters for state
  this.isHidden = function() {
    return hidden;
  }
  
  this.clickSubmit = function() {
    scoreSubmitted = true;
  }
  
  this.isScoreSubmitted = function() {
    return scoreSubmitted;
  }
}
