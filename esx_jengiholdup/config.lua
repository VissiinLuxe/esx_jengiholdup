Config = {}
Config.Locale = 'fi'

Config.PoliceNumberRequired = 2 -- Montako jengiläistä tarvitaan
Config.TarvittavatPoliisitAloitukseen = 2 -- Montako poliisia tarvitaan
Config.TimerBeforeNewRob    = 3600 -- The cooldown timer on a store after robbery was completed / canceled, in seconds

Config.MaxDistance    = 4   -- max distance from the robbary, going any longer away from it will to cancel the robbary
Config.GiveBlackMoney = false -- give black money? If disabled it will give cash instead



Gangs = {
	["Kaappi"] = {
		position = {x = 108.04,  y = -742.4,  z = 242.16 },
		reward = math.random(10000, 20000),
		nameOfStore = "Kassakaappi",
		secondsRemaining = 30, -- seconds
		lastRobbed = 0
	}
}
