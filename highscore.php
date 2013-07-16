<?php
	// In Processing, we access everything through the URL string, so everything is a GET. Add a method attribute to the query to differentiate between the different access modes
	if (!isset($_GET['method'])) {
		$_GET['method'] = 'get'; // default method is get
	}
	$method = $_GET['method'];
	
	if ($method == 'get') {
		// number of highscores to display
		if (!isset($_GET['number'])) {
			$_GET['number'] = 10; // default of 10 for getting the score
		}
		$number = $_GET['number'];
		
		if ($db = new SQLite3('highscores.db')) {
			
			$statement = $db->prepare('SELECT Player, Score FROM Highscores ORDER BY SCORE DESC LIMIT :number');
			$statement->bindValue(':number', $number);
			$result = $statement->execute();
			if ($result) {
				$output = "";
				while($entry = $result->fetchArray(SQLITE3_ASSOC)) {
					$output .= $entry['Player'] . ',' . $entry['Score'] . "\n";
				}
				// write output
				echo $output;
			}
		}
		else {
			die("Could not open highscores.db");
		}
	}
	else if ($method == 'post') {
		// player name
		if (!isset($_GET['player'])) {
			die('player name is mandatory');
		}
		$player = $_GET['player'];
		// player score
		$score = $_GET['score'];
		if (!isset($_GET['player'])) {
			die('score is mandatory');
		}
		
		if ($db = new SQLite3('highscores.db')) {
			$statement = $db->prepare('INSERT INTO Highscores (Player, Score) VALUES (:player, :score)');
			$statement->bindValue(':player', $player);
			$statement->bindValue(':score', $score);
			$result = $statement->execute();
		}
		else {
			die("Could not open highscores.db");
		}
	}
?>