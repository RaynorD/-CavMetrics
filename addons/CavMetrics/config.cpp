class CfgPatches {
	class CavMetrics {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {};
		author[] = {"7Cav"};
		authorUrl = "http://7cav.us";
	};
};

class CfgFunctions {
	class CavMetrics {
		class Common {
			class postInit { postInit = 1; file = "\CavMetrics\postInit.sqf"; };
		};
	};
};
