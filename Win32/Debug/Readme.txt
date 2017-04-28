Das vorliegende Programm simuliert einen Supermarkt. Dabei wird ermittelt wie die durchschnitliche Wartezeit der einzelnen Kunden von der Anzahl der Kassen abhängig ist. Dabei fließt auch ein wie Schnell die zu kaufende Ware erfasst wird und wieviele Kunden pro Minute den Supermarkt nutzen wollen.


Grundeinstellungen
	Anzahl Kassen 	: Anzahl der Kassen die der simulierte Supermarkt haben soll.
	Kundenkapazität : Anzahl der Kunden die gleichzeitig den Supermarkt betreten können.
	Kunden / Minute (ca.) : Anzahl der Kunden die den Supermarkt pro Minute betreten. Dies ist der Maximalwert.
	Mindestalter 	: Mindestalter der erstellten Kunden
	Höchstalter 	: Maximales Alter der erstellten Kunden.
	Minimaler Bargeldbestand 	: Kleinstmöglicher Bargeldbestand den die Kunden bei sich führen
	Maximaler Bargeldbestand 	: Höchstmöglicher Bargeldbestand den die Kunden bei sich führen
	Simulierte Geschwindigkeit	: Legt fest wie viele Minuten pro Sekunde simuliert werden sollen.

Zufallsparameter
	Mindestalter für Kleingeldmodus : Alter ab dem wahrscheinlich ist, dass der Kunde mit Kleingeld zahlen 	
									  möchte und den Kassiervorgang aufhält
	Kleingeldzahler (Alt) in %		: Anteil der Kunden die mit Kleingeld zahlen wollen wenn sie älter als das 
									  angegebene Mindestalter sind
	Kleingeldzahler (Rest) in %		: Anteil der Kunden die mit Kleingeld zahlen wollen wenn sie jünger als das 
									  angegebene Mindestalter sind
	maximal gescannte Ware / Minuten: legt fest wieviele Artikel maximal pro Minute durch den Kassierer erfasst 
									  werden können.
	Flashmobquote in Promille: Gibt die Wahrscheinlichkeit in 1 / 1000 für einen Kundenansturm an.

Diagramme
	Kassenübersicht: 	
		Grafische Darstellung der Supermarktkassen auf der X-Achse, die Anzahl der Kunden in 
		den Warteschlangen wir auf der Y-Achse dargestellt.
	
	Wartezeit im Durchschnitt:
		Grafische Darstellung der durchschnittlichen Wartezeiten
		Schwarzer Graph - die Entwicklung der Wartezeit über den gesamten Simulationszeitraum
		Blauer Graph 	- die durchschnittliche Wartezeit der letzten Stunde

	Anzahl der Kunden im Markt:
		Grafische Darstellung der Gesamtanzahl der Kunden die sich im Supermarkt aufhielten.


!!!!!!!!!! HINWEISE ZUR BENUTZUNG: !!!!!!!!!!!
Die Datei Sortiment.txt muss sich im selben Ordner Befinden wie die EXE der Simulation.