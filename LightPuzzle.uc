class LightPuzzle expands Actor;

var bool FoundLights;
var name SolvedEventBlue;
var name SolvedEventRed;
var bool PuzzleSolvedInProcessRed;
var bool PuzzleSolvedInProcessBlue;
var TriggerLight Light1Blue;
var TriggerLight Light2Blue;
var TriggerLight Light3Blue;
var TriggerLight Light4Blue;
var TriggerLight Light5Blue;
var TriggerLight Light6Blue;
var TriggerLight Light7Blue;
var TriggerLight Light8Blue;
var TriggerLight Light1Red;
var TriggerLight Light2Red;
var TriggerLight Light3Red;
var TriggerLight Light4Red;
var TriggerLight Light5Red;
var TriggerLight Light6Red;
var TriggerLight Light7Red;
var TriggerLight Light8Red;

simulated event PreBeginPlay() {

	Super.PreBeginPlay();

	Log("");
	Log("+--------------------------------------------------------------------------+");
	Log("| LightPuzzle                                                              |");
	Log("| ------------------------------------------------------------------------ |");
	Log("| Author:      Dizzy <dizzy@bunnytrack.net>                                |");
	Log("| Description: Triggers a mover when a bunch of TriggerLights are all lit  |");
	Log("| Version:     2017-12-01                                                  |");
	Log("| Website:     bunnytrack.net                                              |");
	Log("| ------------------------------------------------------------------------ |");
	Log("| Released under the Creative Commons Attribution-NonCommercial-ShareAlike |");
	Log("| license. See https://creativecommons.org/licenses/by-nc-sa/4.0/          |");
	Log("+--------------------------------------------------------------------------+");

	SolvedEventBlue = 'BlueSolvedMover';
	SolvedEventRed  = 'RedSolvedMover';
	PuzzleSolvedInProcessBlue = false;
	PuzzleSolvedInProcessRed  = false;

}

function Tick(float DeltaTime) {
	
	local TriggerLight L;
	
	Super.Tick(DeltaTime);
	
	if (!FoundLights) {

		// Assign all lights in the map to class variables for reference later
		foreach AllActors(class'TriggerLight', L) {

			if (string(L.Tag) == "LightTrigger1Blue") { Light1Blue = L; }
			if (string(L.Tag) == "LightTrigger2Blue") { Light2Blue = L; }
			if (string(L.Tag) == "LightTrigger3Blue") { Light3Blue = L; }
			if (string(L.Tag) == "LightTrigger4Blue") { Light4Blue = L; }
			if (string(L.Tag) == "LightTrigger5Blue") { Light5Blue = L; }
			if (string(L.Tag) == "LightTrigger6Blue") { Light6Blue = L; }
			if (string(L.Tag) == "LightTrigger7Blue") { Light7Blue = L; }
			if (string(L.Tag) == "LightTrigger8Blue") { Light8Blue = L; }

			if (string(L.Tag) == "LightTrigger1Red") { Light1Red = L; }
			if (string(L.Tag) == "LightTrigger2Red") { Light2Red = L; }
			if (string(L.Tag) == "LightTrigger3Red") { Light3Red = L; }
			if (string(L.Tag) == "LightTrigger4Red") { Light4Red = L; }
			if (string(L.Tag) == "LightTrigger5Red") { Light5Red = L; }
			if (string(L.Tag) == "LightTrigger6Red") { Light6Red = L; }
			if (string(L.Tag) == "LightTrigger7Red") { Light7Red = L; }
			if (string(L.Tag) == "LightTrigger8Red") { Light8Red = L; }

		}

		FoundLights = true;

		// Initially reset the puzzle (could also be done manually in UEd)
		ResetPuzzle("blue");
		ResetPuzzle("red");

	}
	 
	// Check if all lights are lit
	if (   Light1Blue.Alpha > 0
		&& Light2Blue.Alpha > 0
		&& Light3Blue.Alpha > 0
		&& Light4Blue.Alpha > 0
		&& Light5Blue.Alpha > 0
		&& Light6Blue.Alpha > 0
		&& Light7Blue.Alpha > 0
		&& Light8Blue.Alpha > 0) {

		PuzzleSolved("blue");

	}

	if (   Light1Red.Alpha > 0
		&& Light2Red.Alpha > 0
		&& Light3Red.Alpha > 0
		&& Light4Red.Alpha > 0
		&& Light5Red.Alpha > 0
		&& Light6Red.Alpha > 0
		&& Light7Red.Alpha > 0
		&& Light8Red.Alpha > 0) {

		PuzzleSolved("red");

	}

}

function PuzzleSolved(string TeamColor) {
	
	local name SolvedEvent;

	if (TeamColor == "blue") {
		if (!PuzzleSolvedInProcessBlue) {
			PuzzleSolvedInProcessBlue = true;
			TriggerSolvedEvent(SolvedEventBlue);
		}
	}

	if (TeamColor == "red") {
		if (!PuzzleSolvedInProcessRed) {
			PuzzleSolvedInProcessRed = true;
			TriggerSolvedEvent(SolvedEventRed);
		}
	}

}


simulated function Timer() {

	if (PuzzleSolvedInProcessBlue) {
		ResetPuzzle("blue");
	}

	if (PuzzleSolvedInProcessRed) {
		ResetPuzzle("red");
	}
	
}

function TriggerSolvedEvent(name E) {

	local Actor A;
	
	// Trigger the appropriate solved event
	foreach AllActors(class 'Actor', A, E) {
		A.Trigger(Self, Self.Instigator);
	}

	// Set a timer to reset the puzzle
	SetTimer(3, false);

}

function ResetPuzzle(optional string TeamColor) {

	if (TeamColor == "blue") {
		
		TurnLightOn(Light1Blue);
		TurnLightOn(Light2Blue);
		TurnLightOn(Light3Blue);
		TurnLightOn(Light4Blue);
		TurnLightOn(Light5Blue);

		TurnLightOff(Light6Blue);
		TurnLightOff(Light7Blue);
		TurnLightOff(Light8Blue);

		PuzzleSolvedInProcessBlue = false;

	}

	if (TeamColor == "red") {
		
		TurnLightOn(Light1Red);
		TurnLightOn(Light2Red);
		TurnLightOn(Light3Red);
		TurnLightOn(Light4Red);
		TurnLightOn(Light5Red);

		TurnLightOff(Light6Red);
		TurnLightOff(Light7Red);
		TurnLightOff(Light8Red);

		PuzzleSolvedInProcessRed = false;

	}

}

function TurnLightOn(TriggerLight L) {
	L.Alpha     = 0;
	L.Direction = -1;
	L.Trigger(Self, Self.Instigator);
}

function TurnLightOff(TriggerLight L) {
	L.Alpha     = 1;
	L.Direction = 1;
	L.Trigger(Self, Self.Instigator);
}