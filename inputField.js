// pointer to the instance of the input field, so it can be accessed from HTML
var inputFieldInstance;

// class to handle the input field for the player name after a new highscore has been set. also handles the twitter button that goes with it
function InputField() {
  
  // is the input field visible?
  var hidden = true;
  // has the player clicked the submit button
  var scoreSubmitted = false;
  
  // make this instance of the input field the global instance
  inputFieldInstance = this;
  
  // make the input Field visible
  this.show = function(score) {
    // input field
    $("#scoreDialog").show();
    // set focus to the input field
    $("#playerNameInput").focus();
    
    // twitter button
    $("#tweetBtn").show();
    // recreate it with the new highscore in the default text
    // erase the old one first
    $('#tweetBtn iframe').remove();
    // create new one
    var text = "I just achieved a new highscore of " + score + " at ";
    var tweetBtn = $('<a></a>')
        .addClass('twitter-share-button')
        .attr('href', 'http://twitter.com/share')
        .attr('data-url', 'http://motorero.frogcp.com')
        .attr('data-text',text)
        .attr('data-count', 'none')
        .attr('data-size', 'large');
    $('#tweetBtn').append(tweetBtn);
    twttr.widgets.load();
    
    // update state variables
    hidden = false;
    scoreSubmitted = false;
  }
  
  // hide the input field
  this.hide = function() {
     $("#scoreDialog").hide();
     $("#tweetBtn").hide();
    // update state
    hidden = true;
  }
  
  // return the name the player has entered 
  this.getPlayer = function() {
    return $("#playerNameInput").val();
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
